import os
import glob
import sys

primerfiles=sys.argv[1]
outdir=sys.argv[2]
nprocess=sys.argv[3]
extractseq=sys.argv[4]
modified_p3=sys.argv[5]
organis_name=sys.argv[6]
modified_p3_genic=sys.argv[7]
primers_line_genic=sys.argv[8]
intermediate_File_step_1=sys.argv[9]

# nprocess=6
# set number of CPUs to run on
ncore = f"{nprocess}"
# ncore = "4"
os.environ["OMP_NUM_THREADS"] = ncore
os.environ["OPENBLAS_NUM_THREADS"] = ncore
os.environ["MKL_NUM_THREADS"] = ncore
os.environ["VECLIB_MAXIMUM_THREADS"] = ncore
os.environ["NUMEXPR_NUM_THREADS"] = ncore


data=glob.glob(f"{outdir}/*.p3in")

from multiprocessing import Pool
def f(fname):
    fastabase=fname.split('/')[-1].replace('.p3in','')  
    #Function is bieng executed
    os.system(f"primer3_core < {outdir}/{fastabase}.p3in > {outdir}/{fastabase}.p3out && perl {modified_p3_genic} {outdir}/{fastabase}.p3out && sed -i 's/==/\t/g' {outdir}/{fastabase}.results && perl {primers_line_genic} {outdir}/{fastabase}.results > {outdir}/{fastabase}.results2 && cat {outdir}/{fastabase}.results2 >> {intermediate_File_step_1}/{organis_name}.interGenic-primers3.txt && rm {outdir}/{fastabase}.results2 {outdir}/{fastabase}.results {outdir}/{fastabase}.p3out {outdir}/{fastabase}.p3in {outdir}/{fastabase} {outdir}/{fastabase}.stat")

# set a number of processes to use ncore each ### with work as for
with Pool(int(nprocess)) as p:
    results  = p.map(f, data)