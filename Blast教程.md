
#BLAST document

BLAST PARSER, DISTANCE MATRIX FILE and PROTEIN SEQUENCE CLUSTERING

How to obtain a Distance Matrix File from BLAST search results
and use it for sequence clustering analysis.

by Alexander Kozik, Brian Chan and Richard Michelmore, 
University of California, Davis



tcl_blast_parser_123_V007.tcl 
PROGRAM DESCRIPTION and USAGE

      This web page describes "our own version" of BLAST parser, its usage, input and output file formats. Almost any bioinformatician wrote at least once in his/her lifetime a BLAST parser for some particular needs. There are many parsers over the Internet: Google search for keywords "blast parser". Here we present our contribution into highthroughput analysis of results BLAST searches. Major advantages of our parser are: 
1- automatic generation of the "Matrix file" suitable for protein/sequence clustering analysis and 
2- generation of the "Two Hits File" which helps to distinguish orthologs from paralogs in the case of BLAST search of one genome against another, for example: Lettuce/Sunflower COS candidates (Conserved Orthologs Set) web page. 

      It is better to describe BLAST parser functionality with a real example: For instance, we have a set of Arabidopsis resistance genes in file: NB-ARC.fasta. We would like to BLAST this set against itself and set up a MATRIX file, which is the input for PhyloGrapher or GenomePixelizer or any other bioinformatics program.

      It is assumed that NCBI BLAST is installed on your computer. First format the database file. Type in the following command:

formatdb -i NB-ARC.fasta -p T

      There are three new files generated. In this case, they are NB-ARC.fasta.phr, NB-ARC.fasta.pin, and NB-ARC.fasta.psq .

      To run BLAST in command line we need to execute a command:

blastall -p blastp -F F -d NB-ARC.fasta -i NB-ARC.fasta -o NB-ARC_blastp.out -e 1e-10 -I T -v 200 -b 200 

      where by different options:

"blastall -p blastp" to run blastp program (proteins against proteins)
"-F F" we do not want to use low complexity filter
"-d NB-ARC.fasta" our database
"-i NB-ARC.fasta" our input file
"-o NB-ARC_blastp.out" our output file
"-e 1e-10" expectation cutoff value
"-I T" if GenBank IDs are present in database file they will be displayed in output file
"-v 200 -b 200" we want to see in the output file up to 200 short description lines for hits if found and up to 200 sequence alignments

      After some time (several minutes on a 1 GHz computer), when the search is done BLAST should generate NB-ARC_blastp.out output file. It is a very large file, about 50 Mb after uncompression. To test it with BLAST parser you need to download it and uncompress using "gunzip" on UNIX or "WinZip" on Windows. To view part of this file click here . Then we can process BLAST output using tcl_blast_parser_123_V007.tcl and generate tab delimited parsed files suitable for further data analysis. 


      tcl_blast_parser_123_V007.tcl takes as input the results of stand alone BLAST search. You need to run program in command shell or DOS prompt with six arguments: 

      tcl_blast_parser_123_V007.tcl [input_file] [output_file] [expect_cutoff] [identity_cutoff] [overlap_cutoff] [matrix_option] 

For example, in UNIX and in DOS respectively: 

      tcl_blast_parser_123_V007.tcl NB-ARC_blastp.out NB-ARC_blastp.out 20 40 100 MATRIX 

      tclsh tcl_blast_parser_123_V007.tcl NB-ARC_blastp.out NB-ARC_blastp.out 20 40 100 MATRIX

in this case file with name NB-ARC_blastp.out will be analyzed by parser and six new files with names:

      NB-ARC_blastp.out.all_hits
      NB-ARC_blastp.out.best_hit
      NB-ARC_blastp.out.blast_stat
      NB-ARC_blastp.out.id_list
      NB-ARC_blastp.out.matrix
      NB-ARC_blastp.out.two_hits

will be generated upon analysis. You can specify output file name the same as input file name, parser will add file extensions to each type of output, so input file will remain without any changes. 

Below is the detailed description of every file produced by parser: 

NB-ARC_blastp.out.all_hits
contains info about ALL HITS in blast report
 1 column: "Query" sequence ID
 2 column: "Subject" sequence ID
 3 column: normalized expectation (-log(Exp))
 4 column: percent of identity
 5 column: number of perfect matches
 6 column: length of the alignment
 7 column: hit number for primary alignment (1 is the best first hit)
 8 column: hit number for alternative alignment
 9 column: PRM stands for primary alignment, ALT for alternative alignment
10 column: first position of the "Query" sequence in the alignment
11 column: last position of the "Query" sequence in the alignment
12 column: first position of the "Subject" sequence in the alignment
13 column: last position of the "Subject" sequence in the alignment
NB-ARC_blastp.out.best_hit
contains info about FIRST BEST hits only
 1 column: "Query" sequence ID
 2 column: "Subject" sequence ID
 3 column: normalized expectation (-log(Exp))
 4 column: percent of identity
 5 column: number of perfect matches
 6 column: length of the alignment
 7 column: hit number for primary alignment (1 is the best first hit)
In our particular case when we run the set of genes against itself, best hit, of course, is to itself. This file is really useful when you run one set of genes against another. For example, Lettuce/Sunflower COS candidates (Conserved Orthologs Set) BLAST search against Arabidopsis genome and its validation by tcl_blast_parser_123_V007.tcl 

NB-ARC_blastp.out.blast_stat
contains info of HOW MANY HITS every "query" sequence has. If it is just a single hit, special mark "SINGLE_HIT" is placed at an additional column

NB-ARC_blastp.out.id_list
list of all gene IDs found in NB-ARC_blastp.out file including all "query" IDs as well as all "subject" IDs

NB-ARC_blastp.out.matrix
pairwise (binary) matrix for all primary hits if they are better than 20 (1e-20) expectation cutoff value, 40% identity and 100 aa (or nt) alignment overlap length. The three values of expectation, identity and overlap cutoff are the third, fourth and fifth arguments correspondingly when the script is executed from command line. 
 1st and 2nd column: pair of genes
 3rd column: IDENTITY value normalized between 0 and 1
 4th column: normalized expectation (-log(Exp))
 5th column: length of the alignment
This MATRIX file can be used by PhyloGrapher and GenomePixelizer without any further modifications. 

NB-ARC_blastp.out.two_hits
if "query" has two or more hits, additional data will be written into the "TWO HITS" file. This file compares expectation, identity and alignment length scores for the best first hit to the next after him. If differences of these scores are greater than cutoff values defined in the body of parser, then special mark "GOOD_DIFF" will be added to the last column. Otherwise the differences are considered as "BAD_DIFF". 

You can check how useful this file on the example Lettuce/Sunflower COS candidates (Conserved Orthologs Set) web page. 


PROTEIN SEQUENCE CLUSTERING


      If you run tcl_blast_parser_123_V007.tcl with "GRAPH" option, for example: 

      tcl_blast_parser_123_V007.tcl NB-ARC_blastp.out NB-ARC_blastp.out 20 40 100 GRAPH 

in this case two additional files will be generated: 

      NB-ARC_blastp.out.adj_list
      NB-ARC_blastp.out.group_degree_info

NB-ARC_blastp.out.adj_list
is an Adjacency List for protein sequences based on Matrix File. If query (gene, first column) is similar to other genes (subject in BLAST report) within defined cutoff values (expectation, identity and alignment length) then these gene IDs are written into corresponding row. In other words, this is a list of nodes (genes) with direct connection to each others. 

NB-ARC_blastp.out.group_degree_info
is a Group Degree Info file. Genes (protein sequences) may have similarity to each other via transitive homology. Group Degree Info file represents information about clusters of genes belonging to distinct groups. Each group in Group Degree Info file is a connected graph. It means each node (gene) can reach all other nodes (genes) via edges (identity scores).
1 column -- Node (gene) ID
2 column -- Number of other genes connected to the current gene
3 column -- Graph size (number of genes in the graph)
4 column -- Group number
5 column -- Either "****" or nothing. The "****" indicates the beginning of a new group. This is only for visual purpose.
tcl_blast_parser_123_V007.tcl can easily cluster group of genes up to 1000 in a set. To process a set of genes with number greater than 1000 we recommend to use Graph9 program. It is written in C. It works much faster and provides additional information about articulation point (or bridges) which helps identify multidomain sequences.

DOWNLOAD: 
tcl_blast_parser_123_V007.tcl 
Tcl/Tk ToolKit 

tcl_blast_parser_123_V017.tcl 
New version "017" is almost identical to version "007". New version "017" generates two additional "info1" and "info2" files extracting description line from BLAST report. "info1" and "info2" files are ready to go into mySQL database Click here to read more about "info" output file formats. 



email: Alexander Kozik 
Last modified July 23, 2003 