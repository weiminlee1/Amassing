##deeptools

- 注意事项：<b>对于deeptools里的任意子命令</b>，都支持--help看帮助文档，--numberOfProcessors/-p设置多线程处理，--region/-r CHR:START:END处理部分区域。还有一些过滤用参数部分子命令可用，如ignoreDuplicates,minMappingQuality,samFlagInclude,samFlagExclue.

#step1
### bamCoverge  输入文件时排好序的bam文件
 bam 文件是sam 的二进制转换版。 bigwig是wig或bedGraph 的二进制版， 存放区间的坐标轴信息和相关计分（score）， 可以加载到IGV中，来查看reads在基因组上的覆盖度。
 
 为什么要用bigwig呢？因为bam文件比较大，直接用于展示时对服务器要求较大。
 <b> bamCoverge 用于单个bam文件，而bamCompare 用于两个bam文件相互比较。</b>
 
 每个分箱（bin）里的reads数量来计算覆盖度，分箱是一个定义好大小的较短的连续的计数窗口。延伸read的长度可以更好的反映实际的片段长度。
 
## 基本用法

- bamCoverage -e 170 -bs 10 -b sorted.bam -o output.bw   # sorted.bam是前期比对得到的BAM文件
  
-   bamCompare -b1 treatment.bam -b2 control.bam -o log2ratio.bw 其他参数设置与bamCoverage 一样。

#step2
###computeMatrix
- computeMatrix 是用来计算信号的分布情况

- computeMatrix具有两个模式:scale-region和reference-point。前者用来信号在一个区域内分布，后者查看信号相对于某一个点的分布情况。

- scale-regions模式

computeMatrix scale-regions \ # 选择模式-b 3000 -a 5000 \ # 感兴趣的区域，-b上游，-a下游 
-R ~/reference/gtf/TAIR10/TAIR10_GFF3_genes.bed \
-S 03-read-coverage/ap2_chip_rep1_1.bw  \
--skipZeros   \
-out 03-read-coverage/matrix1_ap2_chip_rep1_1_TSS.gz\ # 输出为文件用于plotHeatmap, plotProfile
--outFileNameMatrix 03-read-coverage/matrix1_ap2_chip_rep1_1_scaled.tab
--outFileSortedRegions 03-read-coverage/regions1_ap2_chip_re1_1_genes.bed

- reference-point模式

computeMatrix reference-point \ # 选择模式--referencePoint TSS \ # 选择参考点: TES, center-b 3000 -a 5000 \ # 感兴趣的区域，-b上游，-a下游 
-R ~/reference/gtf/TAIR10/TAIR10_GFF3_genes.bed \
-S 03-read-coverage/ap2_chip_rep1_1.bw  \
--skipZeros \
-out 03-read-coverage/matrix1_ap2_chip_rep1_1_TSS.gz \ # 输出为文件用于plotHeatmap, plotProfile 
--outFileNameMatrix matrix2_multipleBW_l2r_twoGroups_scaled.tab \
--outFileSortedRegions 03-read-coverage/ons1regions1_ap2_chip_re1_1_genes.bed


- Example 2: multiple input files (scale-regions mode和reference point 多可以)

$ deepTools2.0/bin/computeMatrix scale-regions \
  -R genes_chr19_firstHalf.bed genes_chr19_secondHalf.bed \ # separate multiple files with spaces
  -S testFiles/log2ratio_*.bw  \ or use the wild card approach
  -b 3000 -a 3000 \
  --regionBodyLength 5000 \
  --skipZeros -o matrix2_multipleBW_l2r_twoGroups_scaled.gz \
  --outFileNameMatrix matrix2_multipleBW_l2r_twoGroups_scaled.tab \
  --outFileSortedRegions regions2_multipleBW_l2r_twoGroups_genes.bed
  
  <b>其中就是把两个以上的bw文件合并为一个</b>
  
  
  
  
#step 3
  
###plotProfile
  - 样品单独出图
  # run compute matrix to collect the data needed for plotting
  
<b>$ computeMatrix scale-regions -S H3K27Me3-input.bigWig \
                                 H3K4Me1-Input.bigWig  \
                                 H3K4Me3-Input.bigWig \
                              -R genes19.bed genesX.bed \
                              --beforeRegionStartLength 3000 \
                              --regionBodyLength 5000 \
                              --afterRegionStartLength 3000
                              --skipZeros -o matrix.mat.gz</b>

$ plotProfile -m matrix.mat.gz \
              -out ExampleProfile1.png \
              --numPlotsPerRow 2 \
              --plotTitle "Test data profile"
              
 
结果出现三张图H3K27Me3, H3K4Me1, H3K4Me3 

  - 1 样品整合到一张图（有置信区间）
 
        $ plotProfile -m matrix.mat.gz \
        -out ExampleProfile2.png \
        --plotType=fill \ # add color between the x axis and the lines
        --perGroup \ # make one image per BED file instead of per bigWig file
        --colors red yellow blue \
        --plotTitle "Test data profile"
  
 
     
  - 2 样品整合到一张图（聚类）
  
        $ plotProfile -m matrix.mat.gz \
        --perGroup \
        --kmeans 2 \
        -out ExampleProfile3.png
     
  
  - 3 样品整合到一张图（热图）
  
        $ plotProfile -m matrix.mat.gz \
        --perGroup \
        --kmeans 2 \
        -plotType heatmap \
        -out ExampleProfile3.png