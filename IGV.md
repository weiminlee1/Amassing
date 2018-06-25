##IGV可视化
1 不是什么数据都可以拿IGV看的，参考基因组必须为FASTA格式</br>

2 IGV只是负责将比对结果可视化，并没有比对过程，所以不能直接载入reads

3需要将待比对的reads与前面指定的参考基因组用bwa进行比对；

4比对后的sam文件也不能直接载入（麻烦），要转bam；bam排序；bam建索引（可以一步完成)

</br>$data/${sam}.sam |samtools view -@ 40 -h -b -S - >$data/${sam}.bam
</br>samtools sort -@ 40 $data/${sam}.bam $data/${sam}.sort
</br>samtools index $data/${sam}.sort.bam 
</br>rm $data/${sam}.bam

##数据导入
1导入基因组文件.fa

2导入sort.bam文件（bam文件和bam.fai文件在同一目录)

3直接用deeptools里的bamCoverage生成bigwig格式也可以加载到IGV

bamCoverage -b file1.bam -o file1.bw