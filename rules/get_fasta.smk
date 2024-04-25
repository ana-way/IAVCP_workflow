rule getFasta:
    input:
        r1_trimmed = "{samples}_1.paired.fq",
        r2_trimmed = "{samples}_2.paired.fq"
    output:
        merge = temp("{samples}_paired.fq"),
        sequences = temp("{samples}_part.fa")
    params:
        part = config["PART"]*4
    conda:
        "../envs/qc.yml"
    shell:
        r"""
        cat {input.r1_trimmed} {input.r2_trimmed} > {output.merge}
        head -n {params.part} {output.merge} | seqtk seq -a > {output.sequences}
        """
