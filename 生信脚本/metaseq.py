#!/bin/env/py
import gffutils
db = gffutils.create_db('tair10.gtf', dbfn='tair10.db', force=True, keep_order=True,
merge_strategy='merge', sort_attribute_values=True) #输入gtf或gff文件

db = gffutils.FeatureDB('tair10.db')
import pybedtools

from pybedtools.featurefuncs import TSS

from gffutils.helpers import asinterval

def tss_generator(): 
	for transcript in db.features_of_type('mRNA'): #CDS/gene/mRNA... 
		yield TSS(asinterval(transcript), upstream=1, downstream=0)

tsses = pybedtools.BedTool(tss_generator()).saveas('tsses.gtf')
tsses_1kb = tsses.slop(b=1000, genome='hg19', output='tsses-1kb.gtf') #疑问是基因组文件

import metaseq
ip_signal = metaseq.genomic_signal('arp6_H2A_Z.sort.bam','bam') #输入突变体chip-seq比对后的bam文件
#input_signal = metaseq.genomic_signal('WT_H2A_Z.sort.bam','bam') #输入野生型的bam文件

import multiprocessing
processes = multiprocessing.cpu_count()

ip_array = ip_signal.array(

    # Look at signal over these windows
    tsses_1kb,

    # Bin signal into this many bins per window
    bins=100,

    # Use multiple CPUs. Dramatically speeds up run time.
    processes=processes)
#input_array = input_signal.array(
#    tsses_1kb,
#    bins=100,
#    processes=processes)

ip_array /= ip_signal.mapped_read_count() / 1e6
#input_array /= input_signal.mapped_read_count() / 1e6
metaseq.persistence.save_features_and_arrays(
    features=tsses,
    arrays={'ip': ip_array},
    prefix='example',
    link_features=True,
    overwrite=True)


features, arrays = metaseq.persistence.load_features_and_arrays(prefix='example')

import numpy as np

x = np.linspace(-1000, 1000, 100)
from matplotlib import pyplot as plt
from matplotlib.pyplot import plot, savefig
plt.switch_backend('agg')
fig = plt.figure()
ax = fig.add_subplot(111)
ax.plot(x,arrays['ip'].mean(axis=0),color='r',label='arp6_H2AZ')
ax.axvline(0, linestyle=':', color='blue')
ax.set_xlabel('Distance from TSS (bp)')
ax.set_ylabel('Average read coverage (per million mapped reads)')
ax.legend(loc='best')
savefig('arp6_H2AZ_plot1.pdf')

normalized_subtracted = arrays['ip'] 
plt.rcParams['font.family'] = 'Arial'
plt.rcParams['font.size'] = 10

fig = metaseq.plotutils.imshow(
# The array to plot; here, we've subtracted input from IP.
    normalized_subtracted,
    
    # X-axis to use
    x=x,
    
    # Change the default figure size to something smaller for this example
    figsize=(8, 12),
    
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
    fill_kwargs=dict(color='r', alpha=0.3), sort_by=normalized_subtracted.mean(axis=1))


fig.line_axes.set_ylabel('Average enrichment');
fig.line_axes.set_xlabel('Distance from TSS (bp)');

# "array_axes" is our handle for working on the upper array axes.
# Add a nicer axis label
fig.array_axes.set_ylabel('Transcripts on arp6')

# Remove the x tick labels, since they're redundant
# with the line axes
#fig.array_axes.set_xticklabels([])

# Add a vertical line to indicate zero in both the array axes
# and the line axes
fig.array_axes.axvline(0, linestyle=':', color='blue')
fig.line_axes.axvline(0, linestyle=':', color='blue')

fig.cax.set_ylabel("Enrichment")
savefig('arp6_H2AZ_plot2.pdf')


##Integrating with RNA-seq expression

from metaseq.results_table import ResultsTable

control = ResultsTable('diff_gene.txt', import_kwargs=dict(index_col=0)) #输入RNA-seq文件

print len(control.data)
control.data.head()


##RNA-seq data wrangling: aligning RNA-seq data with ChIP-seq data

print tsses_1kb[0]

# Re-align the ResultsTables to match the GTF file
control = control.reindex_to(tsses, attribute='gene_id')
#knockdown = knockdown.reindex_to(tsses, attribute='transcript_id')

print len(control)
control.data.head()

# Join the dataframes and create a new pandas.DataFrame.
data = control.data#.join(knockdown.data, lsuffix='_control', rsuffix='_knockdown')

# Add a log2 fold change variable
#data['log2foldchange'] = np.log2(data)#.fpkm_knockdown / data.fpkm_control)
data.head()

import pands as pd
data.to_csv('data.csv')

# How many transcripts on chr17 changed expression?

#print "up:", sum(data.log2foldchange > 1)
#print "down:", sum(data.log2foldchange < -1)

#Integrating RNA-seq data with the heatmap

fig = metaseq.plotutils.imshow(
    # Same as before...
    normalized_subtracted,
    x=x,
    figsize=(8, 12),
    vmin=5, vmax=99,  percentile=True,
    line_kwargs=dict(color='k', label='All'),
    fill_kwargs=dict(color='k', alpha=0.3),
    sort_by=normalized_subtracted.mean(axis=1),
    
    
    # Default was (3,1); here we add another number 
    height_ratios=(3, 1, 1)
)

# `fig.gs` contains the `matplotlib.gridspec.GridSpec` object,
# so we can now create the new axes.
bottom_axes = plt.subplot(fig.gs[2, 0])

# This is a pandas.Series
#class1 = (data.log2FC < 1.5) #(data.log2foldchange < -11)
log2FC1 = (1 <= data.log2FC) & (data.log2FC <= 1.5) #(-11 <= data.log2foldchange) & (data.log2foldchange <-2)
log2FC2 = (1.5 < data.log2FC) & (data.log2FC <= 2.5) #( -2 <= data.log2foldchange) & (data.log2foldchange < 4)
log2FC3 = (data.log2FC > 2.5) #( 4 <= data.log2foldchange) & (data.log2foldchange < 15)

# This gets us the underlying boolean NumPy array which we
# can use to subset the array
#index = class1.values
#index

# This is the subset of the array where the TSS of the transcript
# went up in the ATF3 knockdown
#class1_chipseq_signal = normalized_subtracted[index, :]
#class1_chipseq_signal

# We can combine the above steps into the following:
#subset = normalized_subtracted[(data.log2foldchange > 1).values, :]

# Signal over TSSs of transcripts that were activated upon knockdown.
metaseq.plotutils.ci_plot(
    x,
    normalized_subtracted[log2FC1.values, :],
    line_kwargs=dict(color='dodgerblue', label='log2FC1'),
    fill_kwargs=dict(color='dodgerblue', alpha=0),
    ax=bottom_axes)

# Signal over TSSs of transcripts that were repressed upon knockdown
metaseq.plotutils.ci_plot(
    x,
    normalized_subtracted[log2FC2.values, :],
    line_kwargs=dict(color='darkgoldenrod', label='log2FC2'),
    fill_kwargs=dict(color='darkgoldenrod', alpha=0),
    ax=bottom_axes)

# Signal over TSSs tof transcripts that did not change upon knockdown
metaseq.plotutils.ci_plot(
    x,
    normalized_subtracted[log2FC3.values, :],
    line_kwargs=dict(color='darkorchid', label='log2FC3'),
    fill_kwargs=dict(color='darkorchid', alpha=0),
    ax=bottom_axes)
    
#metaseq.plotutils.ci_plot(
#    x,
#    normalized_subtracted[class4.values, :],
#    line_kwargs=dict(color='blue', label='class4'),
#    fill_kwargs=dict(color='blue', alpha=0.3),
#    ax=bottom_axes)

# Clean up redundant x tick labels, and add axes labels
fig.line_axes.set_xticklabels([])
fig.array_axes.set_xticklabels([])
fig.line_axes.set_ylabel('Average\nenrichement')
fig.array_axes.set_ylabel('Transcripts on arp6')
bottom_axes.set_ylabel('Average\nenrichment')
bottom_axes.set_xlabel('Distance from TSS (bp)')
fig.cax.set_ylabel('Enrichment')

# Add the vertical lines for TSS position to all axes
for ax in [fig.line_axes, fig.array_axes, bottom_axes]:
    ax.axvline(0, linestyle=':', color='black')

# Nice legend
bottom_axes.legend(loc='best', frameon=False, fontsize=8, labelspacing=.3, handletextpad=0.2)
fig.subplots_adjust(left=0.3, right=0.8, bottom=0.05)

savefig('arp6_H2AZ_plot3.pdf')