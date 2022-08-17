## hazard

hazard.v
```
`timescale 1ns / 1ps

//
// Functional description
//
module hazard_f (
    input wire a,
    input wire b,
    output wire f
    );

    assign f = ~a & b | a & b;

endmodule // hazard_f

//
// Structural description
//
module hazard_e #(

    parameter delay = 5	
    )(
    input wire a,
    input wire b,
    output wire f
    );

    /* Parameters can also be defined in the body of the module description
     * (Verilog 1995 style) but they are much easier to locate if defined
     * with the module declaration as we did (Verilog 2001 style). */
    // parameter delay = 5;

    // Internal signals
    wire x, y, z;

   
    not #delay inv(x, a);
    and #delay and1(y, a, b);
    and #delay and2(z, x, b);
    or #delay or1(f, y, z);

endmodule // hazard_e

```
hazard_tb.v
```
`timescale 1ns / 1ps


`ifndef DELAY
    `define DELAY 2
`endif

`define BTIME 8 * `DELAY


module test();

	// Inputs
	reg a;
	reg b;

	// Output
	wire f1, f2;

   
    integer n = 0;
  


    hazard_f uut1 (.a(a), .b(b), .f(f1));
    hazard_e #(.delay(`DELAY)) uut2 (.a(a), .b(b), .f(f2));

	// Test pattern initialization and simulation control
	initial begin
		// Input initialization
		a = 0;
		b = 0;

		// Waveform output
		$dumpfile("hazard_tb.vcd");
		$dumpvars(0,test);

		// Simulation end
		
		#(7*`BTIME) $finish;
	end

   
    // 'a' changes between '0' and '1'. 'n' counts the number of changes.
    always
    begin
        #(`BTIME) a = ~a;
        n = n + 1;
    end

    always @(a)
        if (n != 3)
            #(`BTIME/2) b = ~b;
endmodule
```
### 1.在終端機中，輸入：
```
iverilog alarm_tb.v alarm.v
vvp a.out
```
### 2.執行完後會在資料夾中看到" hazard_tb.vcd "這個檔案，右鍵選擇選擇"Open with GTKWave"

### 3.左上方點開test，點uut1/uut2，左下方四個全選，再點Append

![Screenshot from 2022-08-09 22-19-55](https://user-images.githubusercontent.com/68816726/183674074-c4f73e26-9a7b-4f1a-b0e1-022dfbf96dd9.png)
