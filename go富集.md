library(clusterProfiler)
#GO
#go2ont("GO:0000001")
#go2term("GO:0000001")
#TRINITY_DN22896_c0_g1_i1	GO:0000001	BP	mitochondrion inheritance
data <- read.table('rice_GOslim.txt',head =T,sep='\t') 
#LOC_Os01g01010.1	GO:0030234	F	enzyme regulator activity	IEA	TAIR:AT3G59570
#LOC_Os01g01010.1	GO:0007165	P	signal transduction	IEA	TAIR:AT3G59570

head(data)
geneGO<-data[,c(2,4)] ##go(term)_name
head(geneGO)
TotalGO<-data[,c(2,1)] ##go(term)_geneid
head(TotalGO)
ID <- read.table("diff_gene_1.txt",head =T,sep='\t')
head(ID)
ID2 <- as.character(ID[,1])
head(ID2)
x <- enricher(ID2,pvalueCutoff = 0.05, pAdjustMethod = 'BH', qvalueCutoff = 0.2, TERM2GENE = TotalGO,TERM2NAME= geneGO)
#barplot(x)
dotplot(x)
write.table(x,"rice_diff_gene_go_enrichment.txt",quote=FALSE,sep ='\t')
