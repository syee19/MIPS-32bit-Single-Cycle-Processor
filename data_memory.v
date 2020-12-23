module data_memory(clk, MemWrite, MemRead, addr, write_data_dm, read_data_dm);
	input clk;
	input wire MemWrite, MemRead; // control signal
	input wire [31:0] addr;
	input wire [31:0] write_data_dm;
	output reg [31:0] read_data_dm;
	
	reg [31:0] mem [63:0]; 
		
	initial begin
		$readmemb("memory.mem", mem);
	end
	
	always @(*)
	begin
		if(MemWrite == 0 && MemRead == 1) // lw
			read_data_dm = mem[addr][31:0]; 
		else
			read_data_dm = read_data_dm; // To avoid creating a latch
	end
	
	always @(posedge clk)
	begin
		if(MemWrite == 1 && MemRead == 0) // sw
			mem[addr][31:0] <= write_data_dm;
	end
endmodule