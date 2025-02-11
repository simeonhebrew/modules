#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { COOLER_MERGE } from '../../../../modules/cooler/merge/main.nf' addParams( options: [publish_files:[:]] )
include { COOLER_DUMP } from '../../../../modules/cooler/dump/main.nf' addParams( options: [:] )

workflow test_cooler_merge {

    input = [ [ id:'test' ], // meta map
              [ file(params.test_data['generic']['cooler']['test_merge_cool'], checkIfExists: true),
                file(params.test_data['generic']['cooler']['test_merge_cool_cp2'], checkIfExists: true)] 
            ]

    COOLER_MERGE ( input ).cool | COOLER_DUMP
}
