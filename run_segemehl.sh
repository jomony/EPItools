#!/usr/bin/bash

export PATH=$PATH:/mnt/INET2/apps/segemehl_0_2_0/segemehl

mkdir segemehl_RUN
cd segemehl_RUN

STEP=$2

OPT=$3

if [ $1 == "athal" ]
then
	echo "athal"
elif [ $1 == "wheat" ]
then
	echo "wheat"
else
	exit
fi

if  [ $STEP == 0 ]
then
	if [ $1 == "athal" ]
	then
		id="athal";
		mkdir $id; cd $id
		cp /mnt/INET2/raw_data/thomas.nussbaumer/epigenomics/seq/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz .
		gunzip -f Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz
		CHR=Arabidopsis_thaliana.TAIR10.dna.toplevel.fa
	elif [ $1 == "wheat" ]
	then
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
                GENOME=genome_wheat
                CHR=LG1_wheat.fasta
                id="wheat"
	else
		exit
	fi
fi

if  [ $STEP == 1 ]
then
	if  [ $1 == "athal"  ]
	then
		cd athal
                CHR=Arabidopsis_thaliana.TAIR10.dna.toplevel.fa
		id=athal
		GENOME=genome_athal
		segemehl.x -x ${id}_segemehl.ctidx -y ${id}_segemehl.gaidx -d ${GENOME}/${CHR} -F 2
	else
		cd wheat
                CHR=LG1_wheat.fasta
		id=wheat
		GENOME=genome_wheat
	        segemehl.x -x ${id}_segemehl.ctidx -y ${id}_segemehl.gaidx -d ${GENOME}/${CHR} -F 2
	fi
fi

if [ $STEP == 2 ]
then
        for PROC in 20 1 #15 10 5 1
	do
		if [ $1 == "athal"  ]
		then
			id="athal"; cd $id
			CHR=Arabidopsis_thaliana.TAIR10.dna.toplevel.fa
			FASTQ=/mnt/INET2/raw_data/thomas.nussbaumer/epigenomics/seq/SRR4295494_1.fastq
			OUTPUT=""
			if [ $OPT == "ALL" ]
			then
				MY_FILE=$FASTQ
			elif [ $OPT == "EXTRA" ]
			then
				MY_FILE=$4
				OUTPUT=$(basename $MY_FILE)_
			else
				temp=$(mktemp)
				head -n 100000 $FASTQ > $temp
				MY_FILE=$temp
			fi
                         { time segemehl.x --threads $PROC -i ${id}_segemehl.ctidx -F 2 -j ${id}_segemehl.gaidx -d $CHR -q ${MY_FILE} -o ${OUTPUT}${PROC}_${id}_segemehl.sam ; } 2> ${PROC}_${id}_segemehl_time.txt
		elif [ $1 == "wheat" ]
		then
			OUTPUT=""
                        id="wheat"; cd $id
                        CHR=iwgsc_refseqv1.0_chr1A.fsa
			FASTQ=/mnt/INET2/raw_data/thomas.nussbaumer/epigenomics/seq/ERR1141918_1.fastq
                        if [ $OPT == "ALL" ]
                        then
                                MY_FILE=$FASTQ
			elif [ $OPT == "EXTRA" ]
			then
				MY_FILE=$4
				OUTPUT=$(basename $MY_FILE)_
                        else
                                temp=$(mktemp)
                                head -n 100000 $FASTQ > $temp
                                MY_FILE=$temp
                        fi
			{ time segemehl.x --threads $PROC -i ${id}_segemehl.ctidx -F 2 -j ${id}_segemehl.gaidx -d $CHR -q ${MY_FILE} -o ${OUTPUT}${PROC}_${id}_segemehl.sam 2> ${PROC}_${id}_segemehl_output.txt ; } 2> ${PROC}_${id}_segemehl_time.txt
		fi
	done
fi




