#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { BAMCMP } from '../../../modules/bamcmp/main.nf' 

workflow test_bamcmp {

input = [[ id:'test' ],
    file('/mnt/panfs1/scratch/wsspaces/kmurat-dsl2-0/dsl2_testdata/test_aligned.bam', checkIfExists: true),
    file('/mnt/panfs1/scratch/wsspaces/kmurat-dsl2-0/dsl2_testdata/test_contamination.bam', checkIfExists: true)]


    BAMCMP ( input )
}
