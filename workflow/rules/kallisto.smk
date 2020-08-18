# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jashmore@ed.ac.uk
# License: MIT

def kallisto_technology(wildcards):
    arg = ["10xv1", "10xv2", "10xv3", "CELSeq", "CELSeq2", "DropSeq", "inDropsv1", "inDropsv2", "inDropsv3", "SCRBSeq", "SureCell"]

rule kallisto_index:
    input:
        fas = "results/busparse/{genome}/cDNA_introns.fa"
    output:
        idx = "results/kallisto/index/{genome}.idx"
    message:
        "[kallisto] Build kallisto index"
    conda:
        "../rules/kallisto.yaml"
    shell:
        "kallisto index -i {output.idx} {input.fas}"

rule kallisto_bus:
    input:
        idx = "results/kallisto/index/GRCm38.p6.idx",
        fq1 = lambda wildcards: units.loc[units['sample'] == wildcards.sample, "fq1"],
        fq2 = lambda wildcards: units.loc[units['sample'] == wildcards.sample, "fq2"]
    output:
        ext = ["results/kallisto/{sample}/matrix.ec",
               "results/kallisto/{sample}/output.bus",
               "results/kallisto/{sample}/run_info.json",
               "results/kallisto/{sample}/transcripts.txt"]
    params:
        out = "results/kallisto/bus/{sample}",
        fqz = lambda wildcards, input: [j for i in zip(input.fq1, input.fq2) for j in i]
    threads:
        16
    message:
        "[kallisto] Generate BUS file for single-cell data"
    conda:
        "../rules/kallisto.yaml"
    shell:
        "kallisto bus -i {input.idx} -o {params.out} -x 10xv3 -t {threads} {params.fqz}"