//Testbench for voter

`timescale 1ns / 1ps

module test;

	reg a,b,c;
	wire v;
	
	voter uut(.a(a), .b(b),.c(c),.v(v));
	
	initial begin
	   a=0;
	   b=0;
	   c=0;
	   
	   $dumpfile("voter_tb.vcd");
	   $dumpvars(0, test);
	   
	   #10 c=1;
	   #10 b=1; c=0;
	   #10 c=1;
	   #10 a=1; b=0; c=0;
	   #10 c=1;
	   #10 b=1; c=0;
	   #10 c=1;
	   
	   #20 $finish;
	end
	   
endmodule

	   
