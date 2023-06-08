# VEP Annotation QC

This tool is designed to validate VEP annotation.

Motivation is an instance observed where, past a certain genomic position, VEP annotation would "break":
* Consequence field is the same for all variants,
```
CSQ=-|intergenic_variant|MODIFIER||||||||||||||||1||||1|deletion|1||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
```
* Loss of dbSnP annotation - ID field of VCF does not have a `rs` identifier

Canonical example of this sort of event:
```
/storage1/fs1/m.wyczalkowski/Active/ProjectStorage/Analysis/20230427.SW_vs_TD/dat/call-snp_indel_proximity_filter/execution/output/ProximityFiltered.vcf
```

## Algorithm
Basis of testing whether VEP annotation exits silently:

* we expect each regular chrom to have a significant number of variants annotated with dbSnP IDs
* Count the number of chrom which have at least one dbSnP annotation (VCF ID field starts with 'rs')
  * we expect this number to be 23

If this number is not 23 that may indicate

    * VEP annotation incomplete
    * a VCF with relatively few variants

Algorithm for QC of VEP annotation QC:

* Separate tool which takes VEP annotation as input
  * Performs analysis above and writes it to file - "id_per_chr.dat"
  * Runs validate_counts.sh
    * takes as input expected number of chr (default: 23)
    * if line count of id_per_chr.dat differs from expected, 
      * write file unexpected_id_count.flag with content like below is written, and reported as an output of QC
      * if the flag "-e" is set, exit with an error, otherwise exit with no error
  * the tool accepts "fake" arguments like "-x string", which permit a dependency on the final
    output of a workflow, thus ensuring the QC runs last.
    * This allows for the workflow to optionally exit with an error condition, but with all results
      still available for inspection


