def r_format(ins):
	operation = ins[0]
	rd = format(int(ins[1][1:]) , f'0{5}b' )
	r1 = format(int(ins[2][1:]) , f'0{5}b' )
	r2 = format(int(ins[3][1:]) , f'0{5}b' )
	# print(type(rd))
	func7 = '0000000'
	if operation=='sub' or operation=='sra':
		func7 = '0100000'
	
	r_type_func3 = {
		'add':'000',
		'sub': '000',
		'sll': '001',
		'slt': '010',
		'sltu': '011',
		'xor': '100',
		'srl': '101',
		'sra': '101',
		'or': '110',
		'and': '111' }

	opcode = '0110011'
	func3 = r_type_func3[operation]
	
	# Combine the binary values to create the full binary string
	bin_str = func7 + r2 + r1 + func3 + rd + opcode
	# Convert the binary string to a hexadecimal value
	hex_value = hex(int(bin_str,2))[2:].zfill(8)
	

	print('R format', ins)
	print(bin_str)
	print(hex_value)

	# Return a tuple containing the binary string and the hexadecimal value
	return (bin_str, hex_value)

def i_format(ins):
	operation = ins[0]
	rd = format(int(ins[1][1:]) , f'0{5}b' )
	r1 = format(int(ins[2][1:]) , f'0{5}b' )
	imm = format(int(ins[3]) , f'0{12}b' )

	i_type_func3 = {
		'addi': '000',
		'slti': '010',
		'sltiu': '011',
		'xori': '100',
		'ori': '110',
		'andi': '111'
		}

	opcode = '0010011'
	func3 = i_type_func3[operation]
	
	# Combine the binary values to create the full binary string
	bin_str = imm +  r1 + func3 + rd + opcode
	# Convert the binary string to a hexadecimal value
	hex_value = hex(int(bin_str,2))[2:].zfill(8)
	

	print('I format', ins)
	print(bin_str)
	print(hex_value)

	# Return a tuple containing the binary string and the hexadecimal value
	return (bin_str, hex_value)

def i2_format(ins):
	operation = ins[0]
	rd = format(int(ins[1][1:]) , f'0{5}b' )
	r1 = format(int(ins[2][1:]) , f'0{5}b' )
	
	# print(type(rd))
	func7 = '0100000'
	if operation=='slli':
		func7 = '0000000'
	
	i2_type_func3 = {
		'slli':'001',
		'srli': '101',
		'srai': '101'
		}

	opcode = '0010011'
	func3 = i2_type_func3[operation]
	shamt = '00000'

	# Combine the binary values to create the full binary string
	bin_str = func7 + shamt + r1 + func3 + rd + opcode
	# Convert the binary string to a hexadecimal value
	hex_value = hex(int(bin_str,2))[2:].zfill(8)
	

	print('I2 format',ins)
	print(bin_str)
	print(hex_value)

	# Return a tuple containing the binary string and the hexadecimal value
	return (bin_str, hex_value)


def s_format(ins):
	## sb rs2, offset(rs1)
	operation = ins[0]
	r1 = format(int(ins[3][1:]) , f'0{5}b' )
	r2 = format(int(ins[1][1:]) , f'0{5}b' )
	imm = format(int(ins[2]) , f'0{12}b' )

	s_type_func3 = {
		'sb': '000',
		'sh': '001',
		'sw': '010'	
	}

	opcode = '0100011'
	func3 = s_type_func3[operation]

	# Combine the binary values to create the full binary string
	bin_str = imm[:7] +  r2 + r1 + func3 + imm[7:] + opcode
	# Convert the binary string to a hexadecimal value
	hex_value = hex(int(bin_str,2))[2:].zfill(8)
	

	print('S format',ins)
	print(bin_str)
	print(hex_value)

	# Return a tuple containing the binary string and the hexadecimal value
	return (bin_str, hex_value)


def l_format(ins):
	operation = ins[0]
	rd = format(int(ins[1][1:]) , f'0{5}b' )
	r1 = format(int(ins[3][1:]) , f'0{5}b' )
	imm = format(int(ins[2]) , f'0{12}b' )

	l_type_func3 = {
		'lb': '000',
		'ls': '001',
		'lw': '010',
		'lbu': '100',
		'lhu': '101'
		}

	opcode = '0010011'
	func3 = l_type_func3[operation]
	
	# Combine the binary values to create the full binary string
	bin_str = imm +  r1 + func3 + rd + opcode
	# Convert the binary string to a hexadecimal value
	hex_value = hex(int(bin_str,2))[2:].zfill(8)
	

	print('L format',ins)
	print(bin_str)
	print(hex_value)

	# Return a tuple containing the binary string and the hexadecimal value
	return (bin_str, hex_value)


def b_format(ins):
	operation = ins[0]
	r1 = format(int(ins[1][1:]) , f'0{5}b' )
	r2 = format(int(ins[2][1:]) , f'0{5}b' )
	imm = format(int(ins[3]) , f'0{12}b' )

	b_type_func3 = {
		'beq': '000',
		'bne':'001',
		'blt': '100',
		'bge': '101',
		'bltu':'110',
		'bgeu': '111'
		}

	opcode = '1100011'
	func3 = b_type_func3[operation]
	
	# print(imm[0] , imm[2:8] ,  r2 , r1 , func3 , imm[8:] , imm[1] , opcode)

	# Combine the binary values to create the full binary string
	bin_str = imm[0] + imm[2:8] +  r2 + r1 + func3 + imm[8:] + imm[1] + opcode
	# Convert the binary string to a hexadecimal value
	hex_value = hex(int(bin_str,2))[2:].zfill(8)
	

	print('B format',ins)
	print(bin_str)
	print(hex_value)

	# Return a tuple containing the binary string and the hexadecimal value
	return (bin_str, hex_value)


def u_format(ins):
	operation = ins[0]
	rd = format(int(ins[1][1:]) , f'0{5}b' )
	imm = format(int(ins[2]) , f'0{20}b' )
	

	opcode = '0110111'
	if operation=='auipc':
		opcode = '0010111'
	
	# Combine the binary values to create the full binary string
	bin_str = imm + rd + opcode
	# Convert the binary string to a hexadecimal value
	hex_value = hex(int(bin_str,2))[2:].zfill(8)
	

	print('U format', ins)
	print(bin_str)
	print(hex_value)

	# Return a tuple containing the binary string and the hexadecimal value
	return (bin_str, hex_value)


def j_format(ins):
	operation = ins[0]
	rd = format(int(ins[1][1:]) , f'0{5}b' )
	imm = format(int(ins[2]) , f'0{20}b' )
	

	opcode = '1101111'

	# Combine the binary values to create the full binary string
	bin_str = imm[0] + imm[10:20] + imm[9] + imm[1:9] + rd + opcode
	# Convert the binary string to a hexadecimal value
	hex_value = hex(int(bin_str,2))[2:].zfill(8)
	

	print('J format',ins)
	print(bin_str)
	print(hex_value)

	# Return a tuple containing the binary string and the hexadecimal value
	return (bin_str, hex_value)


def j2_format(ins):
	 # Extract operation from the instruction
	operation = ins[0]
	# Convert and format rd, r1, and imm to binary with specified bit widths
	rd = format(int(ins[1][1:]) , f'0{5}b' )
	r1 = format(int(ins[3][1:]) , f'0{5}b' )
	imm = format(int(ins[2]) , f'0{12}b' )


	opcode = '1100111'
	func3 = '000'
	
	# Combine the binary values to create the full binary string
	bin_str = imm +  r1 + func3 + rd + opcode

	# Convert the binary string to a hexadecimal value
	hex_value = hex(int(bin_str,2))[2:].zfill(8)
	

	print('J2 format',ins)
	print(bin_str)
	print(hex_value)

	# Return a tuple containing the binary string and the hexadecimal value
	return (bin_str, hex_value)

