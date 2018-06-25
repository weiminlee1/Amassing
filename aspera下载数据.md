aspera下载SRA数据

$ ascp -QT -l 100M -i ~/asperaweb_id_dsa.putty era-fasp@fasp.sra.ebi.ac.uk:/vol1/ERA012/ERA012008/sff/library08_GJ6U61T06.sff ./

-i 后的秘钥文件要绝对路径，不然会报错

/share/workplace/home/stu_wanglulu/.aspera/connect/bin/ascp -i /share/workplace/home/stu_wanglulu/.aspera/connect/etc/asperaweb_id_dsa.openssh -k 1 -QT -l 500m anonftp@ftp-private.ncbi.nlm.nih.gov:/sra/sra-instant/reads/ByRun/sra/SRR/SRR297/SRR2976057/SRR2976057.sra ./


/share/workplace/home/stu_wanglulu/.aspera/connect/bin/ascp -i /share/workplace/home/stu_wanglulu/.aspera/connect/etc/asperaweb_id_dsa.openssh -k 1 -QT -l 500m anonftp@ftp-trace.ncbi.nlm.nih.gov:/sra/sra-instant/reads/ByRun/sra/SRR/SRR297/SRR2976057/SRR2976057.sra ./

##anonftp@ftp-trace.ncbi.nlm.nih.gov:/sra/sra-instant/reads/ByRun/sra/SRR 这是固定的，/后面跟具体的SRR号码

ftp://ftp.uniprot.org/pub/databases/uniprot/uniref/uniref90/uniref90.fasta.gz