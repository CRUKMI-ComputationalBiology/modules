// Import generic module functions
include { initOptions; saveFiles; getSoftwareName; getProcessName } from './functions'

params.options = [:]
options        = initOptions(params.options)

process BAMCMP {
    tag "$meta.id"
    label 'process_low'
    publishDir "${params.outdir}"


    conda (params.enable_conda ? "bioconda::bamcmp=2.2" : null)
    if (workflow.containerEngine == 'singularity' && !params.singularity_pull_docker_container) {
        container "docker://crukmi/bamcmp:2.0.0"
    } else {
        container "quay.io/biocontainers/bamcmp"
    }

   input:
    tuple val(meta), path(sample), path(contaminant)

    output:
    tuple val(meta), path("*.bam"), emit: bam
    path "versions.yml"           , emit: versions

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    
    
    """
   bamcmp \\
   -s "as" \\
   -1 $sample \\
   -2 $contaminant \\
   -A ${prefix}.bam \\
   
    cat <<-END_VERSIONS > versions.yml
    ${getProcessName(task.process)}:
        ${getSoftwareName(task.process)}: \$( samtools --version 2>&1 | sed 's/^.*samtools //; s/Using.*\$//' )
    END_VERSIONS
    """
    
    // bamcmp takes two bam files aligned to different genomes (containing the same reads) and splits the reads by which genome they align to "better". We strongly suggest using the "as" mode, not the "mapq" mode. If both bam files contain exactly the same reads, only need the -A output bam file, but if they have been filtered previously then also need to join the -a bam with the -A bam file.
    
}
