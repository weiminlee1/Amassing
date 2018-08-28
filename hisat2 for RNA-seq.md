#1 creating a HISAT2 index

    hisat2-build --ss chrx.fa(基因组文件）chrx_tran

#2 align the RNA-seq reads to the genome

###2.1 map the reads for each sample to the reference genome

    hisat2 -p 8 --dta -x indexes/chr_tran -1 sample_1.fq.gz -2 sample_2.fq.gz -S(比对结果） sample.sam

###2.2 sort and convert the sam files to bam

    samtools sort -@ 8 -o sample.bam sample.sam

#3 assemble and quantify expressed genes and transcripts

###3.1 assemble transcripts for each sample

    stringtie -p 8 -G chrx.gtf(注释文件）-o sample.gtf -l sample sample.bam

#4 merge transcripts from all samples

    stringtie --merge -p 8 -G chrx.gtf -o stringtie_merged.gtf mergelist.txt

（备注：mergelist.txt是3.1步每个样本产生的gtf文件路径整合到一起的一个文本文件，输出结果是stringtie_merged.gtf）

#5 examine how the transcripts compare with the reference annotation(optional):

    gffcompare -r chrx.gtf -G -o merged stringtie_merged.gtf
 

#6 estimate transcripts abundances and create table counts for ballgown
    stringtie -e -B -p 8 -G stringtie_merged.gtf  -o  ballgown/sample.gtf sample.bam



#example
    #!/bin/sh

    #PBS -l nodes=2:ppn=10

    #PBS -o /share/Public/stu_huiyanan/Lweimin/data/seedlings/log/pbs_out.$PBS_JOBID

    #PBS -e /share/Public/stu_huiyanan/Lweimin/data/seedlings/log/pbs_err.$PBS_JOBID

    #PBS -l walltime=72:00:00

    #PBS -q batch

    cd /share/Public/stu_huiyanan/Lweimin/data/seedlings

    data_dir=/share/Public/stu_huiyanan/Lweimin/data/seedlings

    genome=/share/Public/stu_huiyanan/Lweimin/assmble/genome

    index=/share/Public/stu_huiyanan/Lweimin/assmble/genome/index

    hisat2-build $genome/Sg.HiCasm20180705.asm.fasta $index/Sg_tran

    cat seedlings_file_path.txt| while read line

    do 

        mkdir $line
        hisat2 -p 20 --dta -x $index/Sg_tran  --min-intronlen 20 --max-intronlen 2000 -1 ${data_dir}/${line}_R1.fq.gz -2 ${data_dir}/${line}_R2.fq.gz -S ${data_dir}/${line}/${line}.sam
        samtools sort -@ 20 -o ${data_dir}/${line}/${line}.bam  ${data_dir}/${line}/${line}.sam
        rm  ./${line}/*.sam
    #stringtie -p 20 -G ${genome}/soybean.gtf -o  ${data_dir}/${line}/${line}.gtf -l  ${line}  ${data_dir}/${line}/${line}.bam
    done
    #cd $data_dir
    #find -name *.gtf>mergelist.txt
    #stringtie --merge -F 0.5 -T 0.5 -p 20 -G $genome/soybean.gff3 -o stringtie_merged.gtf ./mergelist.txt
    #gffcompare -r $genome/pineapple.gtf -G -o merged stringtie_merged.gtf
    #date

