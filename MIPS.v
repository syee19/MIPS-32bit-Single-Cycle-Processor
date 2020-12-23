module MIPS(rst, clk, digit);
	input rst, clk;
	output[23:0] digit;

	wire [31:0] nextpc, inst, branch_addr, newpc, tempc;
	wire [31:0] pc;

	wire RegDst, RegWrite, ALUSrc, MemWrite, MemRead, MemtoReg; 
	wire [1:0] ALUOp;
	wire PCSrc, Jump, Branch; 
	wire [5:0] Opcode, Funct;

	wire [31:0] jump_addr;
	wire [4:0] read_reg_1, read_reg_2, write_reg;
	wire [31:0] sign_extend;
	wire [31:0] write_data, read_data_1, read_data_2;

	wire [31:0] ALU_in_2, ALU_result, offset;
	wire [3:0] ALU_control;
	wire zero;

	wire [31:0] addr_dm;
	wire [31:0] write_data_dm, read_data_dm;
	
	pc myPC(rst, clk, newpc, pc);
	assign nextpc = pc + 32'd4;
	
	instruction_memory  myInstructionMemory(pc, inst);
	assign Opcode = inst[31:26];
	assign Funct = inst[5:0];
	
	control myControl(Opcode, RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
	
	assign jump_addr = {nextpc[31:28], {inst[25:0], 2'b00}};
	assign read_reg_1 = inst[25:21];
	assign read_reg_2 = inst[20:16];
	assign write_reg = (RegDst) ? inst[15:11] : inst[20:16];
	
	sign_ex mySignex(inst[15:0], sign_extend);
	assign branch_addr = {sign_extend[29:0], 2'b00};
	
	registers myRegisters(clk, RegWrite, read_reg_1, read_reg_2, write_reg, write_data, read_data_1, read_data_2);
		
	assign offset = (sign_extend[31] == 1) ? {2'b11, sign_extend[31:2]} : {2'b00, sign_extend[31:2]};
	assign ALU_in_2 = (Opcode == 6'b100011 || Opcode == 6'b101011) ? offset : ((ALUSrc) ? sign_extend : read_data_2);
	
	aludec myALUControl(Funct, ALUOp, ALU_control);
	alu_mips myALU(read_data_1, ALU_in_2, ALU_control, ALU_result, zero);
	
	
	assign addr_dm = ALU_result;
	assign write_data_dm = read_data_2;
	
	data_memory myDataMemory(clk, MemWrite, MemRead, addr_dm, write_data_dm, read_data_dm);
	assign write_data = (MemtoReg) ? read_data_dm : ALU_result;
	
	assign PCSrc = (Branch && zero);
	assign tempc = (PCSrc) ? (branch_addr + nextpc) : nextpc;
	assign newpc = (Jump) ? jump_addr : tempc;

	assign digit[23:20] = pc/10;
	assign digit[19:16] = pc%10;
	assign digit[15:12] = (write_data%10000)/1000;
	assign digit[11:8] = (write_data%1000)/100;
	assign digit[7:4] = (write_data%100)/10;
	assign digit[3:0] = write_data%10;
endmodule