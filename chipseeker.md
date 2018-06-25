library(ChIPseeker)
files <- getSampleFiles()
peak <- readPeakFile(files[[4]])
promoter <- getPromoters(TxDb=txdb,
                         upstream=3000, downstream=3000)
tagMatrix <- getTagMatrix(peak, windows=promoter)
tagHeatmap(tagMatrix, xlim=c(-3000, 3000), color="red")
require(TxDb.Hsapiens.UCSC.hg19.knownGene)
txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene
peakHeatmap(files, weightCol=”V5”, TxDb=txdb,
            upstream=3000, downstream=3000,
            color=rainbow(length(files)))

plotAvgProf(tagMatrix, xlim=c(-3000, 3000),
            xlab=”Genomic Region (5’->3’)”,
            ylab = “Read Count Frequency”)[/align][align=left]

plotAvgProf2(files[[4]], TxDb=txdb,
             upstream=3000, downstream=3000,
             xlab=”Genomic Region (5’->3’)”,
             ylab = “Read Count Frequency”)

tagMatrixList <- lapply(files, getTagMatrix,
                        windows=promoter)
plotAvgProf(tagMatrixList, xlim=c(-3000, 3000))

plotAvgProf(tagMatrixList, xlim=c(-3000, 3000),
            conf=0.95,resample=500, facet=”row”)

peakAnno <- annotatePeak(files[[4]], tssRegion=c(-3000, 3000),
                         TxDb=txdb, annoDb=”org.Hs.eg.db”)
plotAnnoPie(peakAnno)



plotAnnoBar(peakAnno)

vennpie(peakAnno)

upsetplot(peakAnno)

upsetplot(peakAnno, vennpie=TRUE)

plotDistToTSS(peakAnno,
              title=”Distribution of transcription factor-binding loci\nrelative to TSS”)

peakAnnoList <- lapply(files, annotatePeak, TxDb=txdb,
                       tssRegion=c(-3000, 3000), verbose=FALSE)
plotAnnoBar(peakAnnoList)

plotDistToTSS(peakAnnoList)

genes <- lapply(peakAnnoList, function(i)
  as.data.frame(i)$geneId)
vennplot(genes[2:4], by=’Vennerable’)
