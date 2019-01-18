#!/usr/bin/bash

PATH=$PATH:/mnt/INET2/apps/BSseeker3/bs3-dev1/:/mnt/INET2/apps/samtools-1.9/

MY_CWD=$(pwd)

mkdir bseeker3_RUN
cd bseeker3_RUN

GID=$1
STEP=$2
OPT=$3

if [ $GID == "athal" ]
then
	echo "athal"
elif [ $GID == "wheat" ]
then
	echo "wheat"
else
	exit
fi

if [ $STEP == 0 ]
then
	if [ $GID == "athal" ]
	then
	        id="athal";
		mkdir $id; cd $id
		cp /mnt/INET2/raw_data/thomas.nussbaumer/epigenomics/seq/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz .
		gunzip -f Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz
		CHR=Arabidopsis_thaliana.TAIR10.dna.toplevel.fa
	elif [ $GID == "wheat" ]
	then
                id="wheat"
                mkdir $id; cd $id;
                cp /mnt/INET2/epigenom/simulation/sherman/genome/wheat/iwgsc_refseqv1.0_chr1A.fsa.zip .
                cp /mnt/INET2/epigenom/simulation/sherman/genome/wheat/iwgsc_refseqv1.0_chr1B.fsa.zip .
                cp /mnt/INET2/epigenom/simulation/sherman/genome/wheat/iwgsc_refseqv1.0_chr1D.fsa.zip .
                unzip iwgsc_refseqv1.0_chr1A.fsa.zip
                unzip iwgsc_refseqv1.0_chr1B.fsa.zip
                unzip iwgsc_refseqv1.0_chr1D.fsa.zip
                cat iwgsc_refseqv1.0_chr1A.fsa > LG1_wheat.fasta
                cat iwgsc_refseqv1.0_chr1B.fsa >> LG1_wheat.fasta
                cat iwgsc_refseqv1.0_chr1D.fsa >> LG1_wheat.fasta
                CHR=LG1_wheat.fasta
	else
	        exit
	fi
	rm snap
	ln -s /mnt/INET2/epigenom/simulation/sherman/snap_v1.0beta23/bin/snap-aligner snap
	bs3-build.py -f ${CHR} --aligner=snap
fi

if [ $STEP == 1 ]
then
	id=$GID
	DB=genome_${id}
	if [ $id == "athal" ]
	then
		OUTPUT=""
		cd $id
                CHR=Arabidopsis_thaliana.TAIR10.dna.toplevel.fa
		FASTQ=/mnt/INET2/raw_data/thomas.nussbaumer/epigenomics/seq/SRR4295494_1.fastq
		if [ $OPT == "ALL" ]
		then
			MY_FILE=$FASTQ
		elif [ $OPT == "EXTRA" ]
		then
			MY_FILE=$4
			OUTPUT=$(basename $MY_FILE})_
		else
			temp=$(mktemp)
			head -n 100000 $FASTQ > $temp
			ed -s $temp <<< w
			MY_FILE=$temp

		fi
		L=5000000
	elif [ $GID == "wheat" ]
	then
		OUTPUT=""
		cd $id
                CHR=LG1_wheat.fasta
		FASTQ=/mnt/INET2/raw_data/thomas.nussbaumer/epigenomics/seq/ERR1141918_1.fastq
                if [ $OPT == "ALL" ]
                then
                        MY_FILE=$FASTQ
	                L=120000000
		elif [ $OPT == "EXTRA" ]
		then
			echo "JA-0"
			MY_FILE=$4
			OUTPUT=$(basename $MY_FILE})_
	                L=10000000
                elif [ $OPT == "SUB" ]
		then
			echo "SUB"
                        temp=$(mktemp)
                        head -n 100000 $FASTQ > $temp
                        MY_FILE=$temp
			L=1000000
		elif [ $OPT == "INDEX" ]
		then
			echo "INDEX"
			CHR=/mnt/INET2/epigenom/src/bseeker3_RUN/wheat/iwgsc_refseqv1.0_chr1A.fsa
                        MY_FILE=$FASTQ
                        L=120000000
			TEMP=/mnt/INET2/epigenom/src/bseeker3_RUN/wheat/tmp
                fi
	fi
        DB=genome_${id}

	PID=20
	echo  ${MY_CWD}/bseeker3_RUN/${id}/${DB}/reference_genome/
	ln -s /mnt/INET2/apps/BSseeker3/bs3-dev1/bs_align/ .
	{ time bs3-align.py --temp_dir=$TEMP -l $L -i ${MY_FILE} -g ${CHR} -d ${MY_CWD}/bseeker3_RUN/${id}/reference_genome/ -o ${OUTPUT}${PID}_${id}_bsseeker3.sam -f sam  ; } 2> ${OUTPUT}${PID}_${id}_bsseker3_time.txt
fi



