
# voter
![IMG_2842](https://user-images.githubusercontent.com/68816726/180979041-2090ae53-308a-476b-a93a-918dead1454a.jpeg)

### verilog file:
voter.v:
```
// simple verilog voter

`timescale 1ns / 1ps

module voter (
	input wire a,
	input wire b,
	input wire c,
	output wire v
	);
	
	assign v=a&b|a&c|b&c;
	
endmodule
```
voter_tb.v

testbench file:
```
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
```
### 1.在終端機中，輸入：
```
iverilog voter.v voter_tb.v
vvp a.out
```
### 2.執行完後會在資料夾中看到" voter_tb.vcd "這個檔案，右鍵選擇選擇"Open with GTKWave"

### 3.左上方點開test，點uut，左下方四個全選，再點Append

![Screenshot from 2022-07-26 18-04-57](https://user-images.githubusercontent.com/68816726/180980766-9f3b6a85-5417-4851-bb76-357e718ea304.png)

