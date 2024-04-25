rule getFa:
    input:
        r1_trimmed = "{samples}_1.paired.fq",
        r2_trimmed = "{samples}_2.paired.fq"
    output:
        merge = temp("{samples}_paired.fq"),
        sequences = temp("um_{samples}_part.fa")
    params:
        part = config["PART"]*4
    conda:
        "../envs/qc.yml"
    shell:
        r"""
        cat {input.r1_trimmed} {input.r2_trimmed} > {output.merge}
        head -n {params.part} {output.merge} | seqtk seq -a > {output.sequences}
        """

rule getBLASTN:
    input:
        tsv = "um_{samples}_{hana}.tsv"
    output:
        cur_ref = "results/{samples}/BLASTN_{samples}_{hana}.tsv",
        name = "results/{samples}/BLASTN_most_represented_viruses_{samples}_{hana}.txt"
    params:
        header = "'read_ID\tidentity\tlength_of_alignement\tE-value\treference_ID'"
    shell:
        r"""
        echo {params.header} | cat - {input.tsv} > {output.cur_ref}
        cat {output.cur_ref} | cut -f 5 | sort | uniq -c | sort -n > {output.name}
        """

