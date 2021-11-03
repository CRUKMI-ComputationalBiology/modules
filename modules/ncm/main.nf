// Import generic module functions
include { initOptions; saveFiles; getSoftwareName; getProcessName } from './functions'

params.options = [:]
options        = initOptions(params.options)

process NCM {
    tag '$bam'
    label 'process_low'
    publishDir "${params.outdir}",
        mode: params.publish_dir_mode,
        saveAs: { filename -> saveFiles(filename:filename, options:params.options, publish_dir:getSoftwareName(task.process), meta:[:], publish_by_meta:[]) }

    if (workflow.containerEngine == 'singularity' && !params.singularity_pull_docker_container) {
        container "docker://goalconsortium/profiling_qc:1.0.9"
    } else {
        container "docker://goalconsortium/profiling_qc:1.0.9"
     }

    input:
    tuple val(meta), path(vcf)
    path  snp

    output:
    tuple val(meta), path("*") 
    path "versions.yml"          , emit: versions

    script:

    """
    
	grep -v "alt" ${snp} > SNP.bed 
    ls -d "\${PWD}"/*.vcf > vcfList.txt 

	python /usr/local/bin/ncm.py -V -l vcfList.txt -bed SNP.bed -O .

    cat <<-END_VERSIONS > versions.yml
    ${getProcessName(task.process)}:
        ${getSoftwareName(task.process)}: \$( samtools --version 2>&1 | sed 's/^.*samtools //; s/Using.*\$//' )
    END_VERSIONS
    """
}
