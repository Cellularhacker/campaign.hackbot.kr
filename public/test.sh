#!/bin/bash

#PBS -N t11_conv_blastn_Labidocera_acuta_SPAdes
#PBS -q batch
#PBS -l nodes=1:ppn=2
#PBS -l mem=4gb
#PBS -l walltime=360:00:00
#PBS -e /home/cellularhacker/works/diff_gene_expression_try03/11-1_NI_conv/test11a-1_e_-4.5_.sh.err
#PBS -o /home/cellularhacker/works/diff_gene_expression_try03/11-1_NI_conv/test11a-1_e_-4.5_.sh.out
#PBS -m abe
#PBS -M wva3cdae@gmail.com

NORMAL_DIR='/home/cellularhacker/works/DNAlink_TotalRNA_3'
INFECTED_DIR='/home/cellularhacker/works/L_acuta_Ciliate-infected_3'
BASEDIR='/home/cellularhacker/works/diff_gene_expression_try03'
NORMAL_FASTA_DIR="${NORMAL_DIR}/04-1_SPAdes"
INFECTED_FASTA_DIR="${INFECTED_DIR}/04-1_SPAdes"
IN_DIR="${BASEDIR}/10a-1_Infected_to_Normal"
WORKDIR="${BASEDIR}/11a-1_IN_conv"
NORMAL_DB_DIR="${NORMAL_DIR}/06-1_DB-SPAdes"
INFECTED_DB_DIR="${INFECTED_DIR}/06-1_DB-SPAdes"

OUTFMT="5"
SUFFIX="e_-4.${OUTFMT}.xml"

INPUT_NAME="I_to_N_gen_${SUFFIX}"
OUT_BASE='IN_conv'
OUT_NAME="${OUT_BASE}_${SUFFIX}"

T_PATH="${WORKDIR}/${OUT_NAME}"

SCRIPT_NAME="test11a-1_${SUFFIX}.sh"

STDERR="${WORKDIR}/${SCRIPT_NAME}.err"
STDOUT="${WORKDIR}/${SCRIPT_NAME}.out"

T_IN="${IN_DIR}/${INPUT_NAME}"
T_TMP="${T_IN}.0"
T_OUT="${WORKDIR}/${OUT_BASE}.fasta"

PATH="${PATH}:${WORKDIR}"
export PATH

LAST_MODIFIED_TS=''

# MARK: Checking if there is previous file (for STDOUT)
if [ -f $STDOUT ]; then
        LAST_MODIFIED_TS=$(date -r "${STDOUT}" "+20%y%m%d-%H%M%S")
        mv "${STDOUT}" "${STDOUT}.${LAST_MODIFIED_TS}"
fi

# MARK: Checking if there is previous file (for STDERR)
if [ -f $STDERR ]; then
        if [ $LAST_MODIFIED_TS -eq '' ]; then
                LAST_MODIFIED_TS=$(date -r "${STDERR}" "+20%y%m%d-%H%M%S")
        fi
        mv "${STDERR}" "${STDERR}.${LAST_MODIFIED_TS}"
fi

# MARK: Checking if there is previous file (for T_OUT)
if [ -f $T_OUT ]; then
        if [ $LAST_MODIFIED_TS -eq '' ]; then
                LAST_MODIFIED_TS=$(date -r "${T_OUT}" "+20%y%m%d-%H%M%S")
        fi
        mv "${T_OUT}" "${T_OUT}.${LAST_MODIFIED_TS}"
fi

# MARK: Checking if there is previous file (for T_IN)
if [ -f $T_IN ]; then
        if [ $LAST_MODIFIED_TS -eq '' ]; then
                LAST_MODIFIED_TS=$(date -r "${T_OUT}" "+20%y%m%d-%H%M%S")
        fi
        mv "${T_IN}" "${T_IN}.${LAST_MODIFIED_TS}"
fi
# MARK: Make Working Directory. Ignoring when it is already exists.
mkdir -p "${WORKDIR}"

echo '#####################################################' >>"${STDOUT}" && \
echo '' >>"${STDOUT}" && \
echo '>started_at' >>"${STDOUT}" && \
echo "${TS}" >>"${STDOUT}" && \
echo '' >>"${STDOUT}" && \
echo '>hostname' >>"${STDOUT}" && \
echo '' >>"${STDOUT}" && \
hostname >>"${STDOUT}" && \
echo '' >>"${STDOUT}" && \
echo '>date' >>"${STDOUT}" && \
date >>"${STDOUT}" && \
echo '' >>"${STDOUT}" && \
echo '>uname -a' >>"${STDOUT}" && \
uname -a >>"${STDOUT}" && \
echo '' >>"${STDOUT}" && \
echo ">T_IN" >>"${STDOUT}" && \
echo "${T_IN}" >>"${STDOUT}" && \
echo '' >>"${STDOUT}" && \
echo '>T_IN size' >>"${STDOUT}" && \
echo "$(du -hs ${T_IN})" >>"${STDOUT}" && \
echo '' >>"${STDOUT}" && \
echo '>T_TMP'>>"${STDOUT}" && \
echo "${T_TMP}" >>"${STDOUT}" && \
echo '' >>"${STDOUT}" && \
echo '>T_OUT' >>"${STDOUT}" && \
echo "${T_OUT}" >>"${STDOUT}" && \
echo '' >>"${STDOUT}" && \
echo '>T_NUM_THREADS' >>"${STDOUT}" && \
echo "${T_NUM_THREADS}" >>"${STDOUT}" && \
echo '' >>"${STDOUT}" && \
echo '>T_PATH' >>"${STDOUT}" && \
echo "${T_PATH}" >>"${STDOUT}" && \
echo '' >>"${STDOUT}" && \
cd "${WORKDIR}" && \
cp -pf "${IN_DIR}/${INPUT_NAME}" "${T_PATH}.0" && \
$("${BASEDIR}/blastxml2fasta.pl" < "${T_PATH}.0" >"${T_PATH}" 2>"${STDERR}" ) && \
rm "${T_PATH}.0" && \
mv "${T_PATH}" "${T_OUT}"
