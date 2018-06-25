1 creating a HISAT2 index

hisat2-build --ss chrx.fa(基因组文件）chrx_tran

2 align the RNA-seq reads to the genome

2.1 map the reads for each sample to the reference genome

hisat2 -p 8 --dta -x indexes/chr_tran -1 sample_1.fq.gz -2 sample_2.fq.gz -S(比对结果） sample.sam

2.2 sort and convert the sam files to bam

samtools sort -@ 8 -o sample.bam sample.sam

3 assemble and quantify expressed genes and transcripts

3.1 assemble transcripts for each sample

tringtie -p 8 -G chrx.gtf(注释文件）-o sample.gtf -l sample sample.bam

4 merge transcripts from all samples

stringtie --merge -p 8 -G chrx.gtf -o stringtie_merged.gtf mergelist.txt

5

