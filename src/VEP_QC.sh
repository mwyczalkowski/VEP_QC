#!/bin/bash

# Matthew Wyczalkowski <m.wyczalkowski@wustl.edu>
# https://dinglab.wustl.edu/

read -r -d '' USAGE <<'EOF'
Evaluate VEP annotaion per chromosome, to identify instances where VCF not fully annotated

Usage:
  VEP_QC.sh [options] VCF

Options:
-h: Print this help message
-N NUM_EXPECTED: number of expected chrom with 1+ dbSnP annotation. If not provided, no test is performed
-e: Exit with an error if actual count different from NUM_EXPECTED
-o OUTD: directory where output files are written.  Default: '.'
-x ANYSTRING: arbitrary value which will be ignored

Algorithm:
* Count number of times dbSnP annotation exists (ID field of VCF starts with `rs`), save to file `id_per_chr.dat`
    * discard "random", "chrUn", "chrM", "chrY" chromosomes
* optionally, test whether the number of chromosomes with any dbSnP annotation is as expected
    * Typically expect 23
    * If actual count is different than expected, write file `unexpected_id_count.flag`
      * The presence of this file indicates a warning and should be reported by workflow
      * Optionally exit with an error

EOF

# The text below, with fields filled in, will be written to file FLAG_FN if an unexpected number of 
# variants is encountered
read -r -d '' FLAG_TEMPLATE <<'EOF2'
%s: Unexpected number of lines in %s: observed %d, expected %d

QC testing of VCF annotation to test whether VEP silently exits:
* we expect each regular chrom to have a significant number of variants annotated with dbSnP IDs
* Count the number of chrom which have at least one dbSnP annotation (VCF ID field starts with 'rs')
  * We find that the observed and expected counts do not match

If you're seeing this file it means that number of chromosomes with at least one dbSnP annotation
differs from what is expected.  Reasons may include:
* VEP annotation is incomplete
    * this is the error condition we're trying to catch
* VCF with few variants
* chromosome names which differ from GRCh38

Please review annotation of VCF carefully to determine whether a problem exists.

EOF2

OUTD="."

GREP="/bin/grep"
AWK="/usr/bin/awk"
SORT="/usr/bin/sort"
UNIQ="/usr/bin/uniq"

# http://wiki.bash-hackers.org/howto/getopts_tutorial
while getopts ":hN:eo:x:" opt; do
  case $opt in
    h)
      echo "$USAGE"
      exit 0
      ;;
    e)  
      EXIT_WITH_ERROR=1
      ;;
    N) 
      NUM_EXPECTED=$OPTARG
      ;;
    o) 
      OUTD=$OPTARG
      ;;
    x) 
      : # do nothing
      ;;
    \?)
      >&2 echo "Invalid option: -$OPTARG" 
      echo "$USAGE"
      exit 1
      ;;
    :)
      >&2 echo "Option -$OPTARG requires an argument." 
      echo "$USAGE"
      exit 1
      ;;
  esac
done
shift $((OPTIND-1))

# Called after running scripts to catch fatal (exit 1) errors
# works with piped calls ( S1 | S2 | S3 > OUT )
function test_exit_status {
    # Evaluate return value for chain of pipes; see https://stackoverflow.com/questions/90418/exit-shell-script-based-on-process-exit-code
    # exit code 137 is fatal error signal 9: http://tldp.org/LDP/abs/html/exitcodes.html

    rcs=${PIPESTATUS[*]};
    for rc in ${rcs}; do
        if [[ $rc != 0 ]]; then
            >&2 echo Fatal error.  Exiting
            exit $rc;
        fi;
    done
}


function run_cmd {
    CMD=$1

    NOW=$(date)
    if [ "$DRYRUN" == "d" ]; then
        >&2 echo [ $NOW ] Dryrun: $CMD
    else
        >&2 echo [ $NOW ] Running: $CMD
        eval $CMD
        test_exit_status
    fi
}

COUNT_FN="$OUTD/id_per_chr.dat"
FLAG_FN="$OUTD/unexpected_id_count.flag"

CMD="mkdir -p $OUTD"
run_cmd "$CMD"

if [ "$#" -ne 1 ]; then
    >&2 echo Error: Wrong number of arguments
    echo "$USAGE"
    exit 1
fi

VCF=$1

if [ ! -e $VCF ]; then
    >&2 echo ERROR: $VCF does not exist
    exit 1
fi

>&2 echo Processing VCF $VCF
>&2 echo Writing count of dbSnP variants per chrom to $COUNT_FN
# Apparently the -a flag (treat binary as text) is required - image treats VCF file as binary otherwise?
CMD="$GREP -a -v '^#' $VCF | $AWK 'BEGIN{FS=\"\t\";OFS=\"\t\"}{print \$1, substr(\$3,1,2)}' | $GREP -v 'random' | $GREP -v 'chrUn' | $GREP -v 'chrM' | $GREP -v 'chrY' | $GREP 'rs' | $SORT | $UNIQ -c  > $COUNT_FN"
run_cmd "$CMD"

if [ $EXIT_WITH_ERROR ]; then
    MSG="ERROR"
else
    MSG="WARNING"
fi

if [ ! -z $NUM_EXPECTED ]; then
    CHR_COUNT=$(wc -l $COUNT_FN | cut -f 1 -d ' ')
    
    if [ "$CHR_COUNT" == "$NUM_EXPECTED" ]; then
        >&2 echo Count as expected: $NUM_EXPECTED
        exit 0
    fi

    # We are now in an error condition where counts don't match
    printf "$FLAG_TEMPLATE" $MSG $COUNT_FN $CHR_COUNT $NUM_EXPECTED > $FLAG_FN

    >&2 echo $MSG: Unexpected number of lines in $COUNT_FN: observed $CHR_COUNT, expected $NUM_EXPECTED
    >&2 echo Writing file $FLAG_FN

    if [ $EXIT_WITH_ERROR ]; then
        exit 1
    fi
fi
        
exit 0
