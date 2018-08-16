##相关性作图
install.packages("corrplot")
library("corrplot")
a<-read.table(file=file.choose(),row.names=1,header=T,sep="\t")
b<-cor(a)
corrplot(b) #这里默认是圆形显示
corrplot(b,method="pie")
corrplot(b,method="color",addCoef.col="grey") #用颜色显示，同时显示相关系数，是不是跟开头绿绿的图一样啦。
col=colorRampPalette(c("navy", "white", "firebrick3")) #设置颜色
corrplot(b,type="upper",col=col(10),tl.pos="d") #tl.pos="d"即不显示周边各列名字