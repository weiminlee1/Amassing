library(grid)
library(pheatmap)
library(bitops)
library(caTools)
library(RColorBrewer)
#library(ggplot2)
library(gridExtra)
#library(mclust)
#theme_set(theme_bw())
#opar <- par(no.readonly = T)
#par(mfrow=c(1,9))
setwd("F:/珍霞师姐-甘蔗/甘蔗RNA_seq分析结果/生长素/blastp结果/20190425/等位基因/fpkmmatrix")
my1 <- read.table('AUX1-1.txt_fpkm_matrix_20190419.txt', header = T, sep = '\t', row.names = 1, check.names = F, stringsAsFactors = F)
# my_clust <- Mclust(as.matrix(my1), G=1:20)
# plot(my_clust)

##########设置kmenas中的K值
# library(GMD)
# data.clustering <- my1[,1:9]
# elbow.k <- function(mydata){
#   ## determine a "good" k using elbow
#   dist.obj <- dist(mydata);
#   hclust.obj <- hclust(dist.obj);
#   css.obj <- css.hclust(dist.obj,hclust.obj);
#   elbow.obj <- elbow.batch(css.obj);
#   #   print(elbow.obj)
#   k <- elbow.obj$k
#   return(k)
# }
# 
# 
# # find k value
# start.time <- Sys.time();
# k.clusters <- elbow.k(data.clustering);
# end.time <- Sys.time();
# cat('Time to find k using Elbow method is',(end.time - start.time),'seconds with k value:', k.clusters)
#################################################################################
# K_results <- kmeans(my1, ) ##elbow()函数计算出来的合理K值
# write(K_results)


draw_colnames_45 <- function (coln, gaps, ...) {
  coord = pheatmap:::find_coordinates(length(coln), gaps)
  x = coord$coord - 0.5 * coord$size
  res = textGrob(coln, x = x, y = unit(1, "npc") - unit(3,"bigpts"), vjust = 1, hjust = 1, rot =45, gp = gpar(...))
  return(res)}
assignInNamespace(x="draw_colnames", value="draw_colnames_45",
                  ns=asNamespace("pheatmap"))
library(RColorBrewer)
#windows(width = 55, height = 1000)
colors<-colorRampPalette(c("DimGrey", "white","Yellow", "Firebrick3"))(500)
#my2 <- c(my1$`Tap root`,my1$`Fibrous root`)
#var1 = c('navy','skyblue')
#var2 = c('snow','steelblue')
#ann_colors = list(var1,var2)
#drows = dist((my), method = "minkowski")
my2 <- log2(my1+1)
p1 <- pheatmap(my1,cluster_cols = F,cluster_rows =T,show_rownames =T, legend = T
               ,border=T,scale = 'row',fontsize = 12, color = colors,cellwidth = 30,cellheight = 25,main = 'AUX11')#scale = "row",
# summary(p1)
# order_row = p1$tree_row$order  #记录热图的行排序
# #order_col = p1$tree_col$order    #记录热图的列排序
# #order_col 
# order_col = c('Ac','MMC','Meiosis','Mitosis','Mature')
# datat = data.frame(my1[order_row,order_col])   # 按照热图的顺序，重新排原始数据
# datat = data.frame(rownames(datat),datat,check.names =F)  # 将行名加到表格数据中
# colnames(datat)[1] = "geneid"
# write.table(datat,file="Mature_Ac_MMC_tf_fpkm_matrix_20190419_reorder.txt",row.names=FALSE,quote = FALSE,sep='\t') #输出结果，按照热图中的顺序
# 
