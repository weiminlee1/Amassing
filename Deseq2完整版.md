
本帖最后由 anlan 于 2017-8-14 20:27 编辑


差异基因表达分析
我按照前面的流程转录组入门（1-6）从测序数据到生成count矩阵，将小鼠的4个样本又重新跑了一遍，从而获得一个新的count文件：mouse_all_count.txt，有需要的话，可以下载下来进行后续的差异分析。

一般来说，由于普遍认为高通量的read count符合泊松分布，所以一些差异分析的R包都是基于负二项式分布模型的，比如DESeq、DESeq2和edgeR等，所以这3个R包从整体上来说是类似的（但各自标准化算法是不一样的）。

当然还有一个常用的R包则是Limma包，其中的limma-trend和limma-voom都能用来处理RNA-Seq数据（但对应适用的情况不一样）

下面准备适用DESeq2和edgeR两个R包分别对小鼠的count数据进行差异表达分析，然后取两者的结果的交集的基因作为差异表达基因。

DEseq2
[AppleScript] 纯文本查看 复制代码

library(DESeq2)
                ##数据预处理
                database <- read.table(file = "mouse_all_count.txt", sep = "\t", header = T, row.names = 1)
                database <- round(as.matrix(database))
                 
                ##设置分组信息并构建dds对象
                condition <- factor(c(rep("control",2),rep("Akap95",2)), levels = c("control", "Akap95"))
                coldata <- data.frame(row.names = colnames(database), condition)
                dds <- DESeqDataSetFromMatrix(countData=database, colData=coldata, design=~condition)
                dds <- dds[ rowSums(counts(dds)) > 1, ]
                 
                ##使用DESeq函数估计离散度，然后差异分析获得res对象
                dds <- DESeq(dds)
                res <- results(dds)
                 
                #最后设定阈值，筛选差异基因，导出数据(全部数据。包括标准化后的count数)
                res <- res[order(res$padj),]
                diff_gene <- subset(res, padj < 0.05 & (log2FoldChange > 1 | log2FoldChange < -1))
                diff_gene <- row.names(diff_gene)
                resdata <- merge(as.data.frame(res), as.data.frame(counts(dds, normalized=TRUE)),by="row.names",sort=FALSE)
                write.csv(resdata,file = "control_vs_Akap95.csv",row.names = F)

最终获得572个差异基因（筛选标准为padj < 0.05, |log2FoldChange| > 1）
edgeR
[AppleScript] 纯文本查看 复制代码

library(edgeR)
                ##跟DESeq2一样，导入数据，预处理（用了cpm函数）
                exprSet<- read.table(file = "mouse_all_count.txt", sep = "\t", header = TRUE, row.names = 1, stringsAsFactors = FALSE)
                group_list <- factor(c(rep("control",2),rep("Akap95",2)))
                exprSet <- exprSet[rowSums(cpm(exprSet) > 1) >= 2,]
                 
                ##设置分组信息，并做TMM标准化
                exprSet <- DGEList(counts = exprSet, group = group_list)
                exprSet <- calcNormFactors(exprSet)
                 
                ##使用qCML（quantile-adjusted conditional maximum likelihood）估计离散度（只针对单因素实验设计）
                exprSet <- estimateCommonDisp(exprSet)
                exprSet <- estimateTagwiseDisp(exprSet)
                 
                ##寻找差异gene(这里的exactTest函数还是基于qCML并且只针对单因素实验设计)，然后按照阈值进行筛选即可
                et <- exactTest(exprSet)
                tTag <- topTags(et, n=nrow(exprSet))
                diff_gene_edgeR <- subset(tTag$table, FDR < 0.05 & (logFC > 1 | logFC < -1))
                diff_gene_edgeR <- row.names(diff_gene_edgeR)
                write.csv(tTag$table,file = "control_vs_Akap95_edgeR.csv")

最终获得688个差异基因（筛选标准为FDR < 0.05, |log2FC| > 1）   
取DESeq2和edgeR两者结果的交集
[AppleScript] 纯文本查看 复制代码

diff_gene <- diff_gene_DESeq2[diff_gene_DESeq2 %in% diff_gene_edgeR]

最终的差异基因数目为545个
[AppleScript] 纯文本查看 复制代码

head(diff_gene)
                [1] "ENSMUSG00000003309.14" "ENSMUSG00000046323.8"  "ENSMUSG00000001123.15"
                [4] "ENSMUSG00000023906.2"  "ENSMUSG00000044279.15" "ENSMUSG00000018569.12"
其他两个R包（DESeq和limma）就不在这尝试了，我之前做过对于这4个R包的简单使用笔记，可以参考下：
简单使用DESeq做差异分析
简单使用DESeq2/EdgeR做差异分析
简单使用limma做差异分析

GO&&KEGG富集分析
以前一直没有机会用Y叔写的clusterProfiler包，这次正好看说明用一下。

GO富集，加载clusterProfiler包和org.Mm.eg.db包（小鼠嘛），然后将ENSEMBL ID后面的版本号去掉，不然后面不识别这个ID，然后按照clusterProfiler包的教程说明使用函数即可。
[AppleScript] 纯文本查看 复制代码

library(clusterProfiler)
                library(org.Mm.eg.db)
                 
                ##去除ID的版本号
                diff_gene_ENSEMBL <- unlist(lapply(diff_gene, function(x){strsplit(x, "\\.")[[1]][1]}))
                ##GOid mapping + GO富集
                ego <- enrichGO(gene = diff_gene_ENSEMBL, OrgDb = org.Mm.eg.db,
                                keytype = "ENSEMBL", ont = "BP", pAdjustMethod = "BH",
                                pvalueCutoff = 0.01, qvalueCutoff = 0.05)
                ##查看富集结果数据
                enrich_go <- as.data.frame(ego)
                ##作图
                barplot(ego, showCategory=10)
                dotplot(ego)
                enrichMap(ego)
                plotGOgraph(ego)
KEGG富集，首先需要将ENSEMBL ID转化为ENTREZ ID，然后使用ENTREZ ID作为kegg id，从而通过enrichKEGG函数从online KEGG上抓取信息，并做富集
[AppleScript] 纯文本查看 复制代码

library(clusterProfiler)
                library(org.Mm.eg.db)
 
                ##ID转化
                ids <- bitr(diff_gene_ENSEMBL, fromType = "ENSEMBL", toType = "ENTREZID", OrgDb = "org.Mm.eg.db")
                kk <- enrichKEGG(gene = ids[,2], organism = "mmu", keyType = "kegg",
                 pvalueCutoff = 0.05, pAdjustMethod = "BH", qvalueCutoff = 0.1)
                ##查看富集结果数据
                enrich_kegg <- as.data.frame(kk)
                ##作图
                dotplot(kk)

到这里为止，转录组的差异表达分析算是做完了，简单的来说，这个过程就是将reads mapping 到reference上，然后计数获得count数，然后做差异分析，最后来个GO KEGG，over了。。。

对于mapping和计数这两部还有其实还有好多软件，具体可见文献：Gaining comprehensive biological insight into the transcriptome by performing a broad-spectrum RNA-seq analysis，有时间可以都尝试下。

至于GO && KEGG这两步，对于人、小鼠等模式物种来说，不考虑方便因素来说，完全可以自己写脚本来完成，数据可以从gene ontology官网下载，然后就是GO id与gene id相互转化了。KEGG 也是一样，也可以用脚本去KEGG网站上自行抓取，先知道URL规则，然后爬数据即可。

附上有道笔记链接：http://note.youdao.com/noteshare 