module alu_mips(a, b, control, outalu, zero);
input [31:0] a, b;
input [3:0] control;
output reg [31:0] outalu;
output zero;

always@(control, a, b)
begin
	case(control)
		0 : outalu=a&b; // and
		1 : outalu= a|b; // or
		2 : outalu=a+b; // add
		6 : outalu=a-b; // sub
		7 : outalu=a<b?1:0; // set on less than
		12 : outalu=~(a|b); //nor
		default : outalu=0;
	endcase
end

assign zero=outalu==0?1:0;

endmodule
