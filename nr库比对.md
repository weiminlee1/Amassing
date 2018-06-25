#NR库注释步骤：


- 1 下载nr.gz文件和索引文件</br>
[网址](https://ftp.ncbi.nlm.nih.gov/blast/db/)(nr.gz是总库； nr.00.tar.gz是索引文件, 两类文件必须放到同一个目录里, 下载命令：
<code> 
for ((i=10; i<=83; i++))
do
/share/workplace/home/stu_wanglulu/.aspera/connect/bin/ascp -i /share/workplace/home/stu_wanglulu/.aspera/connect/etc/asperaweb_id_dsa.openssh -k 1 -QT -l 500m anonftp@ftp-trace.ncbi.nlm.nih.gov:/blast/db/nr.$i.tar.gz  ./
done<code></br>
for ((i=0; i<=9; i++))
do
  /share/workplace/home/stu_wanglulu/.aspera/connect/bin/ascp -i /share/workplace/home/stu_wanglulu/.aspera/connect/etc/asperaweb_id_dsa.openssh -k 1 -QT -l 500m anonftp@ftp-trace.ncbi.nlm.nih.gov:/blast/db/nr.0$i.tar.gz  ./
done</code></br>
for((i=10; i<=83; i++))
do
  tar -zxvf nr.${i}.tar.gz
done<code></br>
for((i=0; i<=9; i++))
do
  tar -zxvf nr.0${i}.tar.gz
done
</br></code>

- 2 构建plant nr子库</br>
    - 到NCBI-protein下载plant的sequence.seq 文件（输入植物的txid号：txid33090[ORGIN]; 点击send to file; accession list; 导出植物的“sequence.seq"文件

    - 建植物nr子库：
        - <code>blastdb_aliastool -seqidlist sequence.seq -db nr -out nr_plant</code>
- 3 nr 库比对</br>
    - <code> blastx -query query.fa -db nr_plant -out query.XML -outfmt 5 -evalue 1e-3 -num_threads 20



          