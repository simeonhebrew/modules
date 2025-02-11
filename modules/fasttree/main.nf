// Import generic module functions
include { initOptions; saveFiles; getSoftwareName; getProcessName } from './functions'

params.options = [:]
options        = initOptions(params.options)

process FASTTREE {
    label 'process_medium'
    publishDir "${params.outdir}",
        mode: params.publish_dir_mode,
        saveAs: { filename -> saveFiles(filename:filename, options:params.options, publish_dir:getSoftwareName(task.process), meta:[:], publish_by_meta:[]) }

    conda (params.enable_conda ? "bioconda::fasttree=2.1.10" : null)
    if (workflow.containerEngine == 'singularity' && !params.singularity_pull_docker_container) {
        container "https://depot.galaxyproject.org/singularity/fasttree:2.1.10--h516909a_4"
    } else {
        container "quay.io/biocontainers/fasttree:2.1.10--h516909a_4"
    }

    input:
    path alignment

    output:
    path "*.tre",         emit: phylogeny
    path "versions.yml" , emit: versions

    script:
    """
    fasttree \\
        $options.args \\
        -log fasttree_phylogeny.tre.log \\
        -nt $alignment \\
        > fasttree_phylogeny.tre

    cat <<-END_VERSIONS > versions.yml
    ${getProcessName(task.process)}:
        ${getSoftwareName(task.process)}: \$(fasttree -help 2>&1 | head -1  | sed 's/^FastTree \\([0-9\\.]*\\) .*\$/\\1/')
    END_VERSIONS
    """
}
