rule primarySegmentSearch:
    input:
        db_done = "data/ref/{segment}.makeblastdb.done",
        sequences = "{samples}_part.fa",
    output:
        tsv = temp("query_{samples}_{segment}.tsv")
    conda:
        "../envs/blast.yml"
    threads:
        8
    shell:
         r"""
         blastn \
		-query {input.sequences} \
		-db data/ref/{wildcards.segment}.fa \
		-evalue 0.001 \
		-max_target_seqs 1 \
		-qcov_hsp_perc 50 \
		-outfmt "6 qseqid pident length evalue stitle" \
		-out {output.tsv} 2>/dev/null
         """


rule SegmentSearch:
    input:
        db_done = "data/ref_compl/{hana}.makeblastdb.done",
        sequences = "{samples}_{hana}_unmapped.fa"
    output:
        tsv = temp("unmapped_{samples}_{hana}.tsv")

    conda:
        "../envs/blast.yml"
    threads:
        8
    shell:
         r"""
         blastn \
                -query {input.sequences} \
                -db data/ref/{wildcards.hana}.fa \
                -evalue 0.001 \
                -max_target_seqs 1 \
                -qcov_hsp_perc 70 \
                -outfmt "6 qseqid pident length evalue stitle" \
                -out {output.tsv} 2>/dev/null
         """


rule secondarySegmentSearch:
    input:
        db_done= "data/ref_compl/{segment}.makeblastdb.done",
        sequences = "results/{samples}/consensus/{samples}_{segment}_consensus.fa"
    output:
        res = temp("{samples}_{segment}_segment.tsv")
    conda:
        "../envs/blast.yml"
    params:
        tree = config["TREE_SIZE"]
    threads:
        8
    shell:
        r"""
        blastn \
                -query {input.sequences} \
                -db data/ref_compl/{wildcards.segment}.fa \
                -evalue 0.001 \
                -max_target_seqs {params.tree} \
                -qcov_hsp_perc 50 \
                -outfmt "6 qseqid pident length evalue stitle" \
                -out {output.res} 2>/dev/null
        """


rule iavpSegmentSearch:
    input:
        db_done= "data/ref_compl/{segment}.makeblastdb.done",
        sequences = "genome/{samples}_{segment}.fa"
    output:
        res = temp("{samples}_{segment}_segment.tsv")
    conda:
        "../envs/blast.yml"
    params:
        tree = config["TREE_SIZE"]
    threads:
        8
    shell:
        r"""
        blastn \
                -query {input.sequences} \
                -db data/ref_compl/{wildcards.segment}.fa \
                -evalue 0.001 \
                -max_target_seqs {params.tree} \
                -qcov_hsp_perc 60 \
                -outfmt "6 qseqid pident length evalue stitle" \
                -out {output.res} 2>/dev/null
        """

