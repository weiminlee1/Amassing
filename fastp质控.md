fastp是一款较新的数据质控软件，接触这个软件也是由于目前市场的软件各有功能但是功能都不是很全，譬如最近接触到一个RNAseq数据，质量较差，需要去除接头而且含N较多，序列起始端的数据较差需要去除几个bp，本来是打算使用trimmomatic去除接头和起始几个bp+cutadapt去除含N多的序列，但觉得稍微复杂。下面我们看看fastp能做什么。
安装方法
conda install -c bioconda fastp

    fastp的特性：

        对数据自动进行全方位质控，生成人性化的报告
        过滤功能（低质量，太短，太多N……）;
        对每一个序列的头部或尾部，计算滑动窗内的质量均值，并将均值较低的子序列进行切除（类似Trimmomatic的做法，但是快非常多）;
        全局剪裁 （在头/尾部，不影响去重），对于Illumina下机数据往往最后一到两个cycle需要这样处理;
        去除接头污染。厉害的是，你不用输入接头序列，因为算法会自动识别接头序列并进行剪裁;
        对于双端测序（PE）的数据，软件会自动查找每一对read的重叠区域，并对该重叠区域中不匹配的碱基对进行校正;
        去除尾部的polyG。对于Illumina NextSeq/NovaSeq的测序数据，因为是两色法发光，polyG是常有的事，所以该特性对该两类测序平台默认打开;
        对于PE数据中的overlap区间中不一致的碱基对，依据质量值进行校正;
        可以对带分子标签（UMI）的数据进行预处理，不管UMI在插入片段还是在index上，都可以轻松处理;
        -可以将输出进行分拆，而且支持两种模式，分别是指定分拆的个数，或者分拆后每个文件的行数;

以上功能大多都不需要输入太多的参数，一些功能默认已经开启，但是可以用参数关闭。fastp完美支持gzip的输入和输出，同时支持SE和PE数据，而且不但支持像Illumina平台的short read数据，也在一定程度上支持了PacBio/Nanopore的long reads数据。

fastp软件会生成HTML格式的报告，而且该报告中没有任何一张静态图片，所有的图表都是使用JavaScript动态绘制，非常具有交互性。想要看一下样板报告的，可以去以下链接：http://opengene.org/fastp/fastp.html

而且软件的开发者还充分考虑到了各种自动化分析的需求，不但生成了人可读的HTML报告，还生成了程序可读性非常强的JSON结果，该JSON报告中的数据包含了HTML报告100%的信息，而且该JSON文件的格式还是特殊定制的，不但程序读得爽，你用任何一款文本编辑器打开，一眼过去也会看得明明白白。想要看一下JSON结果长什么样的，可以去以下链接：http://opengene.org/fastp/fastp.json

下面我们先来看看fastp的具体参数：

usage: fastp -i <in1> -o <out1> [-I <in1> -O <out2>] [options...]
options:
  # I/O options   即输入输出文件设置
  -i, --in1                          read1 input file name (string)
  -o, --out1                         read1 output file name (string [=])
  -I, --in2                          read2 input file name (string [=])
  -O, --out2                         read2 output file name (string [=])
  -6, --phred64                      indicates the input is using phred64 scoring (it'll be converted to phred33, so the output will still be phred33)
  -z, --compression                  compression level for gzip output (1 ~ 9). 1 is fastest, 9 is smallest, default is 2. (int [=2])
    --reads_to_process               specify how many reads/pairs to be processed. Default 0 means process all reads. (int [=0])
  
  # adapter trimming options   过滤序列接头参数设置
  -A, --disable_adapter_trimming     adapter trimming is enabled by default. If this option is specified, adapter trimming is disabled
  -a, --adapter_sequence               the adapter for read1. For SE data, if not specified, the adapter will be auto-detected. For PE data, this is used if R1/R2 are found not overlapped. (string [=auto])
      --adapter_sequence_r2            the adapter for read2 (PE data only). This is used if R1/R2 are found not overlapped. If not specified, it will be the same as <adapter_sequence> (string [=])
    
  # global trimming options   剪除序列起始和末端的低质量碱基数量参数
  -f, --trim_front1                  trimming how many bases in front for read1, default is 0 (int [=0])
  -t, --trim_tail1                   trimming how many bases in tail for read1, default is 0 (int [=0])
  -F, --trim_front2                  trimming how many bases in front for read2. If it's not specified, it will follow read1's settings (int [=0])
  -T, --trim_tail2                   trimming how many bases in tail for read2. If it's not specified, it will follow read1's settings (int [=0])

  # polyG tail trimming, useful for NextSeq/NovaSeq data   polyG剪裁
  -g, --trim_poly_g                  force polyG tail trimming, by default trimming is automatically enabled for Illumina NextSeq/NovaSeq data
      --poly_g_min_len                 the minimum length to detect polyG in the read tail. 10 by default. (int [=10])
  -G, --disable_trim_poly_g          disable polyG tail trimming, by default trimming is automatically enabled for Illumina NextSeq/NovaSeq data

  # polyX tail trimming
  -x, --trim_poly_x                    enable polyX trimming in 3' ends.
      --poly_x_min_len                 the minimum length to detect polyX in the read tail. 10 by default. (int [=10])
  
  # per read cutting by quality options   划窗裁剪
  -5, --cut_by_quality5              enable per read cutting by quality in front (5'), default is disabled (WARNING: this will interfere deduplication for both PE/SE data)
  -3, --cut_by_quality3              enable per read cutting by quality in tail (3'), default is disabled (WARNING: this will interfere deduplication for SE data)
  -W, --cut_window_size              the size of the sliding window for sliding window trimming, default is 4 (int [=4])
  -M, --cut_mean_quality             the bases in the sliding window with mean quality below cutting_quality will be cut, default is Q20 (int [=20])
  
  # quality filtering options   根据碱基质量来过滤序列
  -Q, --disable_quality_filtering    quality filtering is enabled by default. If this option is specified, quality filtering is disabled
  -q, --qualified_quality_phred      the quality value that a base is qualified. Default 15 means phred quality >=Q15 is qualified. (int [=15])
  -u, --unqualified_percent_limit    how many percents of bases are allowed to be unqualified (0~100). Default 40 means 40% (int [=40])
  -n, --n_base_limit                 if one read's number of N base is >n_base_limit, then this read/pair is discarded. Default is 5 (int [=5])
  
  # length filtering options   根据序列长度来过滤序列
  -L, --disable_length_filtering     length filtering is enabled by default. If this option is specified, length filtering is disabled
  -l, --length_required              reads shorter than length_required will be discarded, default is 15. (int [=15])

  # low complexity filtering
  -y, --low_complexity_filter          enable low complexity filter. The complexity is defined as the percentage of base that is different from its next base (base[i] != base[i+1]).
  -Y, --complexity_threshold           the threshold for low complexity filter (0~100). Default is 30, which means 30% complexity is required. (int [=30])

  # filter reads with unwanted indexes (to remove possible contamination)
      --filter_by_index1               specify a file contains a list of barcodes of index1 to be filtered out, one barcode per line (string [=])
      --filter_by_index2               specify a file contains a list of barcodes of index2 to be filtered out, one barcode per line (string [=])
      --filter_by_index_threshold      the allowed difference of index barcode for index filtering, default 0 means completely identical. (int [=0])

  # base correction by overlap analysis options   通过overlap来校正碱基
  -c, --correction                   enable base correction in overlapped regions (only for PE data), default is disabled
  
  # UMI processing
  -U, --umi                          enable unique molecular identifer (UMI) preprocessing
      --umi_loc                      specify the location of UMI, can be (index1/index2/read1/read2/per_index/per_read, default is none (string [=])
      --umi_len                      if the UMI is in read1/read2, its length should be provided (int [=0])
      --umi_prefix                   if specified, an underline will be used to connect prefix and UMI (i.e. prefix=UMI, UMI=AATTCG, final=UMI_AATTCG). No prefix by default (string [=])
      --umi_skip                       if the UMI is in read1/read2, fastp can skip several bases following UMI, default is 0 (int [=0])

  # overrepresented sequence analysis
  -p, --overrepresentation_analysis    enable overrepresented sequence analysis.
  -P, --overrepresentation_sampling    One in (--overrepresentation_sampling) reads will be computed for overrepresentation analysis (1~10000), smaller is slower, default is 20. (int [=20])

  # reporting options
  -j, --json                         the json format report file name (string [=fastp.json])
  -h, --html                         the html format report file name (string [=fastp.html])
  -R, --report_title                 should be quoted with ' or ", default is "fastp report" (string [=fastp report])
  
  # threading options   设置线程数
  -w, --thread                       worker thread number, default is 3 (int [=3])
  
  # output splitting options
  -s, --split                        split output by limiting total split file number with this option (2~999), a sequential number prefix will be added to output name ( 0001.out.fq, 0002.out.fq...), disabled by default (int [=0])
  -S, --split_by_lines               split output by limiting lines of each file with this option(>=1000), a sequential number prefix will be added to output name ( 0001.out.fq, 0002.out.fq...), disabled by default (long [=0])
  -d, --split_prefix_digits          the digits for the sequential number padding (1~10), default is 4, so the filename will be padded as 0001.xxx, 0 to disable padding (int [=4])
  
  # help
  -?, --help                         print this message

虽然参数看起来比较多，但常用的主要包括以下几个部分：

    输入输出文件设置
    接头处理
    全局裁剪（即直接剪掉起始和末端低质量碱基）
    滑窗质量剪裁 （与trimmomatic相似）
    过滤过短序列
    校正碱基（用于双端测序）
    质量过滤

1、接头处理

fastp默认启用了接头处理，但是可以使用-A命令来关掉。fastp可以自动化地查找接头序列并进行剪裁，也就是说你可以不输入任何的接头序列，fastp全自动搞定了！对于SE数据，你还是可以-a参数来输入你的接头，而对于PE数据则完全没有必要，fastp基于PE数据的overlap分析可以更准确地查找接头，去得更干净，而且对于一些接头本身就有碱基不匹配情况处理得更好。fastp对于接头去除会有一个汇总的报告。
2、全局裁剪

fastp可以对所有read在头部和尾部进行统一剪裁，该功能在去除一些测序质量不好的cycle比较有用，比如151*2的PE测序中，最后一个cycle通常质量是非常低的，需要剪裁掉。使用-f和-t分别指定read1的头部和尾部的剪裁，使用-F和-T分别指定read2的头部和尾部的剪裁。
3、滑窗质量剪裁

很多时候，一个read的低质量序列都是集中在read的末端，也有少部分是在read的开头。fastp支持像Trimmomatic那样对滑动窗口中的碱基计算平均质量值，然后将不符合的滑窗直接剪裁掉。使用-5参数开启在5’端，也就是read的开头的剪裁，使用-3参数开启在3’端，也就是read的末尾的剪裁。使用-W参数指定滑动窗大小，默认是4，使用-M参数指定要求的平均质量值，默认是20，也就是Q20。
4、过滤过短序列

默认开启多序列过滤，默认值为15，使用-L（--disable_length_filtering）禁止此默认选项。或使用-l（--length_required）自定义最短序列。
5、校正碱基（用于双端测序）

fastp支持对PE数据的每一对read进行分析，查找它们的overlap区间，然后对于overlap区间中不一致的碱基，如果发现其中一个质量非常高，而另一个非常低，则可以将非常低质量的碱基改为相应的非常高质量值的碱基值。此选项默认关闭，可使用-c（--correction）开启。
6、质量过滤

fastp可以对低质量序列，较多N的序列，该功能默认是启用的，但可以使用-Q参数关闭。使用-q参数来指定合格的phred质量值，比如-q 15表示质量值大于等于Q15的即为合格，然后使用-u参数来指定最多可以有多少百分比的质量不合格碱基。比如-q 15 -u 40表示一个read最多只能有40%的碱基的质量值低于Q15，否则会被扔掉。使用-n可以限定一个read中最多能有多少个N。
例子

最后，附一个简单的例子：

#!/bin/bash

for i in 74 75 76 82 83 84 85 86 87 88; do
    {
    fastp -i ~/RNAseq/cleandata/SRR17343${i}_1.fastq.gz -o SRR17343${i}_1.fastq.gz \
        -I ~/RNAseq/cleandata/SRR17343${i}_2.fastq.gz -O SRR17343${i}_2.fastq.gz \
        -Q --thread=5 --length_required=50 --n_base_limit=6 --compression=6
    }&
done
wait

虽然软件作者称其速度很快，但就我的测试来看好像并没有那么快，可能与实验室服务器还在跑别的程序有关。其次就是他的质控报告，对于多个质控结果，如果能够与multiqc一样出一份汇总报告就更好了。
参考：
fastp: 一款超快速全功能的FASTQ文件自动化质控+过滤+校正+预处理软件
https://github.com/OpenGene/fastp

作者：To_2019_1_4
链接：https://www.jianshu.com/p/6f492058da5b
來源：简书
简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。
