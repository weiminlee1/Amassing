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
input_signal = metaseq.genomic_signal('WT_H2A_Z.sort.bam','bam') #输入野生型的bam文件

import multiprocessing
processes = multiprocessing.cpu_count()

ip_array = ip_signal.array(

    # Look at signal over these windows
    tsses_1kb,

    # Bin signal into this many bins per window
    bins=100,

    # Use multiple CPUs. Dramatically speeds up run time.
    processes=processes)
input_array = input_signal.array(
    tsses_1kb,
    bins=100,
    processes=processes)

ip_array /= ip_signal.mapped_read_count() / 1e6
input_array /= input_signal.mapped_read_count() / 1e6
metaseq.persistence.save_features_and_arrays(
    features=tsses,
    arrays={'ip': ip_array, 'input': input_array},
    prefix='example',
    link_features=True,
    overwrite=True)

features, arrays = metaseq.persistence.load_features_and_arrays(prefix='example')
import numpy as np
x = np.linspace(-1000, 1000, 100)

# Import plotting tools
from matplotlib import pyplot as plt
from matplotlib.pyplot import plot, savefig


# Create a figure and axes
plt.switch_backend('agg')
fig = plt.figure()
ax = fig.add_subplot(111)


# Plot the IP:
ax.plot(
    # use the x-axis values we created
    x,
    
    # axis=0 takes the column-wise mean, so with 
    # 100 columns we'll have 100 means to plot
    arrays['ip'].mean(axis=0),
    
    # Make it red
    color='r',

    # Label to show up in legend
    label='arp6')


# Do the same thing with the input
ax.plot(
    x,
    arrays['input'].mean(axis=0),
    color='k',
    label='WT')


# Add a vertical line at the TSS, at position 0
ax.axvline(0, linestyle=':', color='k')


# Add labels and legend
ax.set_xlabel('Distance from TSS (bp)')
ax.set_ylabel('Average enrichment')
ax.legend(loc='best');

savefig('WT_arp6_H2AZ_plot1.pdf')
