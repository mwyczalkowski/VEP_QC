
DATAD="/storage1/fs1/dinglab/Active/Projects/ysong/Projects/PECGS/Analysis/ATAC_Tindaisy_Somaticwrapper_comparision/atac_wxs_bam_v2/runs/CPT4427DU-TWHG-CPT4427DU-T1Y1D1_1.T"
DATA2D="/storage1/fs1/m.wyczalkowski/Active/ProjectStorage/Analysis/20230427.SW_vs_TD"

MAPPATHS="$DATAD:/data  $DATA2D:/data2"

# changing directories so entire project directory is mapped by default
cd ../..
ARGS="-r -M compute1"

source docker/docker_image.sh
IMAGE=$IMAGE

bash docker/WUDocker/start_docker.sh $@ $ARGS -I $IMAGE $MAPPATHS

