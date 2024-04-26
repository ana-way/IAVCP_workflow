rule iavpSegmentSearch:
    input:
        db_done= "data/ref_compl/{segment}.makeblastdb.done",
        sequences = "SAMPLE_{samples}_{segment}.fa"
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
