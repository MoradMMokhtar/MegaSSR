import os
import glob
import sys

primerfiles=sys.argv[1]
outdir=sys.argv[2]
nprocess=sys.argv[3]
extractseq=sys.argv[4]
modified_p3=sys.argv[5]
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

data=glob.glob(f"{outdir}/*")

from multiprocessing import Pool
def f(fname):
    fastabase=fname.split('/')[-1].replace('.p3in','')  
    #Function is bieng executed
    os.system(f"primer3_core < {outdir}/{fastabase}.p3in > {outdir}/{fastabase}.p3out")
# set a number of processes to use ncore each ### with work as for
with Pool(int(ncore)) as p:
    results  = p.map(f, data)