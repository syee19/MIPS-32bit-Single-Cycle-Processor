module registers(clk, RegWrite, read_reg_1, read_reg_2, write_reg, write_data, read_data_1, read_data_2);
	
	input wire clk;
	input wire RegWrite; // control signal
	input wire [4:0] read_reg_1, read_reg_2, write_reg;
	input wire [31:0] write_data;
	output reg [31:0] read_data_1, read_data_2; 
	
	reg [31:0] mem [31:0];  // 32-bit memory with 32 entries
	
	initial 
	begin
		mem[0] = 32'd0; // $zero = 0;
	end
	
	always @(posedge clk) 
	begin
		if (read_reg_1 == 5'd0) // $zero
			read_data_1 = 32'd0;
		else
			read_data_1 = mem[read_reg_1][31:0];
	end
	
	always @(posedge clk)
	begin
		if (read_reg_2 == 5'd0) // $zero
			read_data_2 = 32'd0;
		else
			read_data_2 = mem[read_reg_2][31:0];
	end
	
	always @(posedge clk) 
	begin
		if (RegWrite && write_reg != 5'd0) // $zero can not be changed.
		begin
			// write a non $zero register
			mem[write_reg] <= write_data;
		end
	end
endmodule