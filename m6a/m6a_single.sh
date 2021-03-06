#$ -cwd
################command lines####################
arg_input_seq=$1
arg_input_name=$2
arg_working_dir=$3
gff=$4
genome=$5
################programs directory#################
tophat=/psc/program/install/tophat-2.0.10/bin
trinity=/psc/home/sunyidan/tool/trinityrnaseq_r20140717
cufflink=/psc/program/install/cufflinks-2.2.1/
#gff=/psc/bioinformatics/sunyd/RNAseqlu/Arab/TAIR10.gff
#genome=/psc/bioinformatics/sunyd/RNAseqlu/Arab/arab10
file=/psc/bioinformatics/sunyd/identify/arab_rnaseq
script=/psc/home/sunyidan/scripts
echo "$arg_input_name begin at "  
    date

mkdir $arg_working_dir
#wget -rq $arg_input_web    ####get the sra file from NCBI	
#fastq-dump -O $arg_working_dir $arg_input_seq       ######convert the sra file into fastq
$script/modify_fastq_v1.pl -r $arg_working_dir -n $arg_input_name -a $arg_input_seq -s T -p 17 -l 25 -5 Uni -3 Index    ##########get the clean reads

#########################assemble the reads into transcripts####################
export LD_LIBRARY_PATH=/psc/program/install/boost-1.55/lib:$LD_LIBRARY_PATH
$tophat/tophat -p 32 -G $gff -o $arg_working_dir/${arg_input_name}_top $genome $arg_working_dir/$arg_input_name/Len_sort_step_4/${arg_input_name}.fastq.fq.trimmed.single.cut.single  #$file/SRR331227_1.fastq.fq.trimmed.single.cut.single1 
#$cufflink/cufflinks -o $arg_working_dir/${arg_input_name}_cuff --library-type fr-firststrand -p 32 -g $gff $arg_working_dir/${arg_input_name}_top/accepted_hits.bam         #####assmeble the reads using cufflinks
samtools sort -n $arg_working_dir/${arg_input_name}_top/accepted_hits.bam $arg_working_dir/${arg_input_name}_top/accepted_hits.sorted                                        
samtools view -h $arg_working_dir/${arg_input_name}_top/accepted_hits.sorted.bam > $arg_working_dir/${arg_input_name}_top/accepted_hits.sorted.sam 
#rm $arg_working_dir/${arg_input_name}*.fastq
#gtf_to_fasta $arg_working_dir/${arg_input_name}_cuff/transcripts.gtf ${genome}.fa $arg_working_dir/${arg_input_name}.fa             #####convert the cufflinks gtf file into fasta
#sed ':a; $!N; /^>/!s/\n\([^>]\)/\1/; ta; P; D' $arg_working_dir/${arg_input_name}.fa > $arg_working_dir/${arg_input_name}_cuff.fa
#mkdir $arg_working_dir/split_cuff
#split -a 3 -d $arg_working_dir/${arg_input_name}_cuff.fa $arg_working_dir/split_cuff/cuff
#for i in $arg_working_dir/split_cuff/cuff*0; do j=`echo $i |sed 's/0/zero/'`; mv $i $j; done
#for i in $arg_working_dir/split_cuff/cuff0*; do j=`echo $i |sed 's/0/zero/'`; mv $i $j; done
#mv $arg_working_dir/split_cuff/cuffzero0 $arg_working_dir/split_cuff/cuffzero1zero
#cd $arg_working_dir/split_cuff/
#rename '0' '' cuff0*
#rename '0' '' cuff0*
#cd $arg_working_dir/
########################another way for doing assemble using trinity###################
#$trinity/Trinity --seqType fq --JM 1500G --min_kmer_cov 2 --output $arg_working_dir/${arg_input_name}_trinity --single $arg_working_dir/$arg_input_name/Len_sort_step_4/${arg_input_name}_1.fastq.fq.trimmed.single.cut.single --CPU 60          #--left $rep1_1L1F  --right $rep1_1L1   --grid_conf $scripts/trinity_conf.txt
#cp $arg_working_dir/${arg_input_name}_trinity/Trinity.fasta $arg_working_dir/
#sed ':a; $!N; /^>/!s/\n\([^>]\)/\1/; ta; P; D' $arg_working_dir/${arg_input_name}_trinity/Trinity.fasta > $arg_working_dir/${arg_input_name}_trin.fa
#mkdir $arg_working_dir/split_trin
#split -d $arg_working_dir/${arg_input_name}_trin.fa $arg_working_dir/split_trin/trin
#cd $arg_working_dir/split_trin
#rename '0' '' $arg_working_dir/split_trin/trin0*
#for i in $arg_working_dir/split_trin/trin*0; do j=`echo $i |sed 's/0/zero/'`; mv $i $j; done
#for i in $arg_working_dir/split_trin/trin0*; do j=`echo $i |sed 's/0/zero/'`; mv $i $j; done
#mv $arg_working_dir/split_trin/trinzero0 $arg_working_dir/split_trin/trinzero1zero
echo "$arg_input_name finished at "
    date

