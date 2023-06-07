
DATAD="/storage1/fs1/dinglab/Active/Projects/ysong/Projects/PECGS/Analysis/ATAC_Tindaisy_Somaticwrapper_comparision/atac_wxs_bam_v2/runs/CPT4427DU-TWHG-CPT4427DU-T1Y1D1_1.T"

# changing directories so entire project directory is mapped by default
cd ../..
ARGS="-M compute1"

source docker/docker_image.sh
IMAGE=$IMAGE

bash docker/WUDocker/start_docker.sh $@ $ARGS -I $IMAGE $DATAD:/data 

