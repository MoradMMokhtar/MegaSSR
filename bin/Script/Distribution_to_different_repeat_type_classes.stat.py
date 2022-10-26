# plots Distribution of various SSR classes
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from IPython.display import set_matplotlib_formats
set_matplotlib_formats('retina', quality=100)
import seaborn as sns
import sys
input_file=sys.argv[1]
output_file=sys.argv[2]
# Load cars dataset from Vega's dataset library.
df=pd.read_csv(input_file, sep="\t")
df=df.drop('Process Id', axis=1)

plt.rcParams['figure.figsize'] = (10, 7)
fig, ax = plt.subplots()
colors=sns.color_palette()+sns.color_palette("pastel")
# Save the chart so we can loop through the bars below.
bars = ax.bar(
    x=np.arange(len(df["Repeat Type"].tolist())),
    height=df["Total No. of present"],
    tick_label=df["Repeat Type"],
    color=colors
)
plt.xticks(fontsize=16)
plt.yticks(fontsize=16)
# Axis formatting.
#ax.margins(0.01, 0.2) 
ax.tick_params(bottom=False, left=False)
ax.set_axisbelow(True)
ax.yaxis.grid(True, color='#EEEEEE')
ax.xaxis.grid(False)

# Add text annotations to the top of the bars.
bar_color = bars[0].get_facecolor()
for bar in bars:
    ax.text(
      bar.get_x() + bar.get_width() / 2,
      bar.get_height() + int(len(df["Repeat Type"].tolist())/3)+1,
      round(bar.get_height(),1),
      horizontalalignment='center',
      color=bar_color,
      weight='bold',
      fontsize=16
  )
  
# Add labels and a title. Note the use of `labelpad` and `pad` to add some
# extra space between the text and the tick labels.
ax.set_xlabel('Repeat Class', labelpad=15,weight='bold' ,fontsize=20,color='#333333')
ax.set_ylabel('Count', labelpad=15,weight='bold' ,fontsize=20,color='#333333')
ax.set_title('Distribution of various SSR classes', pad=15, color='#333333',fontsize=20,weight='bold')
fig.tight_layout()
plt.savefig(output_file, bbox_inches='tight')
