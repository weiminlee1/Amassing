##Average CHIP-seq signal over promoters
#getting TSSes
Our goal is to look at the ChIP-seq signal over transcription start sites (TSSes) of genes. 
Typically in this sort of analysis we start with annotations; here we're using the annotations from Ensembl. 
If we're lucky, TSSes will already be annotated. Failing that, perhaps 5'UTRs are annotated, so we could take the 5' end of the 5'UTR as the TSS. Let's see what the Ensembl data gives us.
With only these featuretypes to work with, we would need to do the following to identify the TSS of each transcript:

    #find all exons for the transcript
    #sort the exons by start position
    #if the transcript is on the "+" strand, TSS is the start position of the first exon
    #if the transcript is on the "-" strand, TSS is the end position of the last exon
<b>gffutils is able to infer transcripts and genes from a GTF file.</b>

##create the database
> db = gffutils.create_db('file.gtf', dbfn='file.db', force=True, keep_order=True, merge_strategy='merge', sort_attribute_values=True)

<b> Once it is complete, from now on you just have to attach to the existing database_filename like this:</b>

>db = gffutils.FeatureDB(database_filename)

<b>Here we create a generator function that iterates through all annotated transcripts in the database. For each transcript, we convert it to a pybedtools.Interval and use the TSS function to give us the 1-bp position of the TSS, and save it as a new file.
Here is a general usage pattern for gffutils and pybedtools: do the work in a generator function, and pass the generator to pybedtools.BedTool. This uses very little memory, and scales well to hundreds of thousands of features.</b>

>import pybedtools
>
>from pybedtools.featurefuncs import TSS
>
>from gffutils.helpers import asinterval
>
>def tss_generator():
    """
    Generator function to yield TSS of each annotated transcript
    """
    for transcript in db.features_of_type('transcript'): #CDS/gene/mRNA...
        yield TSS(asinterval(transcript), upstream=1, downstream=0)

        # A BedTool made out of a generator, and saved to file.
>tsses = pybedtools.BedTool(tss_generator()).saveas('tsses.gtf')
>
>tsses_1kb = tsses.slop(b=1000, genome='species_name', output='tsses-1kb.gtf') #<b>genome=()</b>


##Creating the arrays

metaseq works with the concepts of signal and windows. In this example, the signal is ChIP data, and the windows are TSS +/- 1kb.

The first step is to create “genomic signal” objects out of the data. Since our example files are BAM files, we specify the kind=’bam’, but if you have your own data in a different format (bigWig, bigBed, BED, GFF, GTF, VCF) then specify that format instead (see :func:metaseq.genomic_signal()).

We need to pass the filenames of the BAM files:

>import metaseq

>ip_signal = metaseq.genomic_signal('wgEncodeHaibTfbsK562Atf3V0416101AlnRep1_chr17.bam','bam')

>input_signal = metaseq.genomic_signal('wgEncodeHaibTfbsK562RxlchV0416101AlnRep1_chr17.bam', 'bam')




Now we can create the arrays of signal over each window. Since this can be a time-consuming step, the first time this code is run it will cache the arrays on disk. The next time this code is run, it will be quickly loaded. Trigger a re-run by deleting the .npz file.

Here, with the BamSignal.array method, we bin each promoter region into 100 bins, and calculate the signal in parallel across as many CPUs as are available. We do this for the IP signal and input signals separately. Then, since these are BAM files of mapped reads, we scale the arrays to the library size. The scaled arrays are then saved to disk, along with the windows that were used to create them.

import multiprocessing
processes = multiprocessing.cpu_count()


##The signal is the IP ChIP-seq BAM file.

>ip_array = ip_signal.array(

    # Look at signal over these windows
    tsses_1kb,

    # Bin signal into this many bins per window
    bins=100,

    # Use multiple CPUs. Dramatically speeds up run time.
    processes=processes)

# Do the same thing for input.
>input_array = input_signal.array(
    tsses_1kb,
    bins=100,
    processes=processes)

##Normalize to library size. The values in the array will be in units of "reads per million mapped reads"
ip_array /= ip_signal.mapped_read_count() / 1e6
input_array /= input_signal.mapped_read_count() / 1e6

##Cache to disk. The data will be saved as "example.npz" and "example.features".
metaseq.persistence.save_features_and_arrays(
    features=tsses,
    arrays={'ip': ip_array, 'input': input_array},
    prefix='example',
    link_features=True,
    overwrite=True)
    
 
##Loading the arrays

Now that we’ve saved to disk, at any time in the future we can load the data without having to regenerate them:
>features, arrays = metaseq.persistence.load_features_and_arrays(prefix='example')

##Let’s do some double-checks.

## How many features?
assert len(features) == 5708

##This ought to be exactly the same as the number of features in <b>`tsses_1kb.gtf`</b>
assert len(features) == len(tsses_1kb) == 5708

## This shows that `arrays` acts like a dictionary
assert sorted(arrays.keys()) == ['input', 'ip']

## This shows that the IP and input arrays have one row per feature, and one column per bin
assert arrays['ip'].shape == (5708, 100) == arrays['input'].shape


##Line plot of average signal

Now that we have NumPy arrays of signal over windows, there’s a lot we can do. One easy thing is to simply plot the mean signal of IP and of input. Let’s construct meaningful values for the x-axis, from -1000 to +1000 over 100 bins. We'll do this with a NumPy array.

>import numpy as np
>
>x = np.linspace(-1000, 1000, 100) ## (a,b,c) c值可改变

##Then plot, using standard matplotlib commands:

## Import plotting tools
>from matplotlib import pyplot as plt
>from matplotlib.pyplot import plot, savefig ##for save picture

##Create a figure and axes
>plt.switch_backend('agg') ##important

>fig = plt.figure()

>ax = fig.add_subplot(111)


# Plot the IP:
>ax.plot(
    # use the x-axis values we created
    x,
    
    # axis=0 takes the column-wise mean, so with 
    # 100 columns we'll have 100 means to plot
    arrays['ip'].mean(axis=0),
    
    # Make it red
    color='r',

    # Label to show up in legend
    label='IP')

>savefig('file_name.pdf')
## Do the same thing with the input
>ax.plot(
    x,
    arrays['input'].mean(axis=0),
    color='k',
    label='input')


## Add a vertical line at the TSS, at position 0
>ax.axvline(0, linestyle=':', color='k')


## Add labels and legend
>ax.set_xlabel('Distance from TSS (bp)')

>ax.set_ylabel('Average read coverage (per million mapped reads)')

>ax.legend(loc='best')



##Adding a heatmap

Let's work on improving this plot, one step at a time.

We don't really know if this average signal is due to a handful of really strong peaks, or if it's moderate signal over many peaks. So one improvement would be to include a heatmap of the signal over all the TSSs.

##First, let's create a single normalized array by subtracting input from IP:

>normalized_subtracted = arrays['ip'] - arrays['input']

metaseq comes with some helper functions to simplify this kind of plotting. The metaseq.plotutils.imshow function is one of these; here the arguments are described:


## Tweak some font settings so the results look nicer
>plt.rcParams['font.family'] = 'Arial'

>plt.rcParams['font.size'] = 10

## the metaseq.plotutils.imshow function does a lot of work, we just have to give it the right arguments:
>fig = metaseq.plotutils.imshow(
    
    # The array to plot; here, we've subtracted input from IP.
    normalized_subtracted,
    
    # X-axis to use
    x=x,
    
    # Change the default figure size to something smaller for this example
    figsize=(3, 7),
    
    # Make the colorbar limits go from 5th to 99th percentile. 
    # `percentile=True` means treat vmin/vmax as percentiles rather than
    # actual values.
    percentile=True,
    vmin=5,
    vmax=99,
    
    # Style for the average line plot (black line)
    line_kwargs=dict(color='k', label='All'),
    
    # Style for the +/- 95% CI band surrounding the 
    # average line (transparent black)
    fill_kwargs=dict(color='k', alpha=0.3))



##Sorting the array

The array is not very meaningful as currently sorted. We can adjust the sorting this either by re-ordering the array before plotting, or using the sort_by kwarg when calling metaseq.plotutils.imshow. Let's sort the rows by their mean value:

>fig = metaseq.plotutils.imshow(
    
    # These are the same arguments as above.
    normalized_subtracted,
    x=x,
    figsize=(3, 7),
    vmin=5, vmax=99,  percentile=True,
    line_kwargs=dict(color='k', label='All'),
    fill_kwargs=dict(color='k', alpha=0.3),
    
    # This is new: sort by mean signal
    sort_by=normalized_subtracted.mean(axis=1))
    
    
##Customizing the axes styles

Let's go back to the sorted-by-mean version.
In [21]:

>fig = metaseq.plotutils.imshow(
    normalized_subtracted,
    x=x,
    figsize=(3, 7),
    vmin=5, vmax=99,  percentile=True,
    line_kwargs=dict(color='k', label='All'),
    fill_kwargs=dict(color='k', alpha=0.3),
    sort_by=normalized_subtracted.mean(axis=1)
)


##now we'll make some tweaks to the plot. The figure returned by metaseq.plotutils.imshow has attributes array_axes, line_axes, and cax, which can be used as an easy way to get handles to the axes for further configuration. Let's make some additional tweaks:


## "line_axes" is our handle for working on the lower axes.
 ##Add some nicer labels.
>fig.line_axes.set_ylabel('Average enrichment');
>
fig.line_axes.set_xlabel('Distance from TSS (bp)');

# "array_axes" is our handle for working on the upper array axes.
# Add a nicer axis label
fig.array_axes.set_ylabel('Transcripts on chr17')

##Remove the x tick labels, since they're redundant with the line axes
fig.array_axes.set_xticklabels([])

## Add a vertical line to indicate zero in both the array axes and the line axes
fig.array_axes.axvline(0, linestyle=':', color='k')
fig.line_axes.axvline(0, linestyle=':', color='k')

fig.cax.set_ylabel("Enrichment")



##Integrating with RNA-seq expression data

Often we want to compare ChIP-seq data with RNA-seq data. But RNA-seq data typically is presented as gene ID, while ChIP-seq data is presented as genomic coords. These can be tricky to reconcile.

We will use example data from ATF3 knockdown experiments them to subset the ChIP signal by those TSSs that were affected by knockdown and those that were not.

This example uses pre-processed data downloaded from GEO. We'll use a simple (and naive) 2-fold cutoff to identify transcripts that went up, down, or were unchanged upon ATF3 knockdown. In real-world analysis, you'd probaby have a table from DESeq2 or edgeR analysis that you would use instead.
RNA-seq data wrangling: loading data

The metaseq.results_table module has tools for working with this kind of data (for example, the metaseq.results_table.DESeq2Results class). Here, we will make a generic ResultsTable which handles any kind of tab-delimited data. It's important to specify the index column. This is the column that contains the transcript IDs in these files.


>from metaseq.results_table import ResultsTable

control = ResultsTable(
    os.path.join(data_dir, 'GSM847565_SL2585.table'),
    import_kwargs=dict(index_col=0))

knockdown = ResultsTable(
    os.path.join(data_dir, 'GSM847566_SL2592.table'),
    import_kwargs=dict(index_col=0))
    
   
 
##RNA-seq data wrangling: aligning RNA-seq data with ChIP-seq data

We should ensure that control and knockdown have their transcript IDs in the same order as the rows in the heatmap array, and that they only contain transcript IDs from chr17.

The ResultsTable.reindex_to method is very useful for this -- it takes a pybedtools.BedTool object and re-indexes the underlying dataframe so that the order of the dataframe matches the order of the features in the file. In this way we can re-align RNA-seq data to ChIP-seq data for more direct comparison.

Remember the tsses_1kb object that we used to create the array? That defined the order of the rows in the array. We can use that to re-index the dataframes. Let's look at the first line from that file to see how the transcript ID information is stored:
