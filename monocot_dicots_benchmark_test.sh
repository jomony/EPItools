#!/usr/bin/bash

# -----------------------------------------------------------

#OPT=SUB
OPT=ALL

# -----------------------------------------------------------

function bismark {
	for GID in athal gmax alyr osativa wheat1A
	do
		#./src/run_bismark.sh $GID 0 $OPT
		#./src/run_bismark.sh $GID 1 $OPT
		for STEP in {2..2}
		do
			/usr/bin/time -v ./src/run_bismark.sh $GID $STEP $OPT 2> BISMARK_${GID}_${OPT}_time.txt
		done
	done
}

bismark


exit

# -----------------------------------------------------------

function bsmap {
	./src/run_bsmap.sh $GID $OPT
}
#bsmap

# -----------------------------------------------------------

function segemehl {
	#./src/run_segemehl.sh $GID 0 $OPT
	#./src/run_segemehl.sh $GID 1 $OPT
	for STEP in {2..2}
	do
		./src/run_segemehl.sh $GID $STEP $OPT
	done
}
#segemehl

# -----------------------------------------------------------

function bsseeker3 {
	for STEP in {0..1}
	do
		src/run_BSseeker3.sh $GID $STEP $OPT
	done
}
#bsseeker3

# -----------------------------------------------------------



