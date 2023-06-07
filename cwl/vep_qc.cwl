class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: vep_qc
baseCommand:
  - /bin/bash
  - /opt/VEP_QC/src/VEP_QC.sh
inputs:
  - id: num_expected
    type: int?
    inputBinding:
      position: 1
      prefix: '-N'
    label: Number expected
    doc: >-
      number of expected chrom with 1+ dbSnP annotation. If not provided, no
      test is performed
  - id: exit_on_mismatch
    type: boolean?
    inputBinding:
      position: 2
      prefix: '-e'
    label: Exit on mismatch
    doc: Exit with an error if actual count different from NUM_EXPECTED
  - id: VCF
    type: File
    inputBinding:
      position: 10
outputs:
  - id: warning_flag
    doc: >-
      File written if VCF fails QC check, with an unexpected number of
      chromosomes with any dbSnP annotation
    label: Warning flag
    type: File?
    outputBinding:
      glob: results/unexpected_id_count.flag
label: VEP_QC
arguments:
  - position: 0
    prefix: '-o'
    valueFrom: results
requirements:
  - class: DockerRequirement
    dockerPull: 'mwyczalkowski/vep_qc:20230607'
  - class: ResourceRequirement
    ramMin: 2000

