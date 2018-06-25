**# salmon #**
 Salmon is a tool for wicked-fast transcript quantification from RNA-seq data. It requires a set of target transcripts (either from a reference or de-novo assembly) to quantify. All you need to run Salmon is a FASTA file containing your reference transcripts and a (set of) FASTA/FASTQ file(s) containing your reads. Optionally, Salmon can make use of pre-computed alignments (in the form of a SAM/BAM file) to the transcripts rather than the raw reads.

For the examples below, assume we have two replicates lib_1 and lib_2. The left and right reads for lib_1 are lib_1_1.fq and lib_1_2.fq, respectively. The left and right reads for lib_2 are lib_2_1.fq and lib_2_2.fq

 > salmon quant -i index -l IU -1 lib_1_1.fq lib_2_1.fq -2 lib_1_2.fq lib_2_2.fq -o out

> salmon quant -i index -l IU -1 <(cat lib_1_1.fq lib_2_1.fq) -2 <(cat lib_1_2.fq lib_2_2.fq) -o out
 
 If you want to use Salmon in quasi-mapping-based mode, then you first have to build an Salmon index for your transcriptome. Assume that transcripts.fa contains the set of transcripts you wish to quantify. First, you run the Salmon indexer:
 
 > ./bin/salmon index -t transcripts.fa -i transcripts_index --type quasi -k 31 (建立索引）
 
 We find that a k of 31 seems to work well for reads of 75bp or longer, but you might consider a smaller k if you plan to deal with shorter reads. 
 
 > ./bin/salmon quant -i transcripts_index -l <LIBTYPE> -1 reads1.fq -2 reads2.fq -o transcripts_quant（比对）