# Script to compare Reads per Kilobase per Million mapped reads (RPKM) to Transcripts per Million (TPM) for gene expression count data
# Wagner et al. 2012 "Measurement of mRNA abundance using RNA-seq data: RPKM measure
# is inconsistent among samples" Theory Biosci. 131:281-285

library(plyr)


## Worked example from http://blog.nextgenetics.net/?e=51

X <- data.frame(gene=c("A","B","C","D","E"), count=c(80, 10, 6, 3, 1),
                   length=c(100, 50, 25, 5, 1))
X

Y <- data.frame(gene=c("F","G","H","I","J"), count=c(20, 20, 10, 50, 400),
                   length=c(100, 50, 25, 5, 1))
Y



## Calculate RPKM

# RPKM = (Rg * 10^6) / (T * Lg)
# where
# Rg: number of reads mapped to a particular transcript g = count
# T = total number of transcripts sampled in run
# FLg: length of transcript g (kilobases)

RPKM <- function(Rg, Lg, T) {
    rpkm <- (Rg * 1e6)/(T * Lg)
    return(rpkm)
}

T <- sum(X$count)

RPKM(Rg=X$count[1],Lg=X$length[1],T=T)
RPKM(Rg=X$count[2],Lg=X$length[2],T=T)
RPKM(Rg=X$count[3],Lg=X$length[3],T=T)

# Calculate RPKM using ddply
rpkm.X<-ddply(X, .(gene), summarize, rpkm = (count*1e6)/((sum(X$count)*length)))
rpkm.X
mean(rpkm.X$rpkm)

rpkm.Y<-ddply(Y, .(gene), summarize, rpkm = (count*1e6)/((sum(Y$count)*length)))
rpkm.Y
mean(rpkm.Y$rpkm)

## Calculate TPM

# TPM = (Rg * 10^6) / (Tn * Lg)
# where
# Tn = sum of all length normalized transcript counts
           
(Tn.X <- sum(ddply(X, .(gene), summarize, Tn = count/length)[2]))

TPM <- function(Rg, Lg, Tn) {
    tpm <- (Rg * 1e6)/(Tn * Lg)
    return(tpm)
}

TPM(Rg=X$count[1],Lg=X$length[1],Tn=Tn.X)
TPM(Rg=X$count[2],Lg=X$length[2],Tn=Tn.X)
TPM(Rg=X$count[3],Lg=X$length[3],Tn=Tn.X)

# Great - corresonds to example results!

# Calculate RPKM using ddply
tpm.X <- ddply(X, .(gene), summarize, tpm = (count*1e6)/(Tn.X*length))
tpm.X
mean(tpm.X$tpm)

           
(Tn.Y <- sum(ddply(Y, .(gene), summarize, Tn = count/length)[2]))

tpm.Y <- ddply(Y, .(gene), summarize, tpm = (count*1e6)/(Tn.Y*length))
tpm.Y
mean(tpm.Y$tpm)