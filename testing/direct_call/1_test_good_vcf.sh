# Test this with flags like -N 22 and -e

#DATD="/storage1/fs1/dinglab/Active/Projects/ysong/Projects/PECGS/Analysis/ATAC_Tindaisy_Somaticwrapper_comparision/atac_wxs_bam_v2/runs/CPT4427DU-TWHG-CPT4427DU-T1Y1D1_1.T"
DATD="/data"
VCF="$DATD/cromwell-workdir/cromwell-executions/pecgs_TN_wxs_bam.cwl/b8745052-e741-4e8f-abe9-ee8bbb118790/call-run_tindaisy/tindaisy2.6.2_vep102_vafrescue.cwl/9a908989-422e-4872-9e1b-0747b497be97/call-snp_indel_proximity_filter/execution/output/ProximityFiltered.vcf"

#TD_AUS_VCF_ALL="/storage1/fs1/m.wyczalkowski/Active/ProjectStorage/Analysis/20230427.SW_vs_TD/dat/call-snp_indel_proximity_filter/execution/output/ProximityFiltered.vcf"

CMD="bash ../../src/VEP_QC.sh $@ $VCF "

>&2 echo Running: $CMD
eval $CMD

>&2 echo Return value: $?

