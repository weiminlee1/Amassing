#蛋白质序列直系同源COG的注释
##
KOG库指的是真核生物的，eggNOG数据库比较全面

COG:数据库下载链接：http://www.ncbi.nlm.nih.gov/COG/

在以上的网址需要下载的文件有：

 

whog    关于COG序列中的相关注释情况

myva     COG数据库所包含的所有fasta格式的序列

fun.txt   大概COG可以按照功能分为25个大类，每一类可以用一个字母表示

### Code	Name
J	Translation, ribosomal structure and biogenesis
A	RNA processing and modification
K	Transcription
L	Replication, recombination and repair
B	Chromatin structure and dynamics
D	Cell cycle control, cell division, chromosome partitioning
Y	Nuclear structure
V	Defense mechanisms
T	Signal transduction mechanisms
M	Cell wall/membrane/envelope biogenesis
N	Cell motility
Z	Cytoskeleton
W	Extracellular structures
U	Intracellular trafficking, secretion, and vesicular transport
O	Posttranslational modification, protein turnover, chaperones
X	Mobilome: prophages, transposons
C	Energy production and conversion
G	Carbohydrate transport and metabolism
E	Amino acid transport and metabolism
F	Nucleotide transport and metabolism
H	Coenzyme transport and metabolism
I	Lipid transport and metabolism
P	Inorganic ion transport and metabolism
Q	Secondary metabolites biosynthesis, transport and catabolism
R	General function prediction only
S	Function unknown
##
此外需要下载perl程序：

cog_db_clean.pl  并不是所有的COG序列都包含所有的功能注释，所以你需要运行命令，挑选出在COG数据库中有注释的那些序列，脚本下载链接：https://gist.github.com/Buttonwood/96f9a9ef8159ca111a69
`cog_db_clean.pl  -myva myva whog >cog_clean.fa
formatdb -p T -o T -i cog_clean.fa;`

##
blast_parser.pl  解析blast输出结果,下载链接：https://github.com/JinfengChen/Scripts/tree/master/bin

`blastall -p blastp -b 500 -v 500 -F F -d cog_clean.fa -e 1e-4 -i yourdata.fa -o blast.out;
blast_parser.pl -tophit 1 -topmatch 1 blast.out >blast.best; `