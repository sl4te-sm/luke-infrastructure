import sys

if len(sys.argv) != 2:
    print("Usage: python script.py <input_file>")
    sys.exit(1)
# Define the input and output file paths
input_file = sys.argv[1]

# Open the input file for reading and the output file for writing
with open(input_file, 'r') as file:
    lines = file.readlines()

# Remove leading and trailing blank lines
while lines and lines[0].strip() == '':
    lines.pop(0)
while lines and lines[-1].strip() == '':
    lines.pop()

with open(input_file, 'w') as file:
    for line in lines:
        # Strip trailing whitespace from each line
        stripped_line = line.rstrip()
        # Write the modified line to the output file
        file.write(stripped_line + '\n')

print(f"Trailing whitespace removed from '{input_file}'!")
