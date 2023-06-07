# VEP Annotation QC

This tool is meant to evaluate instances where VEP annotation dies quietly with trivial
annotation, as was observed once in a run.

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



