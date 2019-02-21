#!/usr/bin/bash

export PATH=$PATH:/proj/BIB/apps/segemehl-0.3.4

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
elif [ $1 == "wheat1A" ]
then
	echo "wheat1A"
elif [ $1 == "alyr" ]
then
        echo "alyr"
elif [ $1 == "gmax" ]
then
        echo "gmax"
elif [ $1 == "osativa" ]
then
        echo "osativa"

else
	exit
fi

if  [ $STEP == 0 ]
then
	if [ $1 == "athal" ]
	then
		id="athal";
		mkdir $id; cd $id
                GENOME=genome_${id}
                CHR=genome_${id}.fasta
		FID=Arabidopsis_thaliana.TAIR10.dna.toplevel.fa
		cp /proj/BIB/EPItools-master/my_genomes/${FID}.gz .
		gunzip -f ${FID}.gz
		mkdir $GENOME
		cp $FID $GENOME
		cd $GENOME
		cat ${FID} > $CHR
	elif [ $1 == "wheat" ]
	then
		FID1=iwgsc_refseqv1.0_chr1A.fsa
		FID2=iwgsc_refseqv1.0_chr1B.fsa
		FID3=iwgsc_refseqv1.0_chr1D.fsa
                cp /proj/BIB/EPItools-master/my_genomes/${FID1}.gz .
                cp /proj/BIB/EPItools-master/my_genomes/${FID2}.gz .
                cp /proj/BIB/EPItools-master/my_genomes/${FID3}.gz .
                gunzip ${FID1}.zip
                gunzip ${FID2}.zip
                gunzip ${FID3}.zip
                mkdir genome_wheat
                mv ${FID1} genome_wheat
                mv ${FID2} genome_wheat
                mv ${FID3} genome_wheat
                cd genome_wheat
                cat ${FID1} > LG1_wheat.fasta
                cat ${FID2} >> LG1_wheat.fasta
                cat ${FID3} >> LG1_wheat.fasta
                GENOME=genome_wheat
                CHR=LG1_wheat.fasta
                id="wheat"
	elif [ $1 == "wheat1A" ]
	then
		echo "wheat1A"
                mkdir wheat1A; cd wheat1A;
		id="wheat1A"
                GENOME=genome_${id}
                CHR=genome_${id}.fasta
		FID=iwgsc_refseqv1.0_chr1A.fsa
                cp /proj/BIB/EPItools-master/my_genomes/${FID}.gz .
                gunzip ${FID}.gz
                mkdir genome_wheat1A
                mv ${FID} genome_wheat1A
                cd genome_wheat1A
                cat ${FID} > ${CHR}
                cd ..
	elif [ $1 == "alyr" ]
	then
		echo "alyr"
		id="alyr"
		mkdir $id; cd $id;
		GENOME=genome_${id}
		CHR=genome_${id}.fasta
		FID=Arabidopsis_lyrata.v.1.0.dna.toplevel.fa
		cp /proj/BIB/EPItools-master/my_genomes/${FID}.gz .
		gunzip ${FID}.gz
		mkdir genome_${id}
		mv ${FID} ${GENOME}
		cd ${GENOME}
		cat ${FID} > ${CHR}
	elif [ $1 == "gmax" ]
	then
		echo "gmax"
		id="gmax"
                mkdir $id; cd $id;
                GENOME=genome_${id}
                CHR=genome_${id}.fasta
		FID=Glycine_max.Glycine_max_v2.1.dna.toplevel.fa
                cp /proj/BIB/EPItools-master/my_genomes/${FID}.gz .
		gunzip ${FID}.gz
                mkdir genome_${id}
                mv ${FID} ${GENOME}
                cd ${GENOME}
                cat ${FID} > ${CHR}
		cd ..
	elif [ $1 == "osativa" ]
	then
		echo "osativa"
		id="osativa"
                mkdir $id; cd $id;
		GENOME=genome_${id}
		CHR=genome_${id}.fasta
		FID=Oryza_sativa.IRGSP-1.0.dna.toplevel.fa
		cp /proj/BIB/EPItools-master/my_genomes/${FID}.gz .
		gunzip ${FID}.gz
		mkdir genome_${id}
                mv ${FID} ${GENOME}
                cd ${GENOME}
                cat ${FID} > ${CHR}
		cd ..
		exit
	fi
fi

if  [ $STEP == 1 ]
then
	if  [ $1 == "athal"  ]
	then
		cd athal;id="athal"
		GENOME=genome_$id
		CHR=genome_$id.fasta
		segemehl.x -x ${id}_segemehl.ctidx -y ${id}_segemehl.gaidx -d ${GENOME}/${CHR} -F 2
	elif [ $1 == "wheat" ]
	then
            	cd wheat;id="wheat"
                GENOME=genome_$id
                CHR=genome_$id.fa
	        segemehl.x -x ${id}_segemehl.ctidx -y ${id}_segemehl.gaidx -d ${GENOME}/${CHR} -F 2
	elif [ $1 == "wheat1A" ]
	then
            	cd wheat1A;id="wheat1A"
                GENOME=genome_$id
                CHR=genome_$id.fasta
                segemehl.x -x ${id}_segemehl.ctidx -y ${id}_segemehl.gaidx -d ${GENOME}/${CHR} -F 2
	elif [ $1 == "alyr" ]
	then
            	cd alyr;id="alyr"
                GENOME=genome_$id
                CHR=genome_$id.fasta
                segemehl.x -x ${id}_segemehl.ctidx -y ${id}_segemehl.gaidx -d ${GENOME}/${CHR} -F 2
	elif [ $1 == "gmax" ]
	then
            	cd gmax;id="gmax"
                GENOME=genome_$id
                CHR=genome_$id.fasta
                segemehl.x -x ${id}_segemehl.ctidx -y ${id}_segemehl.gaidx -d ${GENOME}/${CHR} -F 2
	elif [ $1 == "osativa" ]
	then
            	cd osativa;id="osativa"
                GENOME=genome_$id
                CHR=genome_$id.fasta
                segemehl.x -x ${id}_segemehl.ctidx -y ${id}_segemehl.gaidx -d ${GENOME}/${CHR} -F 2
	fi
fi

if [ $STEP == 2 ]
then
        for PROC in 8 #20 1 #15 10 5 1
	do
		if [ $1 == "athal"  ]
		then
			id="athal"; cd $id
			CHR=Arabidopsis_thaliana.TAIR10.dna.toplevel.fa
			FASTQ=/proj/BIB/EPItools-master/my_fastq/SRR4295494_1.fastq
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
			FASTQ=/proj/BIB/EPItools-master/my_fastq/ERR1141918_1.fastq
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
		elif [ $1 == "wheat1A" ]
		then
			id="wheat1A"; cd $id
			FASTQ=/proj/BIB/EPItools-master/my_fastq/ERR1141918_1.fastq
			CHR=genome_${id}/genome_${id}.fasta
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
                        { time segemehl.x --threads $PROC -i ${id}_segemehl.ctidx -F 2 -j ${id}_segemehl.gaidx -d $CHR -q ${MY_FILE} -o ${OUTPUT}${PROC}_${id}_segemehl.sam 2>  ${PROC}_${id}_segemehl_output.txt ; } 2> ${PROC}_${id}_segemehl_time.txt

		elif [ $1 == "alyr" ]
		then
			id="alyr"; cd $id
			FASTQ=/proj/BIB/EPItools-master/my_fastq/SRR3880297_1.fastq
                        CHR=genome_${id}/genome_${id}.fasta
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
                        { time segemehl.x --threads $PROC -i ${id}_segemehl.ctidx -F 2 -j ${id}_segemehl.gaidx -d $CHR -q ${MY_FILE} -o ${OUTPUT}${PROC}_${id}_segemehl.sam 2>  ${PROC}_${id}_segemehl_output.txt ; } 2> ${PROC}_${id}_segemehl_time.txt
		elif [ $1 == "gmax" ]
		then
			id="gmax";cd $id
			FASTQ=/proj/BIB/EPItools-master/my_fastq/SRR5079790.fastq
                        CHR=genome_${id}/genome_${id}.fasta
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
                        { time segemehl.x --threads $PROC -i ${id}_segemehl.ctidx -F 2 -j ${id}_segemehl.gaidx -d $CHR -q ${MY_FILE} -o ${OUTPUT}${PROC}_${id}_segemehl.sam 2>  ${PROC}_${id}_segemehl_output.txt ; } 2> ${PROC}_${id}_segemehl_time.txt
		elif [ $1 == "osativa" ]
		then
			id="osativa"; cd $id
			FASTQ=/proj/BIB/EPItools-master/my_fastq/SRR726543_1.fastq
                        CHR=genome_${id}/genome_${id}.fasta
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
                        { time segemehl.x --threads $PROC -i ${id}_segemehl.ctidx -F 2 -j ${id}_segemehl.gaidx -d $CHR -q ${MY_FILE} -o ${OUTPUT}${PROC}_${id}_segemehl.sam 2>  ${PROC}_${id}_segemehl_output.txt ; } 2> ${PROC}_${id}_segemehl_time.txt
		fi
	done
fi




