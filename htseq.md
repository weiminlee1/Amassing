htseq的用法

htseq-count (统计reads匹配到参考基因组的个数）

htseq-count [options] <alignment_files> <gff_file>

参数
-f <format>
format of the input data. possible values are sam and bam

-r <order>
for paired-end data, the alignment have to be sorted either by read name or by alignment position.

-s <yes/no/reverse> --stranded
whether the data is from a strand-specific assay
For stranded=no, a read is considered overlapping with a feature regardless of whether it is mapped to the same or the opposite strand as the feature. For stranded=yes and single-end reads, the read has to be mapped to the same strand as the feature. For paired-end reads, the first read has to be on the same strand and the second read on the opposite strand. For stranded=reverse, these rules are reversed.
-a <minaqual>, --a=<minaqual>
skip all reads with alignment quality lower than the given minimum value (default: 10 — Note: the default used to be 0 until version 0.5.4.)
-t <feature type>, --type=<feature type>
feature type (3rd column in GFF file) to be used, all features of other type are ignored (default, suitable for RNA-Seq analysis using an Ensembl GTF file

-i <id attribute>, --idattr=<id attribute>
GFF attribute to be used as feature ID. Several GFF lines with the same feature ID will be considered as parts of the same feature. The feature ID is used to identity the counts in the output table. The default, suitable for RNA-Seq analysis using an Ensembl GTF file, is gene_id.: exon)

--additional-attr=<id attributes>
Additional feature attributes, which will be printed as an additional column after the primary attribute column but before the counts column(s). The default is none, a suitable value to get gene names using an Ensembl GTF file is gene_name.

-m <mode>, --mode=<mode>
Mode to handle reads overlapping more than one feature. Possible values for <mode> are union, intersection-strict and intersection-nonempty (default: union)

--nonunique=<nonunique mode>
Mode to handle reads that align to or are assigned to more than one feature in the overlap <mode> of choice (see -m option). <nonunique mode> are none and all (default: none)

--secondary-alignments=<mode>
Mode to handle secondary alignments (SAM flag 0x100). <mode> can be score and ignore (default: score)

--supplementary-alignments=<mode>
Mode to handle supplementary/chimeric alignments (SAM flag 0x800). <mode> can be score and ignore (default: score)

-o <samout>, --samout=<samout>
write out all SAM alignment records into an output SAM file called <samout>, annotating each line with its assignment to a feature or a special counter (as an optional field with tag ‘XF’)

-q, --quiet
suppress progress report and warnings

-h, --help
Show a usage summary and exit