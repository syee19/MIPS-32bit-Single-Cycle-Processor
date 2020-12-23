module control(Opcode, RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);

	input wire [5:0] Opcode;
	
	output reg RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite; 
	output reg [1:0] ALUOp;
	initial
	begin
		RegWrite = 0; RegDst = 0; ALUSrc = 0; Branch = 0; MemWrite = 0; MemRead = 0; MemtoReg = 0; Jump = 0;
		ALUOp = 2'b00; 
	end

	always @(Opcode)
	begin
		case(Opcode)
		6'b000000 : begin // R Type - add, sub, and, or, slt
			RegWrite = 1; RegDst = 1; ALUSrc = 0; Branch = 0; MemWrite = 0; MemRead = 0; MemtoReg = 0; Jump = 0;
			ALUOp = 2'b10;
		end
		6'b100011 : begin // Load Word
			RegWrite = 1; RegDst = 0; ALUSrc = 1; Branch = 0; MemWrite = 0; MemRead = 1; MemtoReg = 1; Jump = 0;
			ALUOp = 2'b00; // add for lw
		end
		6'b101011 : begin // Store Word
			RegWrite = 0; RegDst = 0; ALUSrc = 1; Branch = 0; MemWrite = 1; MemRead = 0; MemtoReg = 0; Jump = 0;
			ALUOp = 2'b00; // add for sw
		end
		6'b000100 : begin // Beq
			RegWrite = 0; RegDst = 0; ALUSrc = 0; Branch = 1; MemWrite = 0; MemRead = 0; MemtoReg = 0; Jump = 0;
			ALUOp = 2'b01; // sub for beq
		end
		6'b001000 : begin // addi
			RegWrite = 1; RegDst = 0; ALUSrc = 1; Branch = 0; MemWrite = 0; MemRead = 0; MemtoReg = 0; Jump = 0;
			ALUOp = 2'b00;
		end
		6'b001101 : begin // ori
			RegWrite = 1; RegDst = 0; ALUSrc = 1; Branch = 0; MemWrite = 0; MemRead = 0; MemtoReg = 0; Jump = 0;
			ALUOp = 2'b11; // 내 맘대로 00에서 11로 바꿨음 보고서에 쓰기

		end
		6'b000010 : begin// Jump
			RegWrite = 0; RegDst = 0; ALUSrc = 0; Branch = 0; MemWrite = 0; MemRead = 0; MemtoReg = 0; Jump = 1;
			ALUOp = 2'b00;
		end
		default : begin // To avoid creating a latch
			RegWrite = 0; RegDst = 0; ALUSrc = 0; Branch = 0; MemWrite = 0; MemRead = 0; MemtoReg = 0; Jump = 0;
			ALUOp = 2'b00; 
		end
		endcase
	end
	
	
endmodule