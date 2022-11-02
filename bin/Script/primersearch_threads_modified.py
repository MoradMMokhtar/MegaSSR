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

data=glob.glob(f"{FASTA}/*.fa")

from multiprocessing import Pool
def f(fname):
    fastabase=FASTA.split('/')[-1].replace('.fa','')
    name2=fname.split('/')[-1]
     
    #Function is bieng executed
    os.system(f"primersearch -seqall {fname} -infile {primerfiles} -mismatchperc 6 -outfile {outdir}/{name2}.primersearch -auto && cat {outdir}/{name2}.primersearch >> {outdir}/results.primersearch && rm {outdir}/{name2}.primersearch")      
*.
# set a number of processes to use ncore each ### with work as for
with Pool(int(nprocess)) as p:
    results  = p.map(f, data)
