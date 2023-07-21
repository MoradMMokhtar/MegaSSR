import sys
import os
mono=sys.argv[1]
di=sys.argv[2]
tri =sys.argv[3]
tetra= sys.argv[4]
penta = sys.argv[5]
hexa =sys.argv[6]
compound= sys.argv[7]
path = sys.argv[8]
data=f"""definition(unit_size,min_repeats):       1-{mono} 2-{di} 3-{tri} 4-{tetra} 5-{penta} 6-{hexa} 
interruptions(max_difference_between_2_SSRs):        {compound}"""
with open(f"{path}/misa.ini",'w') as file:
	file.write(data)
