##deeptools 命令
<b> bamCoverage </b></br>
type: normalization</br>
input: BAM</br>
out: bedgrpah or bigwig</br>
<b> obtain the normalized read coverage of a single BAM file.</b>
</br>bamCoverage -b file1.bam -o file1.bw</br>
</br>bamCoverage -b file1.bam -o file1.bw --outFileFormat bedgrapy (可以查看基因组一段区域内的reads富集评分)
##
<b>computeMatrix</b></br>
This tool calculates scores per genome regions and prepares an intermediate file that can be used with plotHeatmap and plotProfiles. Typically, the genome regions are genes, but any other regions defined in a BED file can be used. computeMatrix accepts multiple score files (bigWig format) and multiple regions files (BED format). This tool can also be used to filter and sort regions according to their score.

type: data integration</br>
input: 1 or more bigwig, 1 or more BED </br>
output: zipped file for plotHeatmap or plotProfile</br>
<b> compute the values needed for heatmaps and summary plots</b>


##

<b>plotHeatmap</b></br>
type: visualization</br>
input: computeMatrix output</br>
output: heatmap of read coverages</br>
<b> visualize the read coverages for genomic regions</b>

##
<b>plotProfile</b></br>
type: visulization
input: computeMatrix output</br>
output: summary plot ('meta-profile')</br>
<b>visulaize the average read coverages over group of genomic regions</b>

##
<b>plotCoverage</b></br>
type: visulization</br>
input: 1 or more BAM </br>
output: 2 diagnostic plots</br>
<b> visualize the average read coverages over sampled genomic positions
 

