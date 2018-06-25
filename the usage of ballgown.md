Ballgown

ballgown 的输入文件
StringTie 使用-B 参数直接生成Ballgown 的输入文件，cufflinks的输出结果需要使用Tablemaker 生成Ballgown 的输入文件

e_data.ctab, 外显子水平表达量（一行一个外显子，列分别表示：外显子编号，外显子所在的染色体，正负链信息，起始与终止位置）
    rcount: reads overlapping the exon  ucount: uniquely mapped reads overlapping the exon
    mrcount: multi-map-corrected number of reads overlapping the exon
    cov: average per-base read coverage
    cov_sd: standard deviation of per-base read coverage
    mcov: multi-map-corrected average per-base read coverage
    mcov_sd: standard deviation of multi-map-corrected per-base coverage
i_data.ctab, 内含子水平表达量
# t_data.ctab, 转录本水平表达量 #
    t_id: numeric transcript id
    chr, strand, start, end: genomic location of the transcript
    t_name: cufflinks-generated transcript id
    num_exons: number of exons comprising the transcript
    length: transcript length, including both exons and introns
    gene_id: gene the transcript belong to
    gene_name: HUGO gene name for the transcript, if known
    cov: per-base coverage for the transcript
    FPKM: cufflinks-estimated FPKM for the transcript
    
    
e2t.ctab, 外显子与转录本的对应关系(table with two columns, e_id and t_id, denoting which exons belong to which transcripts. These ids match the ids in the e_data and t_data tables.)
i2t.ctab, 内含子与转录本的对应关系