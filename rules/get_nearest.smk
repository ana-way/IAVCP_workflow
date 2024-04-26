rule exstractIndex:
    input:
        fls = expand("{samples}_{segment}_segment.tsv",segment=segment, samples=samples)
    output:
        names = temp("{samples}_index.txt")
    shell:
        r"""
        cut {input.fls} -f 5 >> {output.names}
        """

rule nearestFasta:
    input:
        indexes = "{samples}_index.txt",
        reference = "data/ref_compl/{segment}.fa",
        consensus = "results/{samples}/consensus/{samples}_{segment}_consensus.fa"
    output:
        near = temp("{samples}_nearest_to_{segment}.fa")
    shell:
        r"""
        python3 scripts/nearest_segments.py {input.reference} {input.indexes} {input.consensus} {output.near}
        """

rule mfa2fa:
    input:
        mfa = "genome/{samples}.fa"
    output:
        fa = temp("SAMPLE_{samples}_{segment}.fa")
    shell:
        r"""
        python3 scripts/mfa2fa.py {input.mfa}
        """

rule nearestFastaIAVP:
    input:
        indexes = "{samples}_index.txt",
        reference = "data/ref_compl/{segment}.fa",
        consensus = "SAMPLE_{samples}_{segment}.fa"
    output:
        near = temp("{samples}_nearest_to_{segment}.fa")
    shell:
        r"""
        python3 scripts/nearest_segments.py {input.reference} {input.indexes} {input.consensus} {output.near}
        """
