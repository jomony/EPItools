# EPItools
Comparison of the performance of epigenetic (bisulfite-) data mapping and analysis tools.

Evaluation of four distinct epigenomic mapping tools - including the main scripts to search for coherence and over-laps of mapped reads from each tool (Omony, Nussbaumer and Gutzat, in Review).

- **Bismark** (Krueger and Andrews, 2011, http://www.ncbi.nlm.nih.gov/pubmed/21493656).
- **BSMap** (Xi and Li, 2009, https://www.ncbi.nlm.nih.gov/pubmed/19635165).
- **BS-Seeker3** (Huang et al., 2018, https://www.ncbi.nlm.nih.gov/pubmed/29614954).
- **segemehl** (Hoffmann et al., 2009, https://www.ncbi.nlm.nih.gov/pubmed/19750212).

The benchmark tests included both dicots (<em>Arabidopsis thaliana</em>, *Arabidopsis lyrata* and *Glycine max*) and monocots (*Triticum aestivum* and *Oryza sativa*).

The github repository contains all single scripts and also the scripts used to run
the four tools together for each of the five genomes.

We also added scripts for simulating epigenomic reads and also for running the above four mapping tools.
The tool by **Sherman** (https://github.com/FelixKrueger/Sherman) was used for simulating the reads.
The simulation criteria and assessment of the performance of the tools is described in our study (Omony et al. 2019, https://www.ncbi.nlm.nih.gov/pubmed/31220217).

