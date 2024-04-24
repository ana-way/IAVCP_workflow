rule getUnmappedReads:
    input:
        bam = "{samples}_{hana}_sorted.bam"
    output:
        unmap = temp("{samples}_{hana}_unmapped.fa")
    conda:
        "../envs/mapping.yml"
    threads:
        8
    shell:
        r"""
        samtools view -b -f 4 {input.bam} | samtools bam2fq - | seqtk seq -a > {output.unmap}
        """


rule getUnmappedType:
    input:
        tsv = "unmapped_{samples}_{hana}.tsv"
    output:
        rep = temp("{samples}_{hana}.txt")
    threads:
        8
    shell:
        r"""
        python3 scripts/report_mix.py {input.tsv} {output.rep}
        """

rule reassortment:
    input:
        ha = "{samples}_4.HA.txt",
        na = "{samples}_6.NA.txt"
    output:
        rep = report("results/{samples}/{samples}_mix.txt",category="{samples}", subcategory="Mix")
    threads:
        8
    shell:
        r"""
        python3 scripts/reassort.py {input.ha} {input.na} {output.rep}
        """
