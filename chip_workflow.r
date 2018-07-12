## chip_seq workflow

# library(ChIPseeker)
# library(GenomicFeatures)
# txdb <- makeTxDbFromGFF(file = 'TAIR10_GFF3_genes.gff', format = 'gff', organism = 'Arabidopsis thaliana')
# library(clusterProfiler)
# require(org.At.tair.db)
# peak_H3K27 <- readPeakFile('col_H3K27-W200-G600-E100.scoreisland', as='GRanges')
# 
# peak_H2AZ <- readPeakFile('wt_H2AZ-W200-G200-E100.scoreisland', as='GRanges')
# 
# #peakAnno <- annotatePeak('col_H3K27-W200-G600-E100.scoreisland', tssRegion = c(-1000,0),
# #                           TxDb = txdb )
# 
# peakAnno_H3K27me3 <- annotatePeak(peak = peak_H3K27, tssRegion = c(-1000,0),
#                         TxDb = txdb )
# peakAnno_H2A.Z <- annotatePeak(peak = peak_H2AZ, tssRegion = c(-1000,0),
#                               TxDb = txdb)
# 
# #write.csv(peakAnno_H3K27, file = 'H3K27_anno.csv')
# #write.csv(peakAnno_H2AZ,file = 'H2AZ_anno.csv')
# windows(width = 15, height = 10)
# #plotAnnoBar(peakAnno_H3K27me3,xlab = 'H3K27me3', title = '')
# plotAnnoBar(peakAnno_H2A.Z, xlab = 'H2A.Z', title = '')

############################################################################################################
library(ChIPseeker)
files <- getSampleFiles()
#peak <- readPeakFile(files[[4]])
# peak_H3K27 <- readPeakFile('col_H3K27-W200-G600-E100.scoreisland', as='GRanges')
# 
# peak_H2AZ <- readPeakFile('wt_H2AZ-W200-G200-E100.scoreisland', as='GRanges')

files <- list(WT_H3K27me3='col_H3K27-W200-G600-E100.scoreisland',WT_H2A.Z='wt_H2AZ-W200-G200-E100.scoreisland',arp6_H2A.Z='arp6_H2A_Z-W200-G200-E100.scoreisland', arp6_H3K27me3='arp6_H3K27me3-W200-G200-E100.scoreisland')
library(GenomicFeatures)
txdb <- makeTxDbFromGFF(file = 'TAIR10_GFF3_genes.gff', format = 'gff', organism = 'Arabidopsis thaliana')
library(clusterProfiler)
require(org.At.tair.db)
# promoter <- getPromoters(TxDb=txdb,
#                          upstream=3000, downstream=3000)
# tagMatrix <- getTagMatrix(peak, windows=promoter)
##这时候，我们可以用tagHeatmap来画热图，颜色随意指定：
# tagHeatmap(tagMatrix, xlim=c(-3000, 3000), color="red")
# 
# ##另外我们还可以以谱图的形式来展示结合的强度：
# plotAvgProf(tagMatrix, xlim=c(-3000, 3000),
#             xlab="Genomic Region (5'->3')",
#             ylab = "Read Count Frequency") ##[align][align=left]

############################################################################################################

# plotAvgProf2(files[[4]], TxDb=txdb,
#              upstream=3000, downstream=3000,
#              xlab="Genomic Region (5’->3’)",
#              ylab = "Read Count Frequency")
# 
# plotAvgProf(tagMatrix, xlim=c(-3000, 3000),
#             conf = 0.95, resample = 1000)
# ############################################################################################################
#注释信息可视化
# peakAnno <- annotatePeak(files[[4]], tssRegion=c(-3000, 3000),
#                          TxDb=txdb, annoDb="org.Hs.eg.db")
# plotAnnoPie(peakAnno)
##############################################################################################################


peakAnnoList <- lapply(files, annotatePeak, TxDb=txdb,
                       tssRegion=c(-1000, 1000), verbose=FALSE)
#write.csv(peakAnnoList, file = 'peak_annotation.csv', quote = F)
plotAnnoBar(peakAnnoList)

##############################################################################################################
