#!/usr/bin/env python
# coding: utf-8
# plots Distribution of various SSR classes
import sys
from bandwagon import BandsPattern, BandsPatternsSet
from bandwagon import custom_ladder
input_file=sys.argv[1]
title_file=sys.argv[2]
ladder_arg=int(sys.argv[3])
plot_size=int(sys.argv[4])
output_file=sys.argv[5]
output=sys.argv[6]
if plot_size>100:
    plot_size=100
# output="output.txt"#sys.argv[4]

if   ladder_arg<= 1001:
    kb_Ladder="1kb Ladder"
    LADDER_100_to_nk = custom_ladder("100-1k", {
    100: 205,200: 186,300: 171,400: 158, 500: 149, 600: 139,850: 128,1000: 121  
})
if ladder_arg >1000 and  ladder_arg <=2000:
    kb_Ladder="2kb Ladder"
    LADDER_100_to_nk=custom_ladder("100-2k", {
    100: 205,200: 186,300: 171,400: 158,500: 149,650: 139, 850: 128, 1000: 121,1650: 100, 2000: 90 
})
if ladder_arg >2000 and  ladder_arg<=3000:
    kb_Ladder="3kb Ladder"
    LADDER_100_to_nk=custom_ladder("100-3k", {
    100: 205,200: 186,300: 171, 400: 158,500: 149, 650: 139,850: 128, 1000: 121, 1650: 100, 2000: 90,3000: 73  
})
if ladder_arg >3000:
    kb_Ladder="4kb Ladder"
    LADDER_100_to_nk=custom_ladder("100-4k", {
    100: 205, 200: 186, 300: 171, 400: 158,500: 149, 650: 139, 850: 128, 1000: 121, 1650: 100,2000: 90, 3000: 73, 4000: 65
})

# Load data
data={}
with open(input_file,"r") as file:
    for line in file.readlines():
        list_data=line.rstrip().split("\t")
        if list_data[0] not in data.keys():
            data[list_data[0]]=list(map(int, list_data[1:]))
        else:
            data[list_data[0]]+=list(map(int, list_data[1:]))
# create ladder
keysList = list(data.keys())
for i,x in enumerate(range(0,len(data.keys()),plot_size)):
    ladder = LADDER_100_to_nk.modified(label=f"{kb_Ladder}", background_color="#F4D03F")
    patterns = [
        BandsPattern(data[key],
        ladder=LADDER_100_to_nk, label=key)
        for key in keysList[x:x+plot_size]
    ]

    patterns_set = BandsPatternsSet(patterns=[ladder] + patterns, ladder=ladder,
                                    label=title_file, ladder_ticks=3)
    ax = patterns_set.plot()
    ax.set_xlabel('Note: If the band is sharp, it contains more than one band\nThis is the case when the difference in band size is small.', labelpad=15 ,fontsize=6,color='r')

    basename=output_file.split('/')[-1]
    fullpath=output_file.split('/')[:-1]
    xx=i+1
    out='/'.join(fullpath)+'/'+str(xx)+"_"+basename
    ax.figure.savefig(f"{out}", bbox_inches="tight", dpi=600)

with open(output,"w") as file:
    for key in  data.keys():
        ID="_".join(key.split("_")[:-1])
        reg=key.split("_")[-1]
        file.write(f"{key}\t")
        # file.write(f"{key}\t{ID}\t{reg}\t")
        for line in data[key]:
            file.write(f"{line}\t")
        file.write(f"\n")
