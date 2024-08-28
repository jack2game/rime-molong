import sys
import re

def find_number_in_string(s):
	# Search for a number in the string
	match = re.search(r'\d+', s)
	if match:
		# Return the number found as an integer
		return int(match.group())
	else:
		# Return None if no number is found
		return None

def load_data(file_path):
	data = []
	with open(file_path, 'r', encoding='utf-8') as file:
		for line in file:
			parts = line.strip()
			data.append(parts)
	return data

def find_match(data, inputs):
	results = []
	for line in data:
		parts = line.split('\t')
		chinese_chars = parts[0]  # Not used in the current implementation but could be useful
		targets = parts[1:]  # List of pinyin strings

		# Flag to determine if the current line is a match
		is_match = True

		for i, inputpinyin in enumerate(inputs):
			# Assume the 'inputpinyin' input has not been found in any of the targetpinyin parts
			found = False

			if inputpinyin[-1] == '-':
				inputpinyin = inputpinyin[:-1]
				# Iterate through each targetpinyin part in the 'targets' list
				for t, targetpinyin in enumerate(targets):
					inputnumber = find_number_in_string(inputpinyin)
					targetnumber = find_number_in_string(targetpinyin)

					inputpinyinpure = inputpinyin

					if inputpinyinpure == '':
							found = True
							break

					if i == t:
						if inputnumber is not None:
							if inputnumber == targetnumber:
								found = False
								break
							inputpinyinpure = inputpinyin[:-1]
						if inputpinyinpure == '':
							found = True
							continue
						if inputpinyinpure in targetpinyin:
							# If 'inputpinyinpure' is found in 'targetpinyin', set 'found' to True and break out of the loop
							found = False
							break

					elif i != t:
						if inputnumber is not None:
							if inputnumber == targetnumber:
								found = True
								continue
							inputpinyinpure = inputpinyin[:-1]
						if inputpinyinpure == '':
							found = True
							continue
						if inputpinyinpure in targetpinyin:
							# If 'inputpinyinpure' is found in 'targetpinyin', set 'found' to True and break out of the loop
							found = True
							continue

			else:
				# Iterate through each targetpinyin part in the 'targets' list
				for t, targetpinyin in enumerate(targets):
					inputnumber = find_number_in_string(inputpinyin)
					targetnumber = find_number_in_string(targetpinyin)

					inputpinyinpure = inputpinyin

					# print (i, t)
					if i == t:
						if inputnumber is not None:
							if inputnumber != targetnumber:
								found = False
								break
							inputpinyinpure = inputpinyin[:-1]
						# Check if the current 'inputpinyin' input is a substring of the current targetpinyin part
						if inputpinyinpure == '':
							found = True
							break
						elif inputpinyinpure in targetpinyin:
							# If 'inputpinyinpure' is found in 'targetpinyin', set 'found' to True and break out of the loop
							found = True
							break

			# If after checking all targetpinyin parts, 'inputpinyin' was not found
			if not found:
				# Set the match flag to False since this 'inputpinyin' input was not found
				is_match = False
				# Exit the loop as we already know this line does not match
				break

		if is_match:
			results.append(line)

	return results

def main():
	data = load_data('chengyu.txt')

	while True:
		user_input = input("Enter pinyin inputs (or type 'exit' to quit): ")
		if user_input.lower() == 'exit':
			break

		inputs = user_input.split()
		matches = find_match(data, inputs)
		if matches:
			for match in matches:
				print(match)
		else:
			print("No match found")

if __name__ == '__main__':
	main()
