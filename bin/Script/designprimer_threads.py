import os
import glob
import sys

FASTA=sys.argv[1]
primerfiles=sys.argv[2]
outdir=sys.argv[3]
nprocess=sys.argv[4]
extractseq=sys.argv[5]
modified_p3=sys.argv[6]
# nprocess=6
# set number of CPUs to run on
ncore = f"{nprocess}"
# ncore = "4"

# set env variables
# have to set these before importing numpy
os.environ["OMP_NUM_THREADS"] = ncore
os.environ["OPENBLAS_NUM_THREADS"] = ncore
os.environ["MKL_NUM_THREADS"] = ncore
os.environ["VECLIB_MAXIMUM_THREADS"] = ncore
os.environ["NUMEXPR_NUM_THREADS"] = ncore

data=glob.glob(f"{primerfiles}/*")

from multiprocessing import Pool
def f(fname):
     
    #Function is bieng executed
    fastabase=FASTA.split('/')[-1].replace('.fa','')
    name2=fname.split('/')[-1]
    os.system(f"perl {extractseq} {FASTA} {fname} {outdir}/{fastabase}.{name2}")
    os.system(f"perl {modified_p3} {outdir}/{fastabase}.{name2}")
# set a number of processes to use ncore each ### with work as for
with Pool(int(ncore)) as p:
    results  = p.map(f, data)
