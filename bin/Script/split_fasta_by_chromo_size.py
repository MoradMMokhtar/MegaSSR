#!/usr/bin/env python
sequencescoton = {}
countercoton=[]
import os,sys
count=0
ids=[]
allid=[]

descr = None
plant=sys.argv[1]
out_path=sys.argv[2]
number_of_files=sys.argv[3]
plants=plant.split('/')[-1]
size=int(os.stat(plant).st_size/int(number_of_files))
with open(plant,"r") as file:
    line = file.readline()[:-1] # always trim newline
    while line:
        if line[0] == '>':
            if descr: # any sequence found yet?
                sequencescoton[descr]= seq
                countercoton.append((len(seq),descr))
            descr = line[1:].split()[0]
            seq = '' # start a new sequence
        else:
            seq += line
        line = file.readline()[:-1]
    sequencescoton[descr]= seq
    countercoton.append((len(seq),descr))
jj=0  
chromo=plants.replace('.fa','') 
for ind,val in enumerate(sorted(countercoton)):
    count+=val[0]
    ids.append(val[1])
    if count>=size:
        jj+=1
        with open(f"{out_path}/{chromo}_{jj}.fa","w") as fp:
            for NC in  set(ids):
                fp.write(f">{NC}\n")
                fp.write(f"{sequencescoton[NC]}\n") 
        count=0
        allid+=ids
        ids=[]
    elif count<size and ind==len(countercoton)-1:
        allid+=ids
        jj+=1
        with open(f"{out_path}/{chromo}_{jj}.fa","w") as fp:
            for NC in  set(ids):
                fp.write(f">{NC}\n")
                fp.write(f"{sequencescoton[NC]}\n") 

