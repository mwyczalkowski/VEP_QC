#TD_AUS_VCF_ALL="/storage1/fs1/m.wyczalkowski/Active/ProjectStorage/Analysis/20230427.SW_vs_TD/dat/call-snp_indel_proximity_filter/execution/output/ProximityFiltered.vcf"
#DATA2D="/storage1/fs1/m.wyczalkowski/Active/ProjectStorage/Analysis/20230427.SW_vs_TD"

ARGS="-N 23 -e -x foobar"
DATD="/data2"
VCF="$DATD/dat/call-snp_indel_proximity_filter/execution/output/ProximityFiltered.vcf"

OUTD="./results_2"
mkdir -p $OUTD
CMD="bash ../../src/VEP_QC.sh -o $OUTD $ARGS $@ $VCF "

>&2 echo Running: $CMD
eval $CMD

>&2 echo Return value: $?

