#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { NCM } from '../../../modules/ncm/main.nf' addParams( options: [:] )

workflow test_ncm {
    
 input = [[ id:'test' ],
    file('/mnt/panfs1/scratch/wsspaces/kmurat-nfcore-0/DSL2/GIT/Input.vcf', checkIfExists: true)]
 snp = file('/lmod/apps/ngscheckmate/1.0.0/SNP/SNP_GRCh38_hg38_woChr.bed', checkIfExists: true)

    NCM ( input, snp )
}
