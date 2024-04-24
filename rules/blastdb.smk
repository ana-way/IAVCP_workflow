path = ["data/ref","data/ref_compl"]

rule createBlastdb:
    input:
        reference = "{path}/{segment}.fa"
    output:
        done = touch("{path}/{segment}.makeblastdb.done")
    conda:
        "../envs/blast.yml"
    shell:
        r"""
        makeblastdb -in {input.reference} -dbtype nucl
        """

