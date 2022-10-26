#!/usr/bin/env python
# coding: utf-8

import matplotlib.pyplot as plt
from matplotlib_venn import venn2
import pandas as pd
import sys
plt.rcParams['figure.figsize'] = (15, 10)
shares_input=sys.argv[1]
genec_input=sys.argv[2]
nongeneic_input=sys.argv[3]
output_file=sys.argv[4]
# Load cars dataset from Vega's dataset library.
shared=pd.read_csv(shares_input, sep="\t")
genec=pd.read_csv(genec_input, sep="\t")
nongeneic=pd.read_csv(nongeneic_input, sep="\t")
shared_lenth=len(shared["Repeat Sequence"].tolist())
genec_lenth=len(genec["Repeat Sequence"].tolist())
nongeneic=len(nongeneic["Repeat Sequence"].tolist())
out =venn2(subsets = (genec_lenth ,nongeneic , shared_lenth ), set_labels = ('Genic region', 'Non-genic region'),set_colors=('#C39BD3', '#3498DB'), alpha = 0.9)
for text in out.set_labels:
    text.set_fontsize(16)
for text in out.subset_labels:
    text.set_fontsize(16)
plt.title("Venn diagram showing a comparison of genic and non-genic SSR",fontsize=16)
plt.savefig(output_file, bbox_inches='tight')

