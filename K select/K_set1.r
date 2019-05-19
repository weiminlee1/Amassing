#!/share/workplace/home/stu_wanglulu/software/R-3.2.0/bin/Rscript
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
# # find k value
# library(parallel)
# unigene <- read.table('expression_unigene_day_night.txt', header = T, sep = '\t', stringsAsFactors = F)
# data.custering <- unigene[,2:13]
# no_cores <- detectCores();
# cl<-makeCluster(no_cores);
# clusterEvalQ(cl, library(GMD));
# clusterExport(cl, list("clustering.kmeans")); #// add variables and functions to your enviroment
# start.time <- Sys.time();
# k.clusters <- parSapply(cl, 1, function(x) elbow.k(data.clustering)); #// or parLapply - it returns list. 
# end.time <- Sys.time();
# cat('Time to find k using Elbow method is',(end.time - start.time),'seconds with k value:', k.clusters);
# stopCluster(cl);

library(GMD)
unigene <- read.table('Sg_photos_mean_fpkm20181101.txt', header = T, sep = '\t', stringsAsFactors = F)
data.clustering <- unigene[,2:13]
elbow.k <- function(mydata){
  ## determine a "good" k using elbow
  dist.obj <- dist(mydata);
  hclust.obj <- hclust(dist.obj);
  css.obj <- css.hclust(dist.obj,hclust.obj);
  elbow.obj <- elbow.batch(css.obj);
  #   print(elbow.obj)
  k <- elbow.obj$k
  return(k)
}


# find k value
start.time <- Sys.time();
k.clusters <- elbow.k(data.clustering);
end.time <- Sys.time();
cat('Time to find k using Elbow method is',(end.time - start.time),'seconds with k value:', k.clusters)
