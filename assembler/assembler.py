import sys
import os 
import shutil
import re
from formatins import r_format, i_format,i2_format, s_format, l_format, b_format, u_format, j_format, j2_format

# instuction type
ins_types = {}


args = {'input_file': '', 'output_file': '' }

argKeys = {'-i': 'input_file' , '-o': 'output_file'}


r_type = ['add','sub','sll','slt','sltu','xor','srl','sra','or','and']
i_type = ['addi' ,'slti', 'sltiu' ,'xori', 'ori', 'andi']
i2_type =[ 'slli','srli', 'srai']
s_type = ['sb' , 'sh' , 'sw']
l_type = ['lb' , 'lh' , 'lw', 'lbu', 'lhu']
b_type = ['beq','bne','blt','bge','bltu','bgeu']
u_type = ['lui' , 'auipc']
j_type = ['jal']
j2_type = ['jalr']
ins_types = { 'r': r_type , 'i':i_type , 'i2':i2_type, 's':s_type ,'l':l_type, 'b':b_type , 'u': u_type, 'j':j_type , 'j2':j2_type}


labels = {}
labels_counter = 0
typed_ins = []
hex_ins = []

def handleArgs():
	n = len(sys.argv)
	for i in range(1,n):
		if(sys.argv[i].strip() in argKeys):
			# TODO
			# handle wrong inputs

			# load the inputfile and output file
			args[argKeys[sys.argv[i]]] = sys.argv[i+1]


def readfile():
	global instructions
	try:
		with open(args['input_file'], 'r') as file: 
			## remove the empty line and add to the instructions array
			instructions = [line.strip() for line in file if line.strip()]
	except FileNotFoundError:
		print(f"The file '{args['input_file']}' was not found.")
	except Exception as e:
	    print(f"An error occurred: {str(e)}")

	# for line in instructions:
	# 	print(line)


def type_assigning():
	for i, ins in enumerate(instructions):
		# split the instrction line by space and the comma
		ins_parts_with_empty = re.split(r'[,()\s]+', ins)
		ins_parts = [part for part in ins_parts_with_empty if part ]
		# print(ins_parts)
		type_assigned = False

		for t, value in ins_types.items():
			if ins_parts[0] in value:
				typed_ins.append((t,ins_parts)) # store the instruction with type
				type_assigned = True
				break
		

		global labels_counter
		# TODO: 
		### error detection in labels/non labels
		if type_assigned== False:
			if ins_parts[0][-1] == ':':
				label = ins_parts[0][:-1]
				labels[label] = i - labels_counter
				labels_counter +=1
			else:
				print('Error in instructions', ins_parts)



	# print("typed instructions: ",typed_ins)
	# print("labels: " , labels)		




def code_generation():

	for t_ins in typed_ins:
		ins_type = t_ins[0]
		# print(t_ins , end=' ')
		ins = t_ins[1]

		if ins_type == 'r':
			hex_ins.append(r_format(ins))
		elif ins_type == 'i':
			hex_ins.append(i_format(ins))
		elif ins_type == 'i2':
			hex_ins.append(i2_format(ins))
		elif ins_type == 's':
			hex_ins.append(s_format(ins))
		elif ins_type == 'l':
			hex_ins.append(l_format(ins))
		elif ins_type == 'b':
			# TODO:
			## handle non existing labels
			try:
				int(ins[-1])
			except Exception:
				label = ins[-1]
				ins[-1] = labels[label] # replace the label with the address
			hex_ins.append(b_format(ins))
		elif ins_type == 'u':
			u_format(ins)
		elif ins_type == 'j':
			try:
				int(ins[-1])
			except Exception:
				label = ins[-1]
				ins[-1] = labels[label] # replace the label with the address
			hex_ins.append(j_format(ins))
		elif ins_type == 'j2':
			try:
				int(ins[2])
			except Exception:
				label = ins[1]
				ins[-1] = labels[label] # replace the label with the address
			hex_ins.append(j2_format(ins))


def write_file():
	hex_file = args['output_file'] + '.hex'
	bin_file = args['output_file'] + '.bin'
	with open(hex_file, 'w') as file:
		for value in hex_ins:
			file.write('0x'+value[1]+'\n')
	with open(bin_file, 'w') as file:
		for value in hex_ins:
			file.write(value[0]+'\n')

handleArgs()
readfile()
type_assigning()
code_generation()
write_file()



