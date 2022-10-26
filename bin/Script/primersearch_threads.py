import os
import glob
import sys

FASTA=sys.argv[1]

primerfiles=sys.argv[2]
outdir=sys.argv[3]
nprocess=sys.argv[4]
# set number of CPUs to run on
ncore = f"{nprocess}"


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
    os.system(f"primersearch -seqall {FASTA} -infile {fname} -mismatchperc 6 -outfile {outdir}/{fastabase}.{name2} -auto")    

# set a number of processes to use ncore each ### with work as for
with Pool(int(ncore)) as p:
    results  = p.map(f, data)
