# RPKM versus TPM
# 
# RPKM and TPM are both normalized for library size and gene length.
#
# RPKM is not comparable across different samples.
#
# For more details, see: http://blog.nextgenetics.net/?e=51

rpkm <- function(counts, lengths) {
  rate <- counts / lengths 
  rate / sum(counts) * 1e9 #1e6 #gene length union is 1kb
}

tpm <- function(counts, lengths) {
  rate <- counts / lengths
  rate / sum(rate) * 1e6 #1e6(per million and per kilobase)
}

# genes <- data.frame(
#   Gene = c("A","B","C","D","E"),
#   Length = c(100, 50, 25, 5, 1)
# )
# 
# counts <- data.frame(
#   S1 = c(80, 10,  6,  3,   1),
#   S2 = c(20, 20, 10, 50, 400)
# )

input <- read.table('feature_gene_counts.txt', header = T, sep = '\t', row.names = 1
)

counts <- input[, 6:10]
head(counts)

genes <- subset(input, select = 'Length')
head(genes)

rpkms <- apply(counts, 2, function(x) rpkm(x, genes$Length))

tpms <- apply(counts, 2, function(x) tpm(x, genes$Length))

genes
#   Gene Length
# 1    A    100
# 2    B     50
# 3    C     25
# 4    D      5
# 5    E      1

counts
#   S1  S2
# 1 80  20
# 2 10  20
# 3  6  10
# 4  3  50
# 5  1 400

rpkms
#         S1    S2
# [1,]  8000 4e+02
# [2,]  2000 8e+02
# [3,]  2400 8e+02
# [4,]  6000 2e+04
# [5,] 10000 8e+05

tpms
#             S1         S2
# [1,] 281690.14    486.618
# [2,]  70422.54    973.236
# [3,]  84507.04    973.236
# [4,] 211267.61  24330.900
# [5,] 352112.68 973236.010

# Sample means should be equal.

colSums(rpkms)
#    S1     S2 
# 28400 822000
colSums(tpms)
#    S1    S2 
# 1e+06 1e+06

colMeans(rpkms)
#   S1     S2 
# 5680 164400
colMeans(tpms)
#    S1    S2 
# 2e+05 2e+05