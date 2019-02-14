PATH=$PATH:/mnt/INET2/apps/sratoolkit.2.9.2-ubuntu64/bin/

OUTDIR=$(pwd)

#
#	Extraction of the SRA files from NCBI
#
extract_from_ncbi()
{
	for ID in SRR5079790 SRR6796748 SRR7265433 SRR3880297 SRR4295494 SRR4295471
	do
		echo $ID
		ID_SHORT=$(echo $ID | cut -c1-6)
		wget ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByRun/sra/SRR/${ID_SHORT}/${ID}/${ID}.sra
	done
	for ID in DRR029416
	do
                echo $ID
                ID_SHORT=$(echo $ID | cut -c1-6)
                wget ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByRun/sra/DRR/${ID_SHORT}/${ID}/${ID}.sra
	done
	for ID in ERR1141918
	do
                echo $ID
                ID_SHORT=$(echo $ID | cut -c1-6)
                wget ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByRun/sra/ERR/${ID_SHORT}/${ID}/${ID}.sra
	done
}

#extract_from_ncbi

extract_fastq_from_sra()
{
	# --------------------------------------------------------
	# Glycine max
	ID=SRR5079790.sra
	fastq-dump --split-3 $ID -O $OUTDIR

	ID=SRR6796748.sra
	fastq-dump --split-3 $ID -O $OUTDIR

	# --------------------------------------------------------
	# Oryza sativa
	ID=SRR7265433.sra
	fastq-dump --split-3 $ID -O $OUTDIR

	ID=DRR029416.sra
	fastq-dump --split-3 $ID -O $OUTDIR
	# --------------------------------------------------------
	# Arabidopsis lyrata
	ID=SRR3880297.sra
	fastq-dump --split-3 $ID -O $OUTDIR
	# --------------------------------------------------------
	# Arabidopsis thaliana
	ID=SRR4295494.sra
	fastq-dump --split-3 $ID -O $OUTDIR

	ID=SRR4295471.sra
	fastq-dump --split-3 $ID -O $OUTDIR
	# --------------------------------------------------------
	# Triticum aestivum
	ID=ERR1141918.sra
	fastq-dump --split-3 $ID -O $OUTDIR
	# --------------------------------------------------------
}
extract_fastq_from_sra


