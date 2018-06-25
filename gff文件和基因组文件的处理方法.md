##gtf 转换为bed格式
-  工具 
gtf2bed

##

    对于GTF文件，可以用gffread来提取序列，具体做法是：

    gffread XXX.gtf -o- > XXX.gff3

    gffread  XXX.gff3 -g known_genome.fa -w transcripts.fa 

    2. 对于BED文件，可以用Bedtools 里的getfasta来提取序列
    也可以自己写个python脚本啦，负链上的序列可以用Biopython处理，用SeqIO读进来的序列有个属性是reverse_complement()可以输出反向互补序列。
