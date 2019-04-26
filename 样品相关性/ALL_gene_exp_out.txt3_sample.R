library(cluster)
library(Biobase)
library(qvalue)
NO_REUSE = F
setwd('D:/Documents/Desktop/刘燕辉/样本相关性')
# try to reuse earlier-loaded data if possible
if (file.exists("ALL_gene_exp_out.txt3.RData") && ! NO_REUSE) {
    print('RESTORING DATA FROM EARLIER ANALYSIS')
    load("ALL_gene_exp_out.txt3.RData")
} else {
    print('Reading matrix file.')
    primary_data = read.table("ALL_gene_exp_out.txt3", header=T, com='', sep="\t", row.names=1, check.names=F)
    primary_data = as.matrix(primary_data)
}
source("D:/Documents/Desktop/刘燕辉/样本相关性/heatmap.3.R")
source("D:/Documents/Desktop/刘燕辉/样本相关性/misc_rnaseq_funcs.R")
source("D:/Documents/Desktop/刘燕辉/样本相关性/pairs3.R")
data = primary_data
samples_data = read.table("samples_described.txt", header=F, check.names=F, fill=T)
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
MA_plot = function(x, y, ...) {
    M = log( (exp(x) + exp(y)) / 2)
    A = x - y;
    res = list(x=M, y=A)
    return(res)
}
MA_color_fun = function(x,y) {
    col = sapply(y, function(y) ifelse(abs(y) >= 1, 'red', 'black')) # color 2-fold diffs
    return(col)
}
Scatter_color_fun = function(x,y) {
    col = sapply(abs(x-y), function(z) ifelse(z >= 1, 'red', 'black')) # color 2-fold diffs
    return(col)
}
for (i in 1:nsamples) {
    sample_name = sample_types[[i]]
    cat('Processing replicate QC analysis for sample: ', sample_name, "
")
    samples_want = sample_type_list[[sample_name]]
    samples_want = colnames(data) %in% samples_want
    if (sum(samples_want) > 1) {
        pdf(file=paste(sample_name, '.rep_compare.pdf', sep=''))
        d = data[,samples_want]
        initial_matrix_samples_want = initial_matrix[,samples_want]
        op <- par(mar = c(10,10,10,10))
        barplot(colSums(initial_matrix_samples_want), las=2, main=paste("Sum of Frags for replicates of:", sample_name), ylab='', cex.names=0.7)
        par(op)
        pairs3(d, pch='.', CustomColorFun=Scatter_color_fun, main=paste('Replicate Scatter:', sample_name)) # scatter plots
        pairs3(d, XY_convert_fun=MA_plot, CustomColorFun=MA_color_fun, pch='.', main=paste('Replicate MA:', sample_name)); # MA plots
        reps_cor = cor(d, method="pearson", use='pairwise.complete.obs')
        hc_samples = hclust(as.dist(1-reps_cor), method="complete")
        heatmap.3(reps_cor, dendrogram='both', Rowv=as.dendrogram(hc_samples), Colv=as.dendrogram(hc_samples), col = cm.colors(256), scale='none', symm=TRUE, key=TRUE,density.info='none', trace='none', symbreaks=F, margins=c(10,10), cexCol=1, cexRow=1, main=paste('Replicate Correlations:', sample_name) )
        dev.off()
    }
}
write.table(data, file="ALL_gene_exp_out.txt3.minRow10.CPM.log2.dat", quote=F, sep='	');
gene_cor = NULL
