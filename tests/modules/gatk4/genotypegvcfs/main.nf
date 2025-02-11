#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { GATK4_GENOTYPEGVCFS } from '../../../../modules/gatk4/genotypegvcfs/main.nf' addParams( options: [suffix:'.genotyped'] )
include { UNTAR               } from '../../../../modules/untar/main.nf'               addParams( options: [:] )

// Basic parameters with uncompressed VCF input
workflow test_gatk4_genotypegvcfs_vcf_input {
    
    input = [ [ id:'test' ], // meta map
              file(params.test_data['homo_sapiens']['illumina']['test_genome_vcf'], checkIfExists: true),
              file(params.test_data['homo_sapiens']['illumina']['test_genome_vcf_idx'], checkIfExists: true) ]

    fasta        = file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true)
    fastaIndex   = file(params.test_data['homo_sapiens']['genome']['genome_fasta_fai'], checkIfExists: true)
    fastaDict    = file(params.test_data['homo_sapiens']['genome']['genome_dict'], checkIfExists: true)

    GATK4_GENOTYPEGVCFS ( input, fasta, fastaIndex, fastaDict, [], [], [] )
}

// Basic parameters with compressed VCF input
workflow test_gatk4_genotypegvcfs_gz_input {
    
    input = [ [ id:'test' ], // meta map
              file(params.test_data['homo_sapiens']['illumina']['test_genome_vcf_gz'], checkIfExists: true),
              file(params.test_data['homo_sapiens']['illumina']['test_genome_vcf_gz_tbi'], checkIfExists: true) ]

    fasta        = file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true)
    fastaIndex   = file(params.test_data['homo_sapiens']['genome']['genome_fasta_fai'], checkIfExists: true)
    fastaDict    = file(params.test_data['homo_sapiens']['genome']['genome_dict'], checkIfExists: true)

    GATK4_GENOTYPEGVCFS ( input, fasta, fastaIndex, fastaDict, [], [], [] )
}

// Basic parameters + optional dbSNP
workflow test_gatk4_genotypegvcfs_gz_input_dbsnp {
    
    input = [ [ id:'test' ], // meta map
              file(params.test_data['homo_sapiens']['illumina']['test_genome_vcf_gz'], checkIfExists: true),
              file(params.test_data['homo_sapiens']['illumina']['test_genome_vcf_gz_tbi'], checkIfExists: true) ]

    fasta        = file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true)
    fastaIndex   = file(params.test_data['homo_sapiens']['genome']['genome_fasta_fai'], checkIfExists: true)
    fastaDict    = file(params.test_data['homo_sapiens']['genome']['genome_dict'], checkIfExists: true)

    dbsnp        = file(params.test_data['homo_sapiens']['genome']['dbsnp_146_hg38_vcf_gz'], checkIfExists: true)
    dbsnpIndex   = file(params.test_data['homo_sapiens']['genome']['dbsnp_146_hg38_vcf_gz_tbi'], checkIfExists: true)

    GATK4_GENOTYPEGVCFS ( input, fasta, fastaIndex, fastaDict, dbsnp, dbsnpIndex, [] )
}

// Basic parameters + optional intervals
workflow test_gatk4_genotypegvcfs_gz_input_intervals {
    
    input = [ [ id:'test' ], // meta map
              file(params.test_data['homo_sapiens']['illumina']['test_genome_vcf_gz'], checkIfExists: true),
              file(params.test_data['homo_sapiens']['illumina']['test_genome_vcf_gz_tbi'], checkIfExists: true) ]

    fasta        = file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true)
    fastaIndex   = file(params.test_data['homo_sapiens']['genome']['genome_fasta_fai'], checkIfExists: true)
    fastaDict    = file(params.test_data['homo_sapiens']['genome']['genome_dict'], checkIfExists: true)

    intervalsBed = file(params.test_data['homo_sapiens']['genome']['genome_bed'], checkIfExists: true)

    GATK4_GENOTYPEGVCFS ( input, fasta, fastaIndex, fastaDict, [], [], intervalsBed )
}

// Basic parameters + optional dbSNP + optional intervals
workflow test_gatk4_genotypegvcfs_gz_input_dbsnp_intervals {
    
    input = [ [ id:'test' ], // meta map
              file(params.test_data['homo_sapiens']['illumina']['test_genome_vcf_gz'], checkIfExists: true),
              file(params.test_data['homo_sapiens']['illumina']['test_genome_vcf_gz_tbi'], checkIfExists: true) ]

    fasta        = file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true)
    fastaIndex   = file(params.test_data['homo_sapiens']['genome']['genome_fasta_fai'], checkIfExists: true)
    fastaDict    = file(params.test_data['homo_sapiens']['genome']['genome_dict'], checkIfExists: true)

    dbsnp        = file(params.test_data['homo_sapiens']['genome']['dbsnp_146_hg38_vcf_gz'], checkIfExists: true)
    dbsnpIndex   = file(params.test_data['homo_sapiens']['genome']['dbsnp_146_hg38_vcf_gz_tbi'], checkIfExists: true)

    intervalsBed = file(params.test_data['homo_sapiens']['genome']['genome_bed'], checkIfExists: true)

    GATK4_GENOTYPEGVCFS ( input, fasta, fastaIndex, fastaDict, dbsnp, dbsnpIndex, intervalsBed )
}

// Basic parameters with GenomicsDB input
workflow test_gatk4_genotypegvcfs_gendb_input {

    fasta           = file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true)
    fastaIndex      = file(params.test_data['homo_sapiens']['genome']['genome_fasta_fai'], checkIfExists: true)
    fastaDict       = file(params.test_data['homo_sapiens']['genome']['genome_dict'], checkIfExists: true)

    test_genomicsdb = file(params.test_data['homo_sapiens']['illumina']['test_genomicsdb_tar_gz'], checkIfExists: true)

    UNTAR ( test_genomicsdb )

    Channel.of(file("mock_gvcf_index.txt")).set{mock_gvcf_index}
    Channel
        .of([ id:'test' ])
        .combine(UNTAR.out.untar)
        .combine(mock_gvcf_index)
        .set{ input }

    GATK4_GENOTYPEGVCFS ( input, fasta, fastaIndex, fastaDict, [], [], [] )
}

// Basic parameters with GenomicsDB + optional dbSNP
workflow test_gatk4_genotypegvcfs_gendb_input_dbsnp {
    
    fasta        = file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true)
    fastaIndex   = file(params.test_data['homo_sapiens']['genome']['genome_fasta_fai'], checkIfExists: true)
    fastaDict    = file(params.test_data['homo_sapiens']['genome']['genome_dict'], checkIfExists: true)

    dbsnp        = file(params.test_data['homo_sapiens']['genome']['dbsnp_146_hg38_vcf_gz'], checkIfExists: true)
    dbsnpIndex   = file(params.test_data['homo_sapiens']['genome']['dbsnp_146_hg38_vcf_gz_tbi'], checkIfExists: true)

    test_genomicsdb = file(params.test_data['homo_sapiens']['illumina']['test_genomicsdb_tar_gz'], checkIfExists: true)

    UNTAR ( test_genomicsdb )

    Channel.of(file("mock_gvcf_index.txt")).set{mock_gvcf_index}
    Channel
        .of([ id:'test' ])
        .combine(UNTAR.out.untar)
        .combine(mock_gvcf_index)
        .set{ input }

    GATK4_GENOTYPEGVCFS ( input, fasta, fastaIndex, fastaDict, dbsnp, dbsnpIndex, [] )
}

// Basic parameters with GenomicsDB + optional intervals
workflow test_gatk4_genotypegvcfs_gendb_input_intervals {
    
    fasta        = file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true)
    fastaIndex   = file(params.test_data['homo_sapiens']['genome']['genome_fasta_fai'], checkIfExists: true)
    fastaDict    = file(params.test_data['homo_sapiens']['genome']['genome_dict'], checkIfExists: true)

    intervalsBed = file(params.test_data['homo_sapiens']['genome']['genome_bed'], checkIfExists: true)

    test_genomicsdb = file(params.test_data['homo_sapiens']['illumina']['test_genomicsdb_tar_gz'], checkIfExists: true)

    UNTAR ( test_genomicsdb )

    Channel.of(file("mock_gvcf_index.txt")).set{mock_gvcf_index}
    Channel
        .of([ id:'test' ])
        .combine(UNTAR.out.untar)
        .combine(mock_gvcf_index)
        .set{ input }

    GATK4_GENOTYPEGVCFS ( input, fasta, fastaIndex, fastaDict, [], [], intervalsBed )
}

// Basic parameters with GenomicsDB + optional dbSNP + optional intervals
workflow test_gatk4_genotypegvcfs_gendb_input_dbsnp_intervals {
    
    fasta        = file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true)
    fastaIndex   = file(params.test_data['homo_sapiens']['genome']['genome_fasta_fai'], checkIfExists: true)
    fastaDict    = file(params.test_data['homo_sapiens']['genome']['genome_dict'], checkIfExists: true)

    dbsnp        = file(params.test_data['homo_sapiens']['genome']['dbsnp_146_hg38_vcf_gz'], checkIfExists: true)
    dbsnpIndex   = file(params.test_data['homo_sapiens']['genome']['dbsnp_146_hg38_vcf_gz_tbi'], checkIfExists: true)

    intervalsBed = file(params.test_data['homo_sapiens']['genome']['genome_bed'], checkIfExists: true)

    test_genomicsdb = file(params.test_data['homo_sapiens']['illumina']['test_genomicsdb_tar_gz'], checkIfExists: true)

    UNTAR ( test_genomicsdb )

    Channel.of(file("mock_gvcf_index.txt")).set{mock_gvcf_index}
    Channel
        .of([ id:'test' ])
        .combine(UNTAR.out.untar)
        .combine(mock_gvcf_index)
        .set{ input }

    GATK4_GENOTYPEGVCFS ( input, fasta, fastaIndex, fastaDict, dbsnp, dbsnpIndex, intervalsBed )
}
