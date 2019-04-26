library(cluster)
library(Biobase)
library(qvalue)
setwd("D:/Documents/Desktop/刘燕辉/样本相关性") 
NO_REUSE = F
source("D:/Documents/Desktop/刘燕辉/样本相关性/heatmap.3.R")
source("D:/Documents/Desktop/刘燕辉/样本相关性/misc_rnaseq_funcs.R")
source("D:/Documents/Desktop/刘燕辉/样本相关性/pairs3.R")

# try to reuse earlier-loaded data if possible
if (file.exists("ALL_gene_exp_out.txt3.RData") && ! NO_REUSE) {
    print('RESTORING DATA FROM EARLIER ANALYSIS')
    load("ALL_gene_exp_out.txt3.RData")
} else {
    print('Reading matrix file.')
    primary_data = read.table("Sugarcane_tissues_sorted_FPKM_20190222.txt", header=T, com='', sep="\t", row.names=1, check.names=F)
    primary_data = as.matrix(primary_data)
}

data = primary_data
samples_data = read.table("Sugarcane_sample.txt", header=F, check.names=F, fill=T)
samples_data = samples_data[samples_data[,2] != '',]
sample_types = as.character(unique(samples_data[,1]))
rep_names = as.character(samples_data[,2])
data = data[, colnames(data) %in% samples_data[,2], drop=F ]
nsamples = length(sample_types)
sample_colors = rainbow(nsamples)
names(sample_colors) = sample_types
sample_type_list = list()
for (i in 1:nsamples) {
    samples_want = samples_data[samples_data[,1]==sample_types[i], 2]
    sample_type_list[[sample_types[i]]] = as.vector(samples_want)
}
sample_factoring = colnames(data)
for (i in 1:nsamples) {
    sample_type = sample_types[i]
    replicates_want = sample_type_list[[sample_type]]
    sample_factoring[ colnames(data) %in% replicates_want ] = sample_type
}
# reorder according to sample type.
tmp_sample_reordering = order(sample_factoring)
data = data[,tmp_sample_reordering,drop=F]
sample_factoring = sample_factoring[tmp_sample_reordering]
data = data[rowSums(data)>=10,]
initial_matrix = data # store before doing various data transformations
cs = colSums(data)
data = t( t(data)/cs) * 1e6;
data = log2(data+1)
sample_factoring = colnames(data)
for (i in 1:nsamples) {
    sample_type = sample_types[i]
    replicates_want = sample_type_list[[sample_type]]
    sample_factoring[ colnames(data) %in% replicates_want ] = sample_type
}
sampleAnnotations = matrix(ncol=ncol(data),nrow=nsamples)
for (i in 1:nsamples) {
  sampleAnnotations[i,] = colnames(data) %in% sample_type_list[[sample_types[i]]]
}
sampleAnnotations = apply(sampleAnnotations, 1:2, function(x) as.logical(x))
sampleAnnotations = sample_matrix_to_color_assignments(sampleAnnotations, col=sample_colors)
rownames(sampleAnnotations) = as.vector(sample_types)
colnames(sampleAnnotations) = colnames(data)
data = as.matrix(data) # convert to matrix
write.table(data, file="ALL_gene_exp_out.txt3.minRow10.CPM.log2.dat", quote=F, sep='	');
sample_cor = cor(data, method='pearson', use='pairwise.complete.obs')
write.table(sample_cor, file="ALL_gene_exp_out.txt3.minRow10.CPM.log2.sample_cor.dat", quote=F, sep='	')
sample_dist = as.dist(1-sample_cor)
hc_samples = hclust(sample_dist, method='complete')
pdf("ALL_gene_exp_out.txt3.minRow10.CPM.log2.sample_cor_matrix.pdf")
sample_cor_for_plot = sample_cor
heatmap.3(sample_cor_for_plot, dendrogram='both', Rowv=as.dendrogram(hc_samples), Colv=as.dendrogram(hc_samples), col = greenred(95), scale='none', symm=TRUE, key=TRUE,density.info='none', trace='none', symkey=FALSE, symbreaks=F, margins=c(10,10), cexCol=1, cexRow=1, cex.main=0.75, main=paste("sample correlation matrix
", "ALL_gene_exp_out.txt3.minRow10.CPM.log2") , ColSideColors=sampleAnnotations, RowSideColors=t(sampleAnnotations))
dev.off()
gene_cor = NULL
