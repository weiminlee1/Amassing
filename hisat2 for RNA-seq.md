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
    
    
    
stringtie 参数详解
    
-h/--help   帮助信息

-v  打开详细模式，打印程序处理的详细信息。

-o [<path/>]<out.gtf> 设置StringTie组装转录本的输出GTF文件的路径和文件名。此处可指定完整路径，在这种情况下，将根据需要创建目录。默认情况下，StringTie将GTF写入标准输出。

-p <int>    指定组装转录本的线程数（CPU）。默认值是1

-G <ref_ann.gff>    使用参考注释基因文件指导组装过程，格式GTF/GFF3。输出文件中既包含已知表达的转录本，也包含新的转录本。选项-B，-b，-e，-C需要此选项（详情如下）

--rf    链特异性建库方式：fr-firststrand(最常用的是dUTP测序方式，其他有NSR，NNSR).

--fr    链特异性建库方式：fr-secondstrand(如 Ligation,Standard SOLiD).

-l <label>  将<label>设置为输出转录本名称的前缀。默认：STRG

-f <0.0-1.0>    将预测转录本的最低isoform的丰度设定为在给定基因座处组装的丰度最高的转录本的一部分。较低丰度的转录物通常是经加工的转录本的不完全剪接前体的artifacts。默认值为0.1。

-m <int>    设置预测的转录本所允许的最小长度.默认值为200

-A <gene_abund.tab> 输出基因丰度的文件（制表符分隔格式）

-C <cov_refs.gtf>   输出所有转录本对应的reads覆盖度的文件，此处的转录本是指参考注释基因文件中提供的转录本。(需要参数 -G).

-a <int>    Junctions that do not have spliced reads that align across them with at least this amount of bases on both sides are filtered out. Default: 10

-j <float>  连接点的覆盖度，即设置至少有这么多的spliced reads 比对到连接点(align across a junction)。 这个数字可以是分数, 因为有些reads可以比对到多个地方。 当一个read 比对到 n 个地方是，则此处连接点的覆盖度为1/n 。默认值为1。

-t  该参数禁止修剪组装的转录本的末端。默认情况下，StringTie会根据组装的转录本的覆盖率的突然下降来调整预测的转录本的开始和/或停止坐标。

-c <float>  设置预测转录本所允许的最小read 覆盖度。 当一个转录本的覆盖度低于阈值，则输出文件中不含该转录本。默认值为 2.5

-g <int>    设置ga最小值。 Reads that are mapped closer than this distance are merged together in the same processing bundle. Default: 50 (bp)

-B  应用该选项，则会输出Ballgown输入表文件（* .ctab），其中包含用-G选项给出的参考转录本的覆盖率数据。（有关这些文件的说明，请参阅Ballgown文档。）
    如果选项-o 给出输出转录文件的完整路径，则* .ctab文件与输出GTF文件在相同的目录下。

-b <path>   指定 *.ctab 文件的输出路径, 而非由-o选项指定的目录。
    注意: 建议在使用-B/-b选项中同时使用-e选项，除非StringTie GTF输出文件中仍需要新的转录本。

-e  限制reads比对的处理，仅估计和输出与用-G选项给出的参考转录本匹配的组装转录本。使用该选项，则会跳过处理与参考转录本不匹配的组装转录本，这将大大的提升了处理速度。

-M <0.0-1.0>    设定。默认值为0.95.
-x <seqid_list> 忽略所有比对到指定的参考序列上的reads，因此这部分的reads不需要组装转录本。 参数 <seqid_list>可以是单个参考序列名称 (如： -x chrM)，也可以是逗号分隔的序列名称列表 (如： -x 'chrM,chrX,chrY')。这可以加快StringTie的组装分析的速度，特别是在排除线粒体基因组的情况下，在某些情况下，线粒体的基因可能具有非常高的覆盖率，但是它们对于特定的RNA-Seq分析可能不感兴趣的。

--merge 转录本合并模式。 在合并模式下，StringTie将所有样品的GTF/GFF文件列表作为输入，并将这些转录本合并/组装成非冗余的转录本集合。这种模式被用于新的差异分析流程中，用以生成一个跨多个RNA-Seq样品的全局的、统一的转录本。
    如果提供了-G选项（参考注释基因组文件），则StringTie将从输入的GTF文件中将参考转录本组装到transfrags中。(个人理解：transfrags可能指的是拼接成更大的转录本片段，tanscript fragments)

在此模式下可以使用以下附加选项：
-G <guide_gff>  参考注释基因组文件(GTF/GFF3)
-o <out_gtf>    指定输出合并的GTF文件的路径和名称 (默认值：标准输出)
-m <min_len>    合并文件中，指定允许最小输入转录本的长度 (默认值: 50)
-c <min_cov>    合并文件中，指定允许最低输入转录本的覆盖度(默认值: 0)
-F <min_fpkm>   合并文件中，指定允许最低输入转录本的FPKM值 (默认值: 0)
-T <min_tpm>    合并文件中，指定允许最低输入转录本的TPM值  (默认值: 0)
-f <min_iso>    minimum isoform fraction (默认值: 0.01)
-i  合并后，保留含retained introns的转录本 (默认值: 除非有强有力的证据，否则不予保留)
-l <label>  输出转录本的名称前缀 (默认值: MSTRG)

gffcompare
The program gffcompare can be used to compare, merge, annotate and estimate accuracy of one or more GFF files (the “query” files), when compared with a reference annotation (also provided as GFF). 
当一个或多个GFF文件与参考注释文件进行比较，merge，注释和评估精确性时，用gffcompare来完成
    gffcompare [options]* {-i <input_gtf_list> | <input1.gtf> [<input2.gtf> .. <inputN.gtf>]}
 
