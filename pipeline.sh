#!/usr/bin/bash

#gid=wheat
#tmp=$(mktemp)
#../../src/src/run_bismark.sh ${gid} 0 EXTRA $tmp
#../../src/src/run_bismark.sh ${gid} 1 EXTRA $tmp

#gid=wheat
#../../src/src/run_BSseeker3.sh $gid 0
#exit

rm simulated.fastq
for xx in 24
	do
	for yy in 8
		do
		for err in 0.5
			do
			for rn in 1000000
			do
				for gid in wheat #athal
				do
					#rm ${gid}.fastq
					#./Sherman -l 100 -CG ${xx} -CH ${yy} -e ${err} -n ${rn} --genome_folder genome/${gid}
					#mv simulated.fastq cg_${xx}_ch_${yy}_err_${err}_rn_${rn}_gid_${gid}.fastq

					echo "bismark"
					#../../src/src/run_bismark.sh ${gid} 2 EXTRA /mnt/INET2/epigenom/simulation/sherman/cg_${xx}_ch_${yy}_err_${err}_rn_${rn}_gid_${gid}.fastq

					#echo "bsmap"
					#../../src/src/run_bsmap.sh $gid EXTRA /mnt/INET2/epigenom/simulation/sherman/cg_${xx}_ch_${yy}_err_${err}_rn_${rn}_gid_${gid}.fastq

					#echo "segemehl"
					echo "../../src/src/run_segemehl.sh $gid 2 EXTRA /mnt/INET2/epigenom/simulation/sherman/cg_${xx}_ch_${yy}_err_${err}_rn_${rn}_gid_${gid}.fastq"
					#../../src/src/run_segemehl.sh $gid 2 EXTRA /mnt/INET2/epigenom/simulation/sherman/cg_${xx}_ch_${yy}_err_${err}_rn_${rn}_gid_${gid}.fastq

					#echo "bseeker3"
					../../src/src/run_BSseeker3.sh $gid 1 EXTRA /mnt/INET2/epigenom/simulation/sherman/cg_${xx}_ch_${yy}_err_${err}_rn_${rn}_gid_${gid}.fastq
				done
			done
		done
	done
done




