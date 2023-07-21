import fileinput
import sys
import re

def calculate(dna_string):
	count = 0
	characters = re.findall(r'\((.*?)\)', dna_string)
	numbers = re.findall(r'\)(\d+)', dna_string)
	matches = re.findall(r"([A-Za-z]+)(?=\(|\n|\*)", dna_string)
	
	valid_characters = ['A', 'C', 'T', 'G','N', 'a', 'c', 't', 'g', 'n']
	invalid_characters = [character for character in characters if any(char not in valid_characters for char in character)]
	if (len(matches) == 0):
		if (len(invalid_characters) > 0):
			raise Exception("Invalid characters found in DNA : " + str(invalid_characters))
		elif (len(characters) != len(numbers)):
			raise Exception("Invalid format")
		else:
			for i in range(len(characters)):
				count += int(numbers[i]) * len(characters[i])
	else:
		invalid_match_characters = [match for match in matches if any(char not in valid_characters for char in match)]
		if (len(invalid_match_characters) > 0):
			raise Exception("Invalid characters found in DNA : " + str(invalid_match_characters))
		tmp_characters = characters
		tmp_numbers = numbers
		for match in matches:
			for i in range(len(numbers)):
				if (dna_string.find(match) < dna_string.find(numbers[i])):
					tmp_characters.insert(i, str(match))
					tmp_numbers.insert(i, str(1))
					break
		for i in range(len(tmp_characters)):
				count += int(tmp_numbers[i]) * len(tmp_characters[i])
	return count


if len(sys.argv) < 2:
    print("Usage: python main.py <file_to_modify>")
    sys.exit(1)

file_to_modify = sys.argv[1]

for line in fileinput.input(file_to_modify, inplace=True):
    line_list = line.split("	")
    if (len(line_list) != 7):
        raise Exception("Invalid input file format")
    else:
        dna = line_list[3]
        count = calculate(dna)
        line_list[4] = str(count)
        line_list[6] = str(count + int(line_list[5]))
        print("	".join(line_list))

