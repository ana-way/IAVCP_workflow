# Pipeline IAVCP 1.0

The pipeline is designed with the purpose of analyzing high-throughput sequencing data pertaining to the influenza A virus. Its objectives encompass the extraction of a consensus genome directly from paired raw reads. Additionally, the pipeline enables the identification of potential reassortment events through analysis of the topological structure of phylogenetic trees.
## Content:
- [Installation](#Installation)
- [Dependencies](#Dependencies)
- [Input format](#Input)
- [Parameters](#Parameters)
- [Usage](#Usage)
- [Output format](#Output)
- [Reports](#Reports)
- [Advanced](#Advanced)


# Installation
To install the pipeline, clone this repository using the command below:

``` git clone https://github.com/ana-way/IAVCP_workflow ```

# Dependencies

To ensure proper functionality, it is essential to have a package manager like [Conda](https://conda.io/projects/conda/en/latest/user-guide/install/index.ht) or [Mamba](https://mamba.readthedocs.io/en/latest/installation/mamba-installation.html) installed on your device or server.

Afterward, we recommend utilizing a full installation of [Snakemake](https://snakemake.readthedocs.io/en/stable/getting_started/installation.html) within an isolated environment

The remaining dependent packages will be installed automatically.

# Input

In the current version, the pipeline only works with paired reads. Samples should be specified in the file named *sample_reads.csv* located in the *config* directory.

The first column specifies the prefix of the samples, which will be included in the output names. The next two columns indicate the relative path with the names of the reads. Various formats of reads are accepted as input, including FASTQ, FASTQ.GZ, and FQ.GZ.

```
sample_id,read1,read2
Sample1,/path/to/Sample1_R1.fastq,/path/to/Sample1_R2.fastq
Sample2,/path/to/Sample2_R1.fastq.gz,/path/to/Sample2_R2.fastq.gz
Sample3,/path/to/Sample3_R1.fq.gz,/path/to/Sample3_R2.fq.gz
```

# Parameters

Launch parameters are set in the *config.yaml* file located in the *config* directory:

QUALITY: Quality cutoff for removing low-quality bases.

CONSENSUS_DEPTH: Minimum depth to call consensus.

CONSENSUS_FREQUENCY: Minimum frequency threshold (0 - 1) to call consensus.

PART: Portion of the reads to compare with database. 

TREE_SIZE: Number of viral sequences, which are most similar to all segment sequences of the virus of interest, are used for constructing the tree.

Default values:
```
  QUALITY: 20
  CONSENSUS_DEPTH: 10
  CONSENSUS_FREQUENCY: 0 
  PART: 100000 
  TREE_SIZE: 10
```
If the default settings aren't suitable for your task, just modify the relevant values in the *config.yaml* file found in the config directory.

# Usage

The pipeline can only be used to call consensus (IAVC) using the following command:

```
snakemake --cores 8 --use-conda -s IAVC
```
or for phylogenetic analysis (IAVP):

```
snakemake --cores 8 --use-conda -s IAVP
```

To initiate the full version of the pipeline with phylogenetic tree reconstruction, use:
```
snakemake --cores 8 --use-conda
```
NOTE: Adjust the number of cores based on the specifications of your machine.

# Output

Upon completion of the pipeline, all results will appear in the *results* folder. The results for each sample include consensus sequences of segments in FASTA format, phylogenetic trees in NWK and HTML formats, and quality control reports and obtained coverage.

## Reports

To generate a comprehensive report of the pipeline's operation and to view phylogenetic trees in HTML format, quality control reports, and obtained coverage, you can use the following command:
```
snakemake --report name.html
```
# Advanced

Sequences of the influenza A virus available in the current version were obtained from the GenBank database in January 2023. You can update the data yourself, as long as you maintain the same names for the FASTA files for each segment. It's also important for proper functioning to ensure that the folder *data/ref_compl* contains virus sequences only with fully sequenced segments.

Additionally, if your experiment involves unique adapter sequences, you can add them to *data/adapters.fa* for trimming purposes.
