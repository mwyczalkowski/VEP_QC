source ../../docker/docker_image.sh

#TD_AUS_VCF_ALL="/storage1/fs1/m.wyczalkowski/Active/ProjectStorage/Analysis/20230427.SW_vs_TD/dat/call-snp_indel_proximity_filter/execution/output/ProximityFiltered.vcf"
# /data maps to DATAD
DATAD="/storage1/fs1/m.wyczalkowski/Active/ProjectStorage/Analysis/20230427.SW_vs_TD"

RESULTS="results_2"
RESULTSD="/home/m.wyczalkowski/Projects/Adhoc/20230427.SW_vs_TD/D_VEP_QC/testing/docker_call/$RESULTS"
mkdir -p $RESULTSD

VCF="/data/dat/call-snp_indel_proximity_filter/execution/output/ProximityFiltered.vcf"

# This is what we want to run in docker
#CMD_INNER="/bin/bash /opt/VEP_Filter/src/run_af_filter.sh $@ -o $OUT $VCF $CONFIG"

ARGS="$@ -N 23 -o $RESULTS -e -x foobar"
CMD_INNER="/bin/bash /opt/VEP_QC/src/VEP_QC.sh $ARGS $VCF "

SYSTEM=compute1   
START_DOCKERD="../../docker/WUDocker"  # https://github.com/ding-lab/WUDocker.git

VOLUME_MAPPING="$DATAD:/data $RESULTSD:/$RESULTS"

>&2 echo Launching $IMAGE on $SYSTEM
CMD_OUTER="bash $START_DOCKERD/start_docker.sh -r -I $IMAGE -M $SYSTEM -c \"$CMD_INNER\" $VOLUME_MAPPING "
echo Running: $CMD_OUTER
eval $CMD_OUTER

>&2 echo Return value: $?
