##数据预处理
database <- read.table(file = "mouse_all_count.txt", sep = "\t", header = T, row.names = 1)
database <- round(as.matrix(database)) 把值四舍五入。

##设置分组信息并构建dds对象
condition <- factor(c(rep("control",2),rep("Akap95",2)), levels = c("control", "Akap95"))
coldata <- data.frame(row.names = colnames(database), condition)
dds <- DESeqDataSetFromMatrix(countData=database, colData=coldata, design=~condition)
dds <- dds[ rowSums(counts(dds)) > 1, ]

##使用DESeq函数估计离散度，然后差异分析获得res对象
dds <- DESeq(dds)
res <- results(dds)

##最后设定阈值，筛选差异基因，导出数据(全部数据。包括标准化后的count数)
table(res$padj <0.05)
res <- res[order(res$padj),]
diff_gene_DESeq2 <- subset(res, padj < 0.05 & (log2FoldChange > 1 | log2FoldChange < -1))
diff_gene_DESeq2 <- row.names(diff_gene_DESeq2)
resdata <- merge(as.data.frame(res), as.data.frame(counts(dds, normalized=TRUE)),by="row.names",sort=FALSE)
write.csv(resdata,file = "control_vs_Akap95.csv",row.names = F)



用Deseq2分析差异基因
实验过程
1，构建表达矩阵

#htseq2的输出结果
gene_id  sample(counts)

Aco1       12
Aco2       23

#把所有的样本的counts合并为out.txt (python脚本)
gene_id     leaf1       leaf2       root1       root2

Aco1           12           11          34          45
Aco2           23           10          23          22
Aco3           22           34          44          33
Aco4           12           22          33          56
...

#导入到R中

raw_data <- read.table('out.txt',sep='\t', header=T, row.name=1)
##如果列名不对的话，还可以用fix()函数修改列名
#把数据转换为矩阵
raw_data <- as.matrix(raw_data)

2, 构建dds对象
#这一步最为关键，要明白condition这里是因子，不是样本名称，有数据对照组和处理组或不同的组织
#还有不同的重复
#最为关键的是：colData的行名要等于raw_data的列名

condition <- factor( c (rep('leaf',2),rep('root',2)), levels = c('leaf','root'))
colData <- data.frame( row.names=colnames(raw_data), condition)
dds <- DESeqDataSetFromMatrix( raw_data, colData=colData, design= ~condition)

#查看一下dds的内容
head(dds)

3, DESeq标准化dds

#normalize 数据
dds1 <- DESeq(dds)

#查看结果的名称
resultsNames(dds1)

#将结果用results()函数来获取，赋值给res变量
res <- results(dds1)
#summary看一下结果的概要信息
summary(res)
#result结果可以看到一些基本的信息，p值默认小于0.1，上调基因有多少个，下调基因有多少个

4，提取差异分析结果
#获取padj(p值经过多重校验校正后的值）小于0.05，表达倍数取以2为对数后大于1或者小于-1的差异表达基因

table(res$padj<0.05)
res <- res[order(res$padj),] #把res安照padj排序
diff_gene_deseq2 <- subset(res, padj<0.05 & (log2FoldChange >1 | log2FoldChange < -1))
diff_gene_deseq2 <- row.names(diff_gene_deseq2) #获取差异基因名字

> resdata <-  merge(as.data.frame(res),as.data.frame(counts(dds1,normalize=TRUE)),by="row.names",sort=FALSE) #把原始数据和结果合并为一个表格输出
# 得到csv格式的差异表达分析结果
> write.csv(resdata,file= "leaf-vs-root.cvs",row.names = F)

