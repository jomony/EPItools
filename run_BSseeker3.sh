PATH=$PATH:PLACEHOLDER/epigenome_evaluation-0.1/apps/bs3-dev1/
BS_ALIGN=PLACEHOLDER/epigenome_evaluation-0.1/apps/bs3-dev1/bs_align/
SNAP_MAPPER_PATH=PLACEHOLDER/EPIGENOMICS/old/epigenome_evaluation-0.1/apps/snap-aligner-1.0beta.23/bin/snap-aligner
MY_GENOMES=PLACEHOLDER/EPIGENOMICS/revision2/my_genomes/
MY_FASTQ=PLACEHOLDER/EPIGENOMICS/revision2/my_fastq

MY_CWD=$(pwd)

mkdir bseeker3_RUN
cd bseeker3_RUN

GID=$1
STEP=$2
OPT=$3

# -----------------------------------------------

if [ $GID == "athal" ]
then
	echo "athal"
elif [ $GID == "wheat" ]
then
	echo "wheat"
elif [ $GID == "wheat1A" ]
then
	echo "wheat1A"
elif [ $GID == "alyr" ]
then
	echo "alyr"
elif [ $GID == "gmax" ]
then
        echo "gmax"
elif [ $GID == "osativa" ]
then
        echo "osativa"
else
	exit
fi

# -----------------------------------------------

if [ $STEP == 0 ]
then
	if [ $GID == "athal" ]
	then
	        id="athal";
		mkdir $id; cd $id
		cp ${MY_GENOMES}/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz .
		gunzip -f Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz
		CHR=Arabidopsis_thaliana.TAIR10.dna.toplevel.fa
	elif [ $GID == "wheat" ]
	then
                id="wheat"
                mkdir $id; cd $id;
                cp ${MY_GENOMES}/iwgsc_refseqv1.0_chr1A.fsa.gz .
                cp ${MY_GENOMES}/iwgsc_refseqv1.0_chr1B.fsa.gz .
                cp ${MY_GENOMES}/iwgsc_refseqv1.0_chr1D.fsa.gz .
                gunzip iwgsc_refseqv1.0_chr1A.fsa.gz
                gunzip iwgsc_refseqv1.0_chr1B.fsa.gz
                gunzip iwgsc_refseqv1.0_chr1D.fsa.gz
                cat iwgsc_refseqv1.0_chr1A.fsa > LG1_wheat.fasta
                cat iwgsc_refseqv1.0_chr1B.fsa >> LG1_wheat.fasta
                cat iwgsc_refseqv1.0_chr1D.fsa >> LG1_wheat.fasta
                CHR=LG1_wheat.fasta
	elif [ $GID == "wheat1A" ]
	then
		id="wheat1A"
		mkdir $id; cd $id
                cp ${MY_GENOMES}/iwgsc_refseqv1.0_chr1A.fsa.gz .
                gunzip -f iwgsc_refseqv1.0_chr1A.fsa.gz
                CHR=iwgsc_refseqv1.0_chr1A.fsa
	elif [ $GID == "alyr" ]
	then
                id="alyr"
                mkdir $id; cd $id
                cp ${MY_GENOMES}/Arabidopsis_lyrata.v.1.0.dna.toplevel.fa.gz .
                gunzip -f Arabidopsis_lyrata.v.1.0.dna.toplevel.fa.gz
                CHR=Arabidopsis_lyrata.v.1.0.dna.toplevel.fa
	elif [ $GID == "gmax" ]
	then
                id="gmax"
                mkdir $id; cd $id
                cp ${MY_GENOMES}/Glycine_max.Glycine_max_v2.1.dna.toplevel.fa.gz .
                gunzip -f Glycine_max.Glycine_max_v2.1.dna.toplevel.fa
                CHR=Glycine_max.Glycine_max_v2.1.dna.toplevel.fa
	elif [ $GID == "osativa" ]
	then
                id="osativa"
                mkdir $id; cd $id
                cp ${MY_GENOMES}/Oryza_sativa.IRGSP-1.0.dna.toplevel.fa.gz .
                gunzip -f Oryza_sativa.IRGSP-1.0.dna.toplevel.fa.gz
                CHR=Oryza_sativa.IRGSP-1.0.dna.toplevel.fa
	else
	        exit
	fi
	rm snap
	ln -s ${SNAP_MAPPER_PATH} snap
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
		FASTQ=${MY_FASTQ}/SRR4295494_1.fastq
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
		FASTQ=${MY_FASTQ}/ERR1141918_1.fastq
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
	elif [ $GID == "wheat1A" ]
	then
                OUTPUT=""
                cd $id
                CHR=iwgsc_refseqv1.0_chr1A.fsa
                FASTQ=${MY_FASTQ}/ERR1141918_1.fastq
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
        elif [ $GID == "alyr" ]
        then
                OUTPUT=""
                cd $id
                CHR=${MY_GENOME}/Arabidopsis_lyrata.v.1.0.dna.toplevel.fa
                FASTQ=${MY_FASTQ}/SRR3880297_1.fastq
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
        elif [ $GID == "gmax" ]
        then
                OUTPUT=""
                cd $id
                CHR=Glycine_max.Glycine_max_v2.1.dna.toplevel.fa
                FASTQ=${MY_FASTQ}/SRR5079790.fastq
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
        elif [ $GID == "osativa" ]
        then
                OUTPUT=""
                cd $id
                CHR=Oryza_sativa.IRGSP-1.0.dna.toplevel.fa
                FASTQ=${MY_FASTQ}/SRR7265433.fastq
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
	fi
        DB=genome_${id}

	PID=20
	echo  ${MY_CWD}/bseeker3_RUN/${id}/${DB}/reference_genome/
	ln -s ${BS_ALIGN} .
	{ time bs3-align.py --temp_dir=$TEMP -l $L -i ${MY_FILE} -g ${CHR} -d ${MY_CWD}/bseeker3_RUN/${id}/reference_genome/ -o ${OUTPUT}${PID}_${id}_bsseeker3.sam -f sam  ; } 2> ${OUTPUT}${PID}_${id}_bsseker3_time.txt
fi

