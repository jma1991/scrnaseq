# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jashmore@ed.ac.uk
# License: MIT

rule cutadapt:
    input:
        fq1 = lambda wildcards: pep.subsample_table.loc[pep.subsample_table['sample_name'] == wildcards.sample, "fq1"],
        fq2 = lambda wildcards: pep.subsample_table.loc[pep.subsample_table['sample_name'] == wildcards.sample, "fq2"],
    output:
        fq1 = "results/cutadapt/{sample_name}_{subsample_name}_1.fastq.gz",
        fq2 = "results/cutadapt/{sample_name}_{subsample_name}_2.fastq.gz"
    message:
        "[cutadapt] Trim TSO and poly-A sequence"
    threads:
        "16"
    conda:
        "../envs/cutadapt.yaml"
    shell:
        "cutadapt -j {threads} -m 33 -e 0.005 -O 7 -G AAGCAGTGGTATCAACGCAGAGTACATGGG -A 'A{100}' -o {output.fq1} -p {output.fq2} {input.fq1} {input.fq2}"