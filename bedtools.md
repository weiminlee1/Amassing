
Usage: 
  <br> <b>                bedtools intersect [OPTIONS] [-a|-abam] -b </b></br>
 (or):
                   intersectBed [OPTIONS] [-a|-abam] -b

案例一：包含着染色体位置的两个文件，分别记为A文件和B文件。分别来自于不同文件的染色体位置的交集是什么？
$ cat A.bed
chr1 10 20
chr1 30 40
$ cat B.bed
chr1 15 25
$ bedtools intersect -a A.bed -b B.bed 
chr1 15 20 

<b>案例二：包含着染色体位置的两个文件，分别记为A文件和B文件。求A文件中哪些染色体位置是与文件B中的染色体位置有overlap.</b>
 $ cat A.bed
 chr1 10 20
 chr1 30 40
 $ cat B.bed
 chr1 15 25
 $ bedtools intersect -a A.bed -b B.bed -wa
 chr1 10 20 

案例三：包含着染色体位置的两个文件，分别记为A文件和B文件。求A文件中染色体位置与文件B中染色体位置的交集，以及对应的文件B中的染色体位置.
 $ cat A.bed
 chr1 10 20
 chr1 30 40
 $ cat B.bed
 chr1 15 25
 $ bedtools intersect -a A.bed -b B.bed -wb
  chr1 15 20 chr1 15 25

案例四（经用）： 包含着染色体位置的两个文件，分别记为A文件和B文件。求对于A文件的染色体位置是否与文件B中的染色体位置有交集。如果有交集，分别输入A文件的染色体位置和B文件的染色体位置；如果没有交集，输入A文件的染色体位置并以'. -1 -1'补齐文件。
 $ cat A.bed
chr1 10 20
chr1 30 40
$ cat B.bed
chr1 15 25
$ bedtools intersect -a A.bed -b B.bed -loj
chr1 10 20 chr1 15 25
chr1 30 40 . -1 -1

案例五：  包含着染色体位置的两个文件，分别记为A文件和B文件。对于A文件中染色体位置，如果和B文件中染色体位置有overlap,则输出在A文件中染色体位置和在B文件中染色体位置，以及overlap的长度.
 $ cat A.bed
chr1 10 20
chr1 30 40
$ cat B.bed
chr1 15 20
chr1 18 25
$ bedtools intersect -a A.bed -b B.bed -wo
chr1 10 20 chr1 15 20 5
chr1 10 20 chr1 18 25 2 

案例六：  包含着染色体位置的两个文件，分别记为A文件和B文件。对于A文件中染色体位置，如果和B文件中染色体位置有overlap,则输出在A文件中染色体位置和在B文件中染色体位置，以及overlap的长度；如果和B文件中染色体位置都没有overlap,则用'. -1-1'补齐文件
$ cat A.bed
chr1 10 20
chr1 30 40
$ cat B.bed
chr1 15 20
chr1 18 25
$ bedtools intersect -a A.bed -b B.bed -wao
chr1 10 20 chr1 15 20 5
chr1 10 20 chr1 18 25 2 
chr1 30 40 . -1 -1

 案例七：  包含着染色体位置的两个文件，分别记为A文件和B文件。对于A文件中染色体位置，输出在A文件中染色体位置和有多少B文件染色体位置与之有overlap.
$ cat A.bed
 chr1 10 20
 chr1 30 40
 $ cat B.bed
 chr1 15 20
 chr1 18 25
 $ bedtools intersect -a A.bed -b B.bed -c
 chr1 10 20 2
 chr1 30 40 0 

 案例八(常用)：  包含着染色体位置的两个文件，分别记为A文件和B文件。对于A文件中染色体位置，输出在A文件中染色体位置和与B文件染色体位置至少有X%的overlap的记录。
$ cat A.bed
chr1 100 200
$ cat B.bed
chr1 130 201
chr1 180 220
$ bedtools intersect -a A.bed -b B.bed -f 0.50 -wa -wb  
chr1 100 200 chr1 130 201 
 
 相关格式

1) BED format

BEDTools主要使用BED格式的前三列，BED可以最多有12列。BED格式的常用列描述如下：

>chrom: 染色体信息， 如chr1, III, myCHrom, contig1112.23, 必须有</br>
start: genome feature的起始位点，从0开始， 必须有</br>
end: genome feature的终止位点，至少为1， 必须有</br>
name: genome feature的官方名称或者自定义的一个名字</br>
score: 可以是p值等等一些可以刻量化的数值信息</br>
strands: 正反链信息