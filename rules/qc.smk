rule fastp:
    input:
        r1 = lambda wc: sample_reads[sample_reads["sample_id"] == wc.samples]["read1"].item(),
        r2 = lambda wc: sample_reads[sample_reads["sample_id"] == wc.samples]["read2"].item(),
        adapters = "data/adapters/adapters.fa"
    output:
        r1_trimmed = temp("{samples}_1.paired.fq"),
        r2_trimmed = temp("{samples}_2.paired.fq"),
        report_html = temp("{samples}_qc.html"),
        report_json = temp("{samples}_qc.json")
    conda:
        "../envs/qc.yml"
    params:
        qual = config["QUALITY"]
    log:
        "logs/fastp/{samples}.log"
    shell:
        r"""
        fastp \
              -i {input.r1} \
              -o {output.r1_trimmed} \
              -I {input.r2} \
              -O {output.r2_trimmed} \
              -l 20 \
              --adapter_fasta {input.adapters} \
              --cut_front \
              --cut_tail \
              --cut_front_window_size 4 \
              --cut_front_mean_quality {params.qual} \
              -h {output.report_html} \
              -j {output.report_json} \
              2> {log}
        """

rule get_reports:
    input:
        report_html = "{samples}_qc.html"
    output:
        finaldir = report("results/{samples}/reports/fastp/{samples}_qc.html", category="{samples}", subcategory="Quality control")
    shell:
        r"""
        mv {input.report_html} {output.finaldir}
        """
