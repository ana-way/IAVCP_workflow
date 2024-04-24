rule multipleAlignment:
    input:
        nearest_fasta = "{samples}_nearest_to_{segment}.fa"
    output:
        aligned = temp("{samples}_aligned_nearest_to_{segment}.fasta")
    conda:
        "../envs/phylo.yml"
    threads:
        4
    shell:
        r"""
        mafft --quiet {input.nearest_fasta} > {output.aligned}
        """

rule treeReconstructio:
     input:
        aligned = "{samples}_aligned_nearest_to_{segment}.fasta"
     output:
        tree = temp("{samples}_aligned_nearest_to_{segment}.fasta.treefile"),
        Out1 = temp("{samples}_aligned_nearest_to_{segment}.fasta.bionj"),
        Out2 = temp("{samples}_aligned_nearest_to_{segment}.fasta.contree"),
        Out3 = temp("{samples}_aligned_nearest_to_{segment}.fasta.iqtree"),
        Out4 = temp("{samples}_aligned_nearest_to_{segment}.fasta.log"),
        Out5 = temp("{samples}_aligned_nearest_to_{segment}.fasta.mldist"),
        Out6 = temp("{samples}_aligned_nearest_to_{segment}.fasta.splits.nex"),
        Out8 = temp("{samples}_aligned_nearest_to_{segment}.fasta.ckp.gz")
     conda:
        "../envs/phylo.yml"
     threads:
        8
     shell:
        r"""
        iqtree -s {input.aligned} -B 1000 -m GTR+F+I -quiet
        python3 scripts/cleaner.py
        """


rule treeRooting:
     input:
        tree = "{samples}_aligned_nearest_to_{segment}.fasta.treefile"
     output:
        rtree = "results/{samples}/trees/{samples}_{segment}.midpoint-rooted.nwk"
     conda:
        "../envs/phylo.yml"
     threads:
        8
     shell:
        r"""
        gotree reroot midpoint -i {input.tree} -o "{output.rtree}"
        """

rule treeVisualizing:
     input:
        rtree = "results/{samples}/trees/{samples}_{segment}.midpoint-rooted.nwk"
     output:
        html = report("results/{samples}/trees/{samples}_{segment}.html", category="{samples}", subcategory="Phylogenetic")
     shell:
        r"""
        python3 scripts/phy2html.py {input.rtree} {output.html}
        """
