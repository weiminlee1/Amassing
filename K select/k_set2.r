set.seed(20180418)
##find best k value 

library('cluster')
library('fpc')
mydata <- read.table('expression_unigene_day_night.txt', header = T, sep = '\t', stringsAsFactors = F)
mydata <- mydata[,2:13]
head(mydata)
findclusters <- function(mydata){
  asw <- numeric(20)
  for (k in 2:20)
    asw[[k]] <- pam(mydata, k)$silinfo$avg.width
  
  k.best <- which.max(asw)
  cl <- kmeans(mydata, k.best)
  return(unlist(round(cl$centers,3), recursive = F))
}

##并行运算
library(parallel)
#计算计算机内核的大小
no_cores <- detectCores()
#设置运行所需的内核cluster
cl <- makeCluster(no_cores)
parLapply(cl,findclusters(mydata))
#findclusters(mydata)
stopCluster(cl)
