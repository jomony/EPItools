#!/usr/bin/bash

PATH=$PATH:/mnt/INET2/apps/bowtie2-2.1.0/:/mnt/INET2/apps/test/BSMAP-master/

OPT=$2

mkdir bsmap_RUN
cd bsmap_RUN

if [ $1 == "athal" ]
then
	id=athal
	mkdir $id; cd $id
	cp /mnt/INET2/raw_data/thomas.nussbaumer/epigenomics/seq/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz .
	gunzip -f Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz
	GENOME=Arabidopsis_thaliana.TAIR10.dna.toplevel.fa
elif [ $1 == "wheat" ]
then
	mkdir wheat; cd wheat;
	cp /mnt/INET2/epigenom/simulation/sherman/genome/wheat/iwgsc_refseqv1.0_chr1A.fsa.zip .
	cp /mnt/INET2/epigenom/simulation/sherman/genome/wheat/iwgsc_refseqv1.0_chr1B.fsa.zip .
	cp /mnt/INET2/epigenom/simulation/sherman/genome/wheat/iwgsc_refseqv1.0_chr1D.fsa.zip .
	unzip iwgsc_refseqv1.0_chr1A.fsa.zip
	unzip iwgsc_refseqv1.0_chr1B.fsa.zip
	unzip iwgsc_refseqv1.0_chr1D.fsa.zip
	mkdir genome_wheat
	mv iwgsc_refseqv1.0_chr1A.fsa genome_wheat
	mv iwgsc_refseqv1.0_chr1B.fsa genome_wheat
	mv iwgsc_refseqv1.0_chr1D.fsa genome_wheat
	cd genome_wheat
	cat iwgsc_refseqv1.0_chr1A.fsa > LG1_wheat.fasta
	cat iwgsc_refseqv1.0_chr1B.fsa >> LG1_wheat.fasta
	cat iwgsc_refseqv1.0_chr1D.fsa >> LG1_wheat.fasta
	cd ..
	GENOME=genome_wheat
	CHR=LG1_wheat.fasta
	id="wheat"
else
	exit
fi

id=$1

for PROC in 1 #15 10 5 1
do
	if [ $1 == "athal"  ]
	then
		FASTQ=/mnt/INET2/raw_data/thomas.nussbaumer/epigenomics/seq/SRR4295494_1.fastq
		OUTPUT=""
		if [ $OPT == "ALL" ]
		then
			MY_FILE=$FASTQ
		elif [ $OPT == "EXTRA" ]
		then
			MY_FILE=$3
			OUTPUT=$(basename $MY_FILE)_
		else
			tmp=$(mktemp)
			head -n 100000 $FASTQ > $tmp
			MY_FILE=$tmp
		fi
		{ time bsmap -p $PROC -a ${MY_FILE} -d ${GENOME} -o ${OUTPUT}${PROC}_${id}_bsmap.sam ; } 2> ${OUTPUT}${PROC}_${id}_bsmap_time.txt
	else
                FASTQ=/mnt/INET2/raw_data/thomas.nussbaumer/epigenomics/seq/ERR1141918_1.fastq
		OUTPUT=""
		if [ $OPT == "ALL" ]
		then
			MY_FILE=$FASTQ
		elif [ $OPT == "EXTRA" ]
		then
			MY_FILE=$3
			OUTPUT=$(basename $MY_FILE)_
		else
			tmp=$(mktemp)
			head -n 100000 $FASTQ > $tmp
			MY_FILE=$tmp
		fi
                { time bsmap -p $PROC -a ${MY_FILE} -d ${GENOME} -o ${OUTPUT}${PROC}_${id}_bsmap.sam ; } 2> ${OUTPUT}${PROC}_${id}_bsmap_time.txt
	fi
done
