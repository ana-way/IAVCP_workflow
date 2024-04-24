import pandas as pd

configfile:"config/config.yaml"

path = ["data/ref","data/ref_compl"]
segment=["1.PB2","2.PB1","3.PA","4.HA","5.NP","6.NA","7.M1M2","8.NS1"]
sample_reads = pd.read_csv("config/sample_reads.csv")
samples = sample_reads["sample_id"].tolist()
hana = ["4.HA","6.NA"]

rule all:
    input:
        expand("results/{samples}/reports/fastp/{samples}_qc.html", samples=samples),
        expand("results/{samples}/reports/coverage/{samples}_{segment}.samcov.txt", samples=samples, segment=segment),
        expand("results/{samples}/consensus/{samples}_{segment}_consensus.fa", samples=samples, segment=segment),
        expand("{samples}_nearest_to_{segment}.fa", samples=samples, segment=segment),
        expand("results/{samples}/trees/{samples}_{segment}.midpoint-rooted.nwk", samples=samples, segment=segment),
        expand("results/{samples}/trees/{samples}_{segment}.html",samples=samples, segment=segment)


include: "rules/blastdb.smk"
include: "rules/qc.smk"
include: "rules/get_fasta.smk"
include: "rules/blast_query.smk"
include: "rules/consensus_call.smk"
include: "rules/get_nearest.smk"
include: "rules/phylo.smk"
