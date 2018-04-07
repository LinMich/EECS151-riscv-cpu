.section    .start
.global     _start

_start:

# Follow a convention
# x1 = result register 1
# x2 = result register 2
# x10 = argument 1 register
# x11 = argument 2 register
# x20 = flag register

# Test U-type:
# Test LUI 
#lui x1, 32	# Execute the instruction being tested
#li x19, 1		# Set the flag register to stop execution and inspect the result register
			# Now we check that x1 contains 300

#li x15, 10
# addi x10, x15, 20
# addi x11, x10, 20
# li x18, 1

# Test AUIPC 
#li x10, 200		# Load argument 1 (rs1)
#li x11, 100		# Load argument 2 (rs2)
#auipc x1, x10, x11	# Execute the instruction being tested
#li x20, 1		# Set the flag register to stop execution and inspect the result register
			# Now we check that x1 contains 100





# Test J-type:
# Test JAL 
#li x10, 100		# Load argument 1 (rs1)
#li x11, 200		# Load argument 2 (rs2)
#jal x1, x10, x11	# Execute the instruction being tested
#li x20, 1		# Set the flag register to stop execution and inspect the result register
			# Now we check that x1 contains 300






# Test I-type:
# Test JALR 
#li x10, 5		# Load argument 1 (rs1)
#jalr x0, x10, 0	# Execute the instruction being tested
#li x20, 1		# Set the flag register to stop execution and inspect the result register
			# Now we check that x1 contains 0

# Test LB 
#li x10, 200		# Load argument 1 (rs1)
#lb x1, x10, 0x0	# Execute the instruction being tested
#li x20, 1		# Set the flag register to stop execution and inspect the result register
			# Now we check that x1 contains 100

# Test LH 
#li x10, 100		# Load argument 1 (rs1)
#lh x1, x10, 0x0	# Execute the instruction being tested
#li x20, 1		# Set the flag register to stop execution and inspect the result register
			# Now we check that x1 contains 300

# Test LW 
#li x10, 200		# Load argument 1 (rs1)
#li x11, 100		# Load argument 2 (rs2)
#lw x1, x10, x11	# Execute the instruction being tested
#li x20, 1		# Set the flag register to stop execution and inspect the result register
			# Now we check that x1 contains 100
			
# Test LBU 
#li x10, 2		# Load argument 1 (rs1)
#lbu x1, x10, 0x1	# Execute the instruction being tested
#li x20, 1		# Set the flag register to stop execution and inspect the result register
			# Now we check that x1 contains 4
			
# Test LHU 
#li x10, 4		# Load argument 1 (rs1)
#lhu x1, x10, 0x1	# Execute the instruction being tested
#li x20, 1		# Set the flag register to stop execution and inspect the result register
			# Now we check that x1 contains 2

# Test ADDI
li x11, 2047		# Load argument 1 (rs1)
addi x2, x11, 0x1	# Execute the instruction being tested
li x20, 1		# Set the flag register to stop execution and inspect the result register
			# Now we check that x1 contains 2048

# Test SLTI
# li x20, 0 
li x10, 2050		# Load argument 1 (rs1)
slti x1, x10, 2046	# Execute the instruction being tested
li x21, 1		# Set the flag register to stop execution and inspect the result register
			# Now we check that x1 contains 1

# li x20, 0
li x10, 0x7ff		# Load argument 1 (rs1)
slti x1, x10, 0x7ff	# Execute the instruction being tested
li x22, 1		# Set the flag register to stop execution and inspect the result register
			# Now we check that x1 contains 0

# Test SLTIU
# li x20, 0 
li x10, 0b111111111111		# Load argument 1 (rs1)
sltiu x1, x10, 0b000000000000	# Execute the instruction being tested
li x23, 1		# Set the flag register to stop execution and inspect the result register
			# Now we check that x1 contains 0

# li x20, 0
li x10, 0b000000000000		# Load argument 1 (rs1)
sltiu x1, x10, 0b000000000001	# Execute the instruction being tested
li x24, 1		# Set the flag register to stop execution and inspect the result register
			# Now we check that x1 contains 1	

# Test XORI
# li x20, 0 
li x10, 2047		# Load argument 1 (rs1)
xori x1, x10, 1	# Execute the instruction being tested
li x25, 1		# Set the flag register to stop execution and inspect the result register
# 			# Now we check that x1 contains 2046
			
# # Test ANDI 
# li x20, 0
li x10, 2047		# Load argument 1 (rs1)
andi x1, x10, 0x1	# Execute the instruction being tested
li x26, 1		# Set the flag register to stop execution and inspect the result register
# 			# Now we check that x1 contains 1

# # Test SLLI
# li x20, 0 
li x10, 2		# Load argument 1 (rs1)
slli x1, x10, 0x1	# Execute the instruction being tested
li x27, 1		# Set the flag register to stop execution and inspect the result register
# 			# Now we check that x1 contains 4
			
# # Test SRLI
# li x20, 0 
li x10, 4		# Load argument 1 (rs1)
srli x1, x10, 0x1	# Execute the instruction being tested
li x28, 1		# Set the flag register to stop execution and inspect the result register
# 			# Now we check that x1 contains 2

# # Test SRAI 
# li x20, 0
li x10, 0X80000001		# Load argument 1 (rs1)
srai x1, x10, 1	# Execute the instruction being tested
li x29, 1		# Set the flag register to stop execution and inspect the result register
# 			# Now we check that x1 contains 0xC0000001




# # # Test B-type:
# # # Test BEQ 
# # #li x10, 100		# Load argument 1 (rs1)
# # #li x11, 200		# Load argument 2 (rs2)
# # #beq x1, x10, x11	# Execute the instruction being tested
# # #li x20, 1		# Set the flag register to stop execution and inspect the result register
# # 			# Now we check that x1 contains 300

# # # Test BNE 
# # #li x10, 200		# Load argument 1 (rs1)
# # #li x11, 100		# Load argument 2 (rs2)
# # #bne x1, x10, x11	# Execute the instruction being tested
# # #li x20, 1		# Set the flag register to stop execution and inspect the result register
# # 			# Now we check that x1 contains 100

# # # Test BLT 
# # #li x10, 100		# Load argument 1 (rs1)
# # #li x11, 200		# Load argument 2 (rs2)
# # #blt x1, x10, x11	# Execute the instruction being tested
# # #li x20, 1		# Set the flag register to stop execution and inspect the result register
# # 			# Now we check that x1 contains 300

# # # Test BGE 
# # #li x10, 200		# Load argument 1 (rs1)
# # #li x11, 100		# Load argument 2 (rs2)
# # #bge x1, x10, x11	# Execute the instruction being tested
# # #li x20, 1		# Set the flag register to stop execution and inspect the result register
# # 			# Now we check that x1 contains 100
			
# # # Test BLTU 
# # #li x10, 2		# Load argument 1 (rs1)
# # #bltu x1, x10, 0x1	# Execute the instruction being tested
# # #li x20, 1		# Set the flag register to stop execution and inspect the result register
# # 			# Now we check that x1 contains 4
			
# # # Test BGEU 
# # #li x10, 4		# Load argument 1 (rs1)
# # #bgeu x1, x10, 0x1	# Execute the instruction being tested
# # #li x20, 1		# Set the flag register to stop execution and inspect the result register
# # 			# Now we check that x1 contains 2





# # # Test S-type:
# # # Test SB 
# # li x10, 100		# Load argument 1 (rs1)
# # li x11, 200		# Load argument 2 (rs2)
# # sb x1, x10, x11	# Execute the instruction being tested
# # li x20, 1		# Set the flag register to stop execution and inspect the result register
# # 			# Now we check that x1 contains 300

# # # Test SH 
# # li x10, 200		# Load argument 1 (rs1)
# # li x11, 100		# Load argument 2 (rs2)
# # sh x1, x10, x11	# Execute the instruction being tested
# # li x20, 1		# Set the flag register to stop execution and inspect the result register
# # 			# Now we check that x1 contains 100

# # # Test SW 
# # li x10, 100		# Load argument 1 (rs1)
# # li x11, 200		# Load argument 2 (rs2)
# # sw x1, x10, x11	# Execute the instruction being tested
# # li x20, 1		# Set the flag register to stop execution and inspect the result register
# # 			# Now we check that x1 contains 300





# # # Test R-type:
# # # Test ADD 
# # li x20, 0
# li x10, 100		# Load argument 1 (rs1)
# li x11, 200		# Load argument 2 (rs2)
# add x1, x10, x11	# Execute the instruction being tested
# li x30, 1		# Set the flag register to stop execution and inspect the result register
# 			# Now we check that x1 contains 300

# # # Test SUB 
# # li x20, 0
# li x10, 200		# Load argument 1 (rs1)
# li x11, 100		# Load argument 2 (rs2)
# sub x1, x10, x11	# Execute the instruction being tested
# li x31, 1		# Set the flag register to stop execution and inspect the result register
# 			# Now we check that x1 contains 100

# # # Test SLL 
# li x20, 0
# li x10, 2		# Load argument 1 (rs1)
# li x11, 1		# Load argument 2 (rs2)
# sll x1, x10, x11	# Execute the instruction being tested
# li x20, 1		# Set the flag register to stop execution and inspect the result register
# 			# Now we check that x1 contains 4

# # Test SLT 
# li x20, 0
# li x10, 0x80000000		# Load argument 1 (rs1)
# li x11, 0x7FFFFFFF		# Load argument 2 (rs2)
# slt x1, x10, x11	# Execute the instruction being tested
# li x20, 1		# Set the flag register to stop execution and inspect the result register
# 			# Now we check that x1 contains 1

# li x20, 0
# li x10, 0x7FFFFFFF		# Load argument 1 (rs1)
# li x11, 0x80000000		# Load argument 2 (rs2)
# slt x1, x10, x11	# Execute the instruction being tested
# li x20, 1		# Set the flag register to stop execution and inspect the result register
# 			# Now we check that x1 contains 0

# # Test SLTU 
# li x20, 0
# li x10, 0x80000000		# Load argument 1 (rs1)
# li x11, 0x7FFFFFFF		# Load argument 2 (rs2)
# slt x1, x10, x11	# Execute the instruction being tested
# li x20, 1		# Set the flag register to stop execution and inspect the result register
# 			# Now we check that x1 contains 0

# li x20, 0
# li x10, 0x7FFFFFFF		# Load argument 1 (rs1)
# li x11, 0x80000000		# Load argument 2 (rs2)
# slt x1, x10, x11	# Execute the instruction being tested
# li x20, 1		# Set the flag register to stop execution and inspect the result register
# 			# Now we check that x1 contains 1

# # Test XOR 
# li x20, 0
# li x10, 2		# Load argument 1 (rs1)
# li x11, 4		# Load argument 2 (rs2)
# xor x1, x10, x11	# Execute the instruction being tested
# li x20, 1		# Set the flag register to stop execution and inspect the result register
# 			# Now we check that x1 contains 6

# # Test SRL 
# li x20, 0
# li x10, 4		# Load argument 1 (rs1)
# li x11, 1		# Load argument 2 (rs2)
# srl x1, x10, x11	# Execute the instruction being tested
# li x20, 1		# Set the flag register to stop execution and inspect the result register
# 			# Now we check that x1 contains 2

# # Test SRA 
# li x20, 0
# li x10, 0X80000001		# Load argument 1 (rs1)
# li x11, 1		# Load argument 2 (rs2)
# sra x1, x10, x11	# Execute the instruction being tested
# li x20, 1		# Set the flag register to stop execution and inspect the result register
# 			# Now we check that x1 contains 0xC0000001

# # Test OR 
# li x20, 0
# li x10, 128		# Load argument 1 (rs1)
# li x11, 256		# Load argument 2 (rs2)
# or x1, x10, x11	# Execute the instruction being tested
# li x20, 1		# Set the flag register to stop execution and inspect the result register
# 			# Now we check that x1 contains 384

# # Test AND
# li x20, 0 
# li x10, 2047		# Load argument 1 (rs1)
# li x11, 2046		# Load argument 2 (rs2)
# and x1, x10, x11	# Execute the instruction being tested
# li x20, 1		# Set the flag register to stop execution and inspect the result register
# 			# Now we check that x1 contains 2046


Done: j Done

