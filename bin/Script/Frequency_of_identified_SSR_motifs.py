#!/usr/bin/env python
# coding: utf-8

# plots Distribution of various SSR classes
#author rachid elfermi
#contact rachid.elfermi@gmail.com
# version 1.0
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from IPython.display import set_matplotlib_formats
# set_matplotlib_formats('retina', quality=100)
import seaborn as sns
import sys
input_file=sys.argv[1]
output_file=sys.argv[2]
# Load cars dataset from Vega's dataset library.
dff=pd.read_csv(input_file, sep="\t")
df = dff.sort_values(by=['total'], ascending=False)
df=df.iloc[:60]
plt.rcParams['figure.figsize'] = (25, 15)
fig, ax = plt.subplots()

# Save the chart so we can loop through the bars below.
colors=sns.color_palette()
bars = ax.bar(
    x=np.arange(len(df["Repeats"].tolist())),
    height=df["total"],
    tick_label=df["Repeats"],
     color=colors
)
plt.xticks(fontsize=14,rotation = 70)
plt.yticks(fontsize=16)
plt.annotate('*Only the highest 60 values are shown', xy = (-1, 30), 
             fontsize = 16, xytext = (45,-35), 
             color = 'r')
# Axis formatting.


ax.margins(0.01, 0.11)  
ax.tick_params(bottom=False, left=False)
ax.set_axisbelow(True)
ax.yaxis.grid(True, color='#EEEEEE')
ax.xaxis.grid(False)
# Add text annotations to the top of the bars.
bar_color = bars[0].get_facecolor()
for bar in bars:
    ax.text(
      bar.get_x() + bar.get_width() / 2,
      bar.get_height() + int(len(df["Repeats"].tolist())/3)+1,
      round(bar.get_height(),1),
      horizontalalignment='center',
      color=bar_color,
      weight='bold',
      rotation = 70,
      fontsize=16
  )
# Add labels and a title. Note the use of `labelpad` and `pad` to add some
# extra space between the text and the tick labels.
ax.set_xlabel('Repeat', labelpad=15,weight='bold' ,fontsize=20,color='#333333')
ax.set_ylabel('Count', labelpad=16,weight='bold' ,fontsize=20,color='#333333')
ax.set_title('Frequency of identified SSR motifs',fontsize=20, pad=15, color='#333333',weight='bold')
plt.savefig(output_file, bbox_inches='tight')