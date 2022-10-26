import os
import glob
import sys

path=sys.argv[1]
nprocess=sys.argv[2]
LTRFINDER=sys.argv[3]
outdir=sys.argv[4]

# set number of CPUs to run on
ncore = f"{nprocess}"

# set env variables
# have to set these before importing numpy
os.environ["OMP_NUM_THREADS"] = ncore
os.environ["OPENBLAS_NUM_THREADS"] = ncore
os.environ["MKL_NUM_THREADS"] = ncore
os.environ["VECLIB_MAXIMUM_THREADS"] = ncore
os.environ["NUMEXPR_NUM_THREADS"] = ncore

data=glob.glob(f"{path}/*.fa")

from multiprocessing import Pool
def f(fname):
     
    #Function is bieng executed
    os.system(f"perl {LTRFINDER} {fname} {outdir}")
    #os.system(f"bash threads.sh {x} LTRFINDER")
    

# set a number of processes to use ncore each ### with work as for
with Pool(int(nprocess)) as p:
    results  = p.map(f, data)
