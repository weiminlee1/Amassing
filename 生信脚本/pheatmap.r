library(grid)
library(pheatmap)
library(bitops)
library(caTools)
library(RColorBrewer)
library(ComplexHeatmap)
library(circlize)
my <- read.table('CBLs.txt', header = T, sep = '\t', row.names = 1, check.names = F, stringsAsFactors = F, na.strings = F)
draw_colnames_45 <- function (coln, gaps, ...) {
  coord = pheatmap:::find_coordinates(length(coln), gaps)
  x = coord$coord - 0.5 * coord$size
  res = textGrob(coln, x = x, y = unit(1, "npc") - unit(3,"bigpts"), vjust = 1, hjust = 1, rot = 45, gp = gpar(...))
  return(res)}
assignInNamespace(x="draw_colnames", value="draw_colnames_45",
                  ns=asNamespace("pheatmap"))


#colors<-colorRampPalette(rev(brewer.pal(n=7,name="RdYlBu")))(255)
#pdf(file = 'CLB_ananas.pdf')
windows(width = 12, height = 10)
pheatmap(log2(my+0.001),cluster_cols = F,cluster_rows = T, border_color = NA, show_rownames = T,cellwidth = 18, cellheight = 18, #main = 'picture_name', 
         #color = c('blue','white','red'),
         legend_labels = 'Log2(value)')
#dev.off()

############## method 2
df <- as.matrix((scale(mtcars)))
class(df)
#matrix
#heatmap(x, scale='row')
# x: 数据矩阵
# scale: 表示不同方向，可选值有: row, columa, gone
#Default plotheatmap(df, scale = 'none')
colorscol <- colorRampPalette(c('navy','white','firebrick'))(50) #colorRampPalette(c("red", "white", "blue"))(256)  #c('navy','white','firebricks') (50)
Heatmap(df, col=colorscol) #scale = "none",
library(RColorBrewer)
#col <- colorRampPalette(brewer.pal(10, "RdYlBu"))
#heatmap(df, scale = "none", col=col, RowSideColors = rep(c("blue", "pink"), each=16), 
#        ColSideColors = c(rep("purple", 5), rep("orange", 6)))
library(ComplexHeatmap)
heatmap(df, name = 'mtcars')

#自己设置颜色
library(circlize)
Heatmap(df, name='mtcars', col = colorRamp2(c(-2,0,2), c('green','white','red')))

#使用调色板
Heatmap(df, name = 'mtcars', col = colorRamp2(c(-2,0,2),brewer.pal(n=3, name="RdBu")))


#自定义颜色

mycol <- colorRamp2(c(-2,0,2), c('blue', 'white', 'red'))

#热图及行列标题设置

Heatmap(df, name = 'mtcars', col = mycol, column_title = 'Column title', row_title = 'Row title')

#注意，行标题的默认位置是“left”，列标题的默认是“top”。可以使用以下选项更改：
#row_title_side：允许的值为“左”或“右”（例如：row_title_side =“right”）
#column_title_side：允许的值为“top”或“bottom”（例如：column_title_side =“bottom”） 也可以使用以下选项修改字体和大小：
#row_title_gp：用于绘制行文本的图形参数
#column_title_gp：用于绘制列文本的图形参数



Heatmap(df, name = "mtcars", col = mycol, column_title = "Column title", 
        
        column_title_gp = gpar(fontsize = 14, fontface = "bold"), 
        
        row_title = "Row title", row_title_gp = gpar(fontsize = 14, fontface = "bold"))

# 在上面的R代码中，fontface的可能值可以是整数或字符串：1 = plain，2 = bold，3 =斜体，4 =粗体斜体。如果是字符串，则有效值为：“plain”，“bold”，“italic”，“oblique”和“bold.italic”。
# 显示行/列名称：
# show_row_names：是否显示行名称。默认值为TRUE
# show_column_names：是否显示列名称。默认值为TRUE

Heatmap(df, name = "mtcars", show_row_names = FALSE)

# 更改聚类外观
# 
# 默认情况下，行和列是包含在聚类里的。可以使用参数修改：
# 
# ● cluster_rows = FALSE。如果为TRUE，则在行上创建集群
# 
# ● cluster_columns = FALSE。如果为TRUE，则将列置于簇上

Heatmap(df, name = "mtcars", col = mycol, cluster_rows = FALSE, cluster_columns = F)


# 如果要更改列集群的高度或宽度，可以使用选项column_dend_height 和 row_dend_width：
# 
# Heatmap(df, name = "mtcars", col = mycol, column_dend_height = unit(2, "cm"), 
#         
#         row_dend_width = unit(2, "cm") )


#我们还可以利用 color_branches() 自定义树状图外观
library(dendextend)
row_dend = hclust(dist(df)) # row clustering
col_dend = hclust(dist(t(df))) # column clustering
Heatmap(df, name = "mtcars", col = mycol, cluster_rows = 
          color_branches(row_dend, k = 4), cluster_columns = color_branches(col_dend, k = 2))




# 
# 聚类方法
# 
# 参数clustering_method_rows和clustering_method_columns可用于指定进行层次聚类的方法。允许的值是hclust()函数支持的值，包括“ward.D”，“ward.D2”，“single”，“complete”，“average”。

Heatmap(df, name = "mtcars", clustering_method_rows = "ward.D", 
        
        clustering_method_columns = "ward.D")



# 热图拆分
# 
# 有很多方法来拆分热图。一个解决方案是应用k-means使用参数km。
# 
# 在执行k-means时使用set.seed()函数很重要，这样可以在稍后精确地再现结果

set.seed(1122)

# split into 2 groupsHeatmap(df, name = "mtcars", col = mycol, k = 2)


# split by a vector specifying row classes， 有点类似于ggplot2里的分面

Heatmap(df, name = "mtcars", col = mycol, split = mtcars$cyl )




#split也可以是一个数据框，其中不同级别的组合拆分热图的行。

# Split by combining multiple variables

Heatmap(df, name ="mtcars", col = mycol, split = data.frame(cyl = mtcars$cyl, am = mtcars$am))




# Combine km and split

Heatmap(df, name ="mtcars", col = mycol, km = 2, split = mtcars$cyl)


#也可以自定义分割 
library("cluster") 
set.seed(1122) 
pa = pam(df, k = 3)
Heatmap(df, name = "mtcars", col = mycol, split = paste0("pam", pa$clustering))


# 热图注释
# 
# 利用HeatmapAnnotation()对行或列注释。格式为： HeatmapAnnotation(df, name, col, show_legend)
# 
# ● df：带有列名的data.frame
# 
# ● name：热图标注的名称
# 
# ● col：映射到df中列的颜色列表

# Transposedf <- t(df)
# Heatmap of the transposed data
Heatmap(df, name ="mtcars", col = mycol)
# Annotation data frame
annot_df <- data.frame(cyl = mtcars$cyl, am = mtcars$am, mpg = mtcars$mpg)
# Define colors for each levels of qualitative variables
# Define gradient color for continuous variable (mpg)
col = list(cyl = c("4" = "green", "6" = "gray", "8" = "darkred"), am = c("0" = "yellow", 
                                                                         "1" = "orange"), mpg = colorRamp2(c(17, 25), c("lightblue", "purple")) )
# Create the heatmap annotation
ha <- HeatmapAnnotation(annot_df, col = col)
# Combine the heatmap and the annotation
Heatmap(df, name = "mtcars", col = mycol, top_annotation = ha)




#可以使用参数show_legend = FALSE来隐藏注释图例

ha <- HeatmapAnnotation(annot_df, col = col, show_legend = FALSE)

Heatmap(df, name = "mtcars", col = mycol, top_annotation = ha)


# ########################################################
# 基因表达矩阵
# 
# 在基因表达数据中，行代表基因，列是样品值。关于基因的更多信息可以在表达热图之后附加，例如基因长度和基因类型。


expr = readRDS(paste0(system.file(package = "ComplexHeatmap"), "/extdata/gene_expression.rds")) #paste0('a','b')把a b连接成ab
head(expr)
mat = as.matrix(expr[, grep("cell", colnames(expr))])
type = gsub("s\\d+_", "", colnames(mat))
ha = HeatmapAnnotation(df = data.frame(type = type))
Heatmap(mat, name = "expression", km = 6, top_annotation = ha, top_annotation_height = unit(4, "mm"),
        show_row_names = FALSE, show_column_names = FALSE, show_column_hclust = T) +
  Heatmap(expr$length, name = "length", width = unit(5, "mm"), col = colorRamp2(c(0, 1000, 1000000), c("navy","white", "firebrick"))) +
  Heatmap(expr$type, name = "type", width = unit(5, "mm")) +
  Heatmap(expr$chr, name = "chr", width = unit(5, "mm"), col = rand_color(length(unique(expr$chr))))

