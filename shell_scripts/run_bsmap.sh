#!/usr/bin/bash

PATH=$PATH:/mnt/INET2/apps/bowtie2-2.1.0/:/mnt/INET2/apps/test/BSMAP-master/

OPT=$2

mkdir bsmap_RUN
cd bsmap_RUN

if [ $1 == "athal" ]
then
	id=athal
	mkdir $id; cd $id
	cp /mnt/INET2/raw_data/thomas.nussbaumer/epigenomics/seq/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa .
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
        GENOME=genome_wheat_1A/LG1_wheat.fasta
	id="wheat"
elif [ $1 == "wheat1A" ]
then
	mkdir wheat1A; cd wheat1A;
	cp /mnt/INET2/epigenom/simulation/sherman/genome/wheat/iwgsc_refseqv1.0_chr1A.fsa.zip .
	unzip iwgsc_refseqv1.0_chr1A.fsa.zip
	mkdir genome_wheat1A
	mv iwgsc_refseqv1.0_chr1A.fsa genome_wheat1A
	cd genome_wheat1A
	cat iwgsc_refseqv1.0_chr1A.fsa > LG1A_wheat.fasta
	cd ..
	GENOME=genome_wheat1A/LG1A_wheat.fasta
	id="wheat1A"
elif [ $1 == "alyr" ]
then
	echo "alyr"
	id="alyr"
	mkdir $id; cd $id;
	GENOME=genome_${id}
	CHR=genome_${id}.fasta
	cp /mnt/INET2/raw_data/thomas.nussbaumer/epigenomics/seq/Arabidopsis_lyrata.v.1.0.dna.toplevel.fa .
	mkdir genome_${id}
	mv Arabidopsis_lyrata.v.1.0.dna.toplevel.fa ${GENOME}
	cd ${GENOME}
	cat Arabidopsis_lyrata.v.1.0.dna.toplevel.fa > ${CHR}
	cd ..
        GENOME=${GENOME}/${CHR}
elif [ $1 == "gmax" ]
then
	echo "gmax"
	id="gmax"
	mkdir $id; cd $id;
	GENOME=genome_${id}
	CHR=genome_${id}.fasta
	cp /mnt/INET2/raw_data/thomas.nussbaumer/epigenomics/seq/Glycine_max.Glycine_max_v2.1.dna.toplevel.fa .
	mkdir genome_${id}
	mv Glycine_max.Glycine_max_v2.1.dna.toplevel.fa ${GENOME}
	cd ${GENOME}
	cat Glycine_max.Glycine_max_v2.1.dna.toplevel.fa > ${CHR}
	cd ..
	GENOME=${GENOME}/${CHR}
elif [ $1 == "osativa" ]
then
	id="osativa"
	mkdir $id; cd $id;
	GENOME=genome_${id}
	CHR=genome_${id}.fasta
	cp /mnt/INET2/raw_data/thomas.nussbaumer/epigenomics/seq/Oryza_sativa.IRGSP-1.0.dna.toplevel.fa .
	mkdir genome_${id}
	mv Oryza_sativa.IRGSP-1.0.dna.toplevel.fa ${GENOME}
	cd ${GENOME}
	cat Oryza_sativa.IRGSP-1.0.dna.toplevel.fa > ${CHR}
	cd ..
	GENOME=${GENOME}/${CHR}
else
	exit
fi

id=$1

for PROC in 20 #20 15 10 5 1
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
			head -n 1000000 $FASTQ > $tmp
			MY_FILE=$tmp
		fi
		{ time bsmap -p $PROC -a ${MY_FILE} -d ${GENOME} -o ${OUTPUT}${PROC}_${id}_bsmap.sam ; } 2> ${OUTPUT}${PROC}_${id}_bsmap_time.txt
	elif [ $1 == "wheat" ]
	then
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
			head -n 1000000 $FASTQ > $tmp
			MY_FILE=$tmp
		fi
                { time bsmap -p $PROC -a ${MY_FILE} -d ${GENOME} -o ${OUTPUT}${PROC}_${id}_bsmap.sam ; } 2> ${OUTPUT}${PROC}_${id}_bsmap_time.txt
	elif [ $1 == "wheat1A" ]
	then
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
                        head -n 1000000 $FASTQ > $tmp
                        MY_FILE=$tmp
                fi
                { time bsmap -p $PROC -a ${MY_FILE} -d ${GENOME} -o ${OUTPUT}${PROC}_${id}_bsmap.sam ; } 2> ${OUTPUT}${PROC}_${id}_bsmap_time.txt
	elif [ $1 == "alyr" ]
	then
                FASTQ=/mnt/INET2/epigenom/src/new_fastq/SRR3880297_1.fastq
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
                        head -n 1000000 $FASTQ > $tmp
                        MY_FILE=$tmp
                fi
                { time bsmap -p $PROC -a ${MY_FILE} -d ${GENOME} -o ${OUTPUT}${PROC}_${id}_bsmap.sam ; } 2> ${OUTPUT}${PROC}_${id}_bsmap_time.txt
	elif [ $1 == "gmax" ]
	then
                FASTQ=/mnt/INET2/epigenom/src/new_fastq/SRR5079790.fastq
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
                        head -n 1000000 $FASTQ > $tmp
                        MY_FILE=$tmp
                fi
                { time bsmap -p $PROC -a ${MY_FILE} -d ${GENOME} -o ${OUTPUT}${PROC}_${id}_bsmap.sam ; } 2> ${OUTPUT}${PROC}_${id}_bsmap_time.txt

	elif [ $1 == "osativa" ]
	then
                FASTQ=/mnt/INET2/epigenom/src/new_fastq/SRR7265433.fastq
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
                        head -n 1000000 $FASTQ > $tmp
                        MY_FILE=$tmp
                fi
                { time bsmap -p $PROC -a ${MY_FILE} -d ${GENOME} -o ${OUTPUT}${PROC}_${id}_bsmap.sam ; } 2> ${OUTPUT}${PROC}_${id}_bsmap_time.txt
	fi
done
