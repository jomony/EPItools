PATH=$PATH:/mnt/INET2/apps/sratoolkit.2.9.2-ubuntu64/bin/

# Glycine max
ID=SRR5079790
fastq-dump --split-3 $ID
ID=SRR6796748
fastq-dump --split-3 $ID

# Oryza sativa
ID=SRX4169528
fastq-dump --split-3 $ID
ID=DRR029416
fastq-dump --split-3 $ID

# Arabidopsis lyrata
ID=SRR3880297
fastq-dump --split-3 $ID

# Arabidopsis thaliana
ID=SRR4295494
fastq-dump --split-3 $ID
ID=SRR4295471
fastq-dump --split-3 $ID

# Triticum aestivum
ID=ERR1141918
fastq-dump --split-3 $ID



