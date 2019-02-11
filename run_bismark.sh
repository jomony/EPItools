#!/usr/bin/bash

PATH=$PATH:/mnt/INET2/apps/bowtie2-2.1.0/:/mnt/INET2/apps/Bismark-0.19.1/:/mnt/INET2/apps/samtools-1.9

STEP=$2

mkdir bismark_RUN
cd bismark_RUN

# -----------------------------------------------------------------------------------------------------------------------------

if [ $STEP == 0 ]
then
	if [ $1 == "athal" ]
	then
		mkdir athal; cd athal;
		cp /mnt/INET2/raw_data/thomas.nussbaumer/epigenomics/seq/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz .
		gunzip Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz
		mkdir genome_athal
		mv Arabidopsis_thaliana.TAIR10.dna.toplevel.fa genome_athal
		GENOME=genome_athal
	        CHR=genome_athal/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa
	        id="athal"
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
                cat Glycine_max.Glycine_max_v2.1.dna.toplevel.fa > ${CHR}
                cd ..
	else
		exit
	fi
fi

# -----------------------------------------------------------------------------------------------------------------------------

if [ $STEP == 1 ]
then
	if [ $1 == "athal" ]
	then
		cd athal
		GENOME=genome_athal
	fi

	if [ $1 == "wheat" ]
	then
		cd wheat
		GENOME=genome_wheat
	fi

	if [ $1 == "alyr" ]
	then
		cd alyr
		echo $(pwd)
		GENOME=genome_alyr
	fi

	if [ $1 == "gmax" ]
	then
		cd gmax
		GENOME=genome_gmax
	fi

	if [ $1 == "osativa" ]
	then
		cd osativa
		GENOME=genome_osativa
	fi

	bismark_genome_preparation ${GENOME}
fi

# -----------------------------------------------------------------------------------------------------------------------------

if [ $STEP == 2 ]
then

	if [ $1 == "athal" ]
	then
		cd athal
		GENOME=genome_athal
		FASTQ=/mnt/INET2/raw_data/thomas.nussbaumer/epigenomics/seq/SRR4295494_1.fastq
		id=athal
	fi

	if [ $1 == "wheat" ]
	then
		cd wheat
		GENOME=genome_wheat
		FASTQ=/mnt/INET2/raw_data/thomas.nussbaumer/epigenomics/seq/ERR1141918_1.fastq
		id=wheat
	fi

	if [ $1 == "alyr" ]
	then
		cd alyr
		GENOME=genome_alyr
		FASTQ=
	fi

	if [ $1 == "gmax" ]
	then
		cd gmax
		GENOME=genome_gmax
		FASTQ=
	fi

	if [ $1 == "osativa" ]
	then
		cd osativa
		GENOME=genome_osativa
		FASTQ=
	fi

	FASTQ_s=$(basename $FASTQ)
	for PID in 5 #20 #15 10 5 1
	do
		OUTPUT=""
		tmp=$(mktemp)

		if [ $3 == "SUB" ]
		then
			head -n 10000 ${FASTQ} > $tmp
			MY_FILE=$tmp
		elif [ $3 == "EXTRA" ]
		then
			MY_FILE=$4
			OUTPUT=$(basename $MY_FILE)_
		else
			MY_FILE=${FASTQ}
		fi

		echo $MY_FILE

		{ time bismark --parallel $PID ${GENOME} $MY_FILE 2> ${OUTPUT}${PID}_${id}_bismark_output.txt ; } 2> ${OUTPUT}${PID}_${id}_bismark_time.txt
		FASTQ_s=$(basename ${MY_FILE} | sed 's/.fastq//g')
		samtools view ${FASTQ_s}_bismark_bt2.bam > ${PID}_${id}_bismark.sam
		rm ${FASTQ_s}_bismark_bt2.bam
		rm ${FASTQ_s}_bismark_bt2_SE_report.txt
	done
fi

# -----------------------------------------------------------------------------------------------------------------------------


