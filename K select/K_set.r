## load library
require("GMD")
## simulate data around 12 points in Euclidean space
setwd('F:/张老师/毕业课题/碱蓬/Unigene/expression/Kmeans/K select')
# unigene_file <- read.table('expression_unigene_day_night.txt', header=T,sep = '\t', stringsAsFactors = F)
# # pointv <- data.frame(x=c(1,2,2,4,4,5,5,6,7,8,9,9),
# #                      y=c(1,2,8,2,4,4,5,9,9,8,1,9),
# #                      z=c(12,33,33,32,5,4,6,7,8,6,4,4))
# 
# head(unigene_file)
# pointv <- unigene_file[,2:13]
# set.seed(2012)
# mydata <- c()
# for (i in 1:nrow(pointv)){
#   mydata <- rbind(mydata,cbind(rnorm(10,pointv[i,1],0.1),
#                                rnorm(10,pointv[i,2],0.1),
#                                rnorm(10,pointv[i,3],0.1),
#                                rnorm(10,pointv[i,4],0.1),
#                                rnorm(10,pointv[i,5],0.1),
#                                rnorm(10,pointv[i,6],0.1),
#                                rnorm(10,pointv[i,7],0.1),
#                                rnorm(10,pointv[i,8],0.1),
#                                rnorm(10,pointv[i,9],0.1),
#                                rnorm(10,pointv[i,10],0.1),
#                                rnorm(10,pointv[i,11],0.1),
#                                rnorm(10,pointv[i,12],0.1)))
# }
#mydata <- data.frame(mydata); colnames(mydata) <- c('JP6pm','JP8pm','JP10pm','JPMid','JP2am','JP4am','JP6am','JP8am','JP10am','JPnoon','JP2pm','JP4pm')
mydata <- read.table('unigene_k_matrix.txt',header = T,sep = '\t', stringsAsFactors = F)
plot(mydata,type="p",pch=21, main="Simulated data")
## determine a "good" k using elbow
dist.obj <- dist(mydata)#dist(mydata[,1:12])
hclust.obj <- hclust(dist.obj)
css.obj <- css.hclust(dist.obj,hclust.obj)
elbow.obj <- elbow.batch(css.obj)
print(elbow.obj)
## make partition given the "good" k
k <- elbow.obj$k; cutree.obj <- cutree(hclust.obj,k=k)
mydata$cluster <- cutree.obj
## draw a elbow plot and label the data
dev.new(width=12, height=6)
par(mfcol=c(1,2),mar=c(4,5,3,3),omi=c(0.75,0,0,0))
plot(mydata$x,mydata$y,pch=as.character(mydata$cluster),
     col=mydata$cluster,cex=0.75,main="Clusters of simulated data")
plot(css.obj,elbow.obj,if.plot.new=FALSE)
## clustering with more relaxed thresholds (, resulting a smaller "good" k)
elbow.obj2 <- elbow.batch(css.obj,ev.thres=0.90,inc.thres=0.05)
mydata$cluster2 <- cutree(hclust.obj,k=elbow.obj2$k)
dev.new(width=12, height=6)
par(mfcol=c(1,2), mar=c(4,5,3,3),omi=c(0.75,0,0,0))
plot(mydata$x,mydata$y,pch=as.character(mydata$cluster2),
     col=mydata$cluster2,cex=0.75,main="Clusters of simulated data")
plot(css.obj,elbow.obj2,if.plot.new=FALSE)

