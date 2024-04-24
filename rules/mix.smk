rule getUnmappedBam:
    input:
        bam = "{samples}_{hana}_sorted.bam"
    output:
        unmapbam = temp("{samples}_{hana}_unmapped.bam")
    conda:
        "../envs/mapping.yml"
    threads:
        8
    shell:
        r"""
        samtools view -b -f 4 {input.bam} > {output.unmapbam}
        """

rule UMfa:
    input:
        bam = "{samples}_{hana}_unmapped.bam"
    output:
        umfq = temp("um_{samples}_{hana}.fq"),
        unmapfa = temp("um_{samples}_{hana}_part.fa")
    conda:
        "../envs/mapping.yml"
    params:
        part = config["PART"]
    threads:
        8
    shell:
        r"""
        samtools bam2fq {input} > {output.umfq}
        head -n {params.part} {output.umfq} | seqtk seq -a > {output.unmapfa}
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

