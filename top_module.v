module top_module(clk, rst, seg0, seg1, seg2, seg3, seg4, seg5);
	input clk, rst;
	output [6:0] seg0, seg1, seg2, seg3, seg4, seg5;

	wire out_clk;
	wire [23:0] digit;
	
	clk_dll u0(rst, clk, out_clk);
	MIPS u1(rst, out_clk, digit);
	seg7 s5(digit[23:20], seg5);	
	seg7 s4(digit[19:16], seg4);
	seg7 s3(digit[15:12], seg3);
	seg7 s2(digit[11:8], seg2);
	seg7 s1(digit[7:4], seg1);
	seg7 s0(digit[3:0], seg0);
endmodule
