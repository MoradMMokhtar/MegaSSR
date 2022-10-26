#!/usr/bin/env python
# coding: utf-8
import sys
import glob
import os
inputfile=sys.argv[1]
if inputfile[-1] not in '/':
    inputfile+="/" 
extention=sys.argv[2]
outputfile=f'{inputfile}mergerd{extention}'
zips=glob.glob(f"{inputfile}*{extention}")
if len(zips)>0:
    dicts={}
    with open(zips[0]) as f:
        nlist=f.readlines().copy()
    dicts={line.split("\t")[0]:0 for line in nlist }
    for dirs in zips:
        with open(dirs) as f:
                nlist=f.readlines().copy()
                for data in nlist:
                    #print(data.split("\t")[0])
                    if data.split("\t")[0] not in dicts.keys():
                        dicts[data.split("\t")[0]]=0
                    ss=data.split("\t")[1]
                    if data.split("\t")[1]=='\n':
                        ss=0
                    dicts[data.split("\t")[0]]+=int(ss)
    with open(outputfile,"w") as file:
        for key in dicts.keys():
                file.write(f"{key}\t{dicts[key]}\n") 
