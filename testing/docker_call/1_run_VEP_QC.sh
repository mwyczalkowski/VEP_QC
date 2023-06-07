source ../../docker/docker_image.sh

# /data maps to DATAD
DATAD="/storage1/fs1/dinglab/Active/Projects/ysong/Projects/PECGS/Analysis/ATAC_Tindaisy_Somaticwrapper_comparision/atac_wxs_bam_v2/runs/CPT4427DU-TWHG-CPT4427DU-T1Y1D1_1.T"

RESULTSD="/home/m.wyczalkowski/Projects/Adhoc/20230427.SW_vs_TD/D_VEP_QC/testing/docker_call/results"
mkdir -p $RESULTSD

VCF="/data/cromwell-workdir/cromwell-executions/pecgs_TN_wxs_bam.cwl/b8745052-e741-4e8f-abe9-ee8bbb118790/call-run_tindaisy/tindaisy2.6.2_vep102_vafrescue.cwl/9a908989-422e-4872-9e1b-0747b497be97/call-snp_indel_proximity_filter/execution/output/ProximityFiltered.vcf"

# This is what we want to run in docker
#CMD_INNER="/bin/bash /opt/VEP_Filter/src/run_af_filter.sh $@ -o $OUT $VCF $CONFIG"

# ARGS="-N 23 -e"
ARGS="$@ -N 23 -o /results"
CMD_INNER="/bin/bash /opt/VEP_QC/src/VEP_QC.sh $ARGS $VCF "


SYSTEM=compute1   # docker MGI or compute1
START_DOCKERD="../../docker/WUDocker"  # https://github.com/ding-lab/WUDocker.git

VOLUME_MAPPING="$DATAD:/data $RESULTSD:/results"

>&2 echo Launching $IMAGE on $SYSTEM
CMD_OUTER="bash $START_DOCKERD/start_docker.sh -r -I $IMAGE -M $SYSTEM -c \"$CMD_INNER\" $VOLUME_MAPPING "
echo Running: $CMD_OUTER
eval $CMD_OUTER

>&2 echo Return value: $?
