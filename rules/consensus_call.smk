rule getRef:
    input:
        tsv = "query_{samples}_{segment}.tsv",
        ref_list = "data/ref/{segment}.fa"
    output:
        cur_ref = temp("ref_{samples}_{segment}.fa")
    shell:
        r"""
        cat {input.tsv} | cut -f 5 | sort | uniq -c | sort -n | tail -n 1 | sed 's/ .* //' | grep -A 1 -f - {input.ref_list} > {output.cur_ref}
        """


rule bowtie2Build:
    input: 
        cur_ref = "ref_{samples}_{segment}.fa"
    params:
        basename = "ref_{samples}_{segment}"
    output:
        output1 = temp("ref_{samples}_{segment}.1.bt2"),
        output2 = temp("ref_{samples}_{segment}.2.bt2"),
        output3 = temp("ref_{samples}_{segment}.3.bt2"),
        output4 = temp("ref_{samples}_{segment}.4.bt2"),
        outputrev1 = temp("ref_{samples}_{segment}.rev.1.bt2"),
        outputrev2 = temp("ref_{samples}_{segment}.rev.2.bt2")
    conda:
        "../envs/mapping.yml"
    shell: 
        r"""
        bowtie2-build {input} {params.basename} --quiet 2> /dev/null
        """


rule getSam:
    input:
        reference = "ref_{samples}_{segment}.fa",
        fastq = "{samples}_paired.fq",
        idx1="ref_{samples}_{segment}.1.bt2",
        idx2="ref_{samples}_{segment}.2.bt2",
        idx3="ref_{samples}_{segment}.3.bt2",
        idx4="ref_{samples}_{segment}.4.bt2",
        idxrev1="ref_{samples}_{segment}.rev.1.bt2",
        idxrev2="ref_{samples}_{segment}.rev.2.bt2" 
    output:
        sam = temp("{samples}_{segment}.sam")
    conda:
        "../envs/mapping.yml"
    shell:
        r"""
        bowtie2 \
                -x "ref_{wildcards.samples}_{wildcards.segment}" \
                -U {input.fastq} \
                --very-sensitive \
                -S {output.sam} 
        """

rule getSortedBam:
    input:
        sam = "{samples}_{segment}.sam",
        reference = "ref_{samples}_{segment}.fa"
    output:
        sortedBam = "{samples}_{segment}_sorted.bam",
        fai = temp("ref_{samples}_{segment}.fa.fai")
    conda:
        "../envs/mapping.yml"
    threads:
        8
    shell:
        r"""
        samtools view -bT {input.reference} {input.sam} | samtools sort - -o {output.sortedBam}
        """

rule getBai:
    input:
        sortedBam = "{samples}_{segment}_sorted.bam"
    output:
        index = temp("{samples}_{segment}_sorted.bam.bai")
    conda:
        "../envs/mapping.yml"
    shell:
        r"""
        samtools index {input.sortedBam} {output.index}
        """

rule getCoverage:
    input:
        sortedBam = "{samples}_{segment}_sorted.bam",
        index = "{samples}_{segment}_sorted.bam.bai"
    output:
        cov = report("results/{samples}/reports/coverage/{samples}_{segment}.samcov.txt", category="{samples}", subcategory="Covarege")
    conda:
        "../envs/mapping.yml"
    shell:
        r"""
        samtools coverage {input.sortedBam} -m -o {output.cov}
        """

rule consensusCalling:
    input:
        reference = "ref_{samples}_{segment}.fa",
        fai = "ref_{samples}_{segment}.fa.fai",
        sortedBam = "{samples}_{segment}_sorted.bam"
    output:
        consensus = "results/{samples}/consensus/{samples}_{segment}_consensus.fa",
        q = temp("results/{samples}/consensus/{samples}_{segment}_consensus.qual.txt")
    conda:
        "../envs/mapping.yml"
    params:
        qual = config["QUALITY"],
        consf = config["CONSENSUS_FREQUENCY"],
        consd = config["CONSENSUS_DEPTH"]
    shell:
        r"""
        samtools mpileup \
                         -A \
                         -d 999999999999999 \
                         -B \
                         -Q {params.qual} \
                         --reference {input.reference} {input.sortedBam} | \
        ivar consensus \
                       -p {output.consensus} \
                       -q {params.qual} \
                       -t {params.consf} \
                       -m {params.consd}
        """
