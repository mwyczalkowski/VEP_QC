Basis of testing whether VEP annotation exits silently:
* we expect each regular chrom to have a significant number of variants annotated with dbSnP IDs
* Count the number of chrom which have at least one dbSnP annotation (VCF ID field starts with 'rs')
  * we expect this number to be 23

if this number is not 23 that may indicate
* VEP annotation incomplete
* a VCF with relatively few variants


Example of annotation which exits early:
TD_AUS_VCF_ALL="/storage1/fs1/m.wyczalkowski/Active/ProjectStorage/Analysis/20230427.SW_vs_TD/dat/call-snp_indel_proximity_filter/execution/output/ProximityFiltered.vcf"

BASE_EJ="/storage1/fs1/dinglab/Active/Projects/ysong/Projects/PECGS/Analysis/ATAC_Tindaisy_Somaticwrapper_comparision/atac_wxs_bam_v2/runs/CPT4427DU-TWHG-CPT4427DU-T1Y1D1_1.T/cromwell-workdir/cromwell-executions/pecgs_TN_wxs_bam.cwl/b8745052-e741-4e8f-abe9-ee8bbb118790/call-run_tindaisy/tindaisy2.6.2_vep102_vafrescue.cwl/9a908989-422e-4872-9e1b-0747b497be97"
TD_EJ_VCF_ALL="$BASE_EJ/call-snp_indel_proximity_filter/execution/output/ProximityFiltered.vcf"
grep -v "#" $TD_EJ_VCF_ALL | awk 'BEGIN{FS="\t";OFS="\t"}{print $1, substr($3,1,2)}' | grep -v "random" | grep -v "chrUn" | grep -v "chrM" | grep "rs" | sort | uniq -c
   1162 chr10   rs
   1576 chr11   rs
   1261 chr12   rs
    471 chr13   rs
    907 chr14   rs
    918 chr15   rs
   1020 chr16   rs
   1599 chr17   rs
    396 chr18   rs
   2430 chr19   rs
   2887 chr1    rs
    898 chr20   rs
    396 chr21   rs
    790 chr22   rs
   2140 chr2    rs
   1540 chr3    rs
    722 chr4    rs
   1199 chr5    rs
   1778 chr6    rs
   1406 chr7    rs
    903 chr8    rs
   1418 chr9    rs
    772 chrX    rs

Model for QC of VEP annotation:
* Separate tool which takes VEP annotation as input
  * Performs analysis above and writes it to file - "id_per_chr.dat"
  * Runs validate_counts.sh
    * takes as input expected number of chr (default: 23)
    * if line count of id_per_chr.dat differs from expected, 
      * write file unexpected_id_count.flag with content like below is written, and reported as an output of QC
      * if the flag "-e" is set, exit with an error, otherwise exit with no error


Content of warning / error file:
```
WARNING: Unexpected number of lines in id_per_chr.dat: observed 12, expected 23

QC testing of VCF annotation to test whether VEP silently exits:
* we expect each regular chrom to have a significant number of variants annotated with dbSnP IDs
* Count the number of chrom which have at least one dbSnP annotation (VCF ID field starts with 'rs')
  * we expect this number to be 23

If youre seeing this file it means that number of chromosomes with at least one dbSnP annotation
differs from what is expected.  Reasons may include:
* VEP annotation is incomplete
* VCF with few variants

Please review annotation of VCF carefully to determine whether a problem exists.
```


