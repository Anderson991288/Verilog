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
    // Default delay for logic operators
    /* Parameters can be defined in a module declaration before declaring
     * the module's ports. Parameters are constants that can be used in the
     * design to make it more general or configurable. Parameters are
     * defined with a default value that can be changed with every
     * instance of the module. */
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

    // Structural description using logic gates. All the gates have the
    // same delay taken from parameter 'delay'.
    /*  Verilog allows the definition of a gate's delay using 
     * "#<delay_spec>" before the name of the instance. "<delay_spec>" may
     * have different formats:
     *         d: a number. It is the value of the delay in time units.
     *     (h,l): differentiated low-to-high (output changes to 1) 
     *            and high-to-low (output changes to 0) delays.
     *   (h,l,z): differentiated low-to-high, high-to-low and change to high
     *            impedance delays.
     * Additionally, each number can be a set of three values separated by ":"
     * meaning the minimum, typical and maximum values respectively. E.g.: 
     * '#(1:2:3,2:4:5)'.
     * In this example we use a single value. */
    not #delay inv(x, a);
    and #delay and1(y, a, b);
    and #delay and2(z, x, b);
    or #delay or1(f, y, z);

endmodule // hazard_e

```
hazard_tb.v
```
`timescale 1ns / 1ps

// Delay applied to the circuit under test
`ifndef DELAY
    `define DELAY 2
`endif
/* `ifndef es similar a `ifdef but includes the code only if the tested macro
 * has not been defined. Here we use it to define the macro `DELAY only in
 * case it has not been previously defined. This way we can override the value
 * here from a higher level file in the project or from the command line. */

// Base time to simplify test pattern definition
`define BTIME 8 * `DELAY

/* In this example, we use macros to parameterize the simulation process.
 * DELAY is the delay of the logic gates inside our circuit. BTIME is the
 * time the inputs will stay constant. BTIME is defined as a function of
 * DELAY so that it will always have a value big enough to visualize the 
 * signal propagation through all the gates of the circuit. This way, we
 * can simulate the circuit for different values of DELAY without having to
 * chande BTIME manually. */

module test();

	// Inputs
	reg a;
	reg b;

	// Output
	wire f1, f2;

    // Auxiliary simulation variable
    /* 'n' is used here as a counter to count the number of time we change
	 * signal 'a'. It will aid the pattern generation below. It is initialized
	 * to zero. The type 'integer' is equivalent to a 32-bit 'reg'. This type
	 * is useful to represent integer numbers or variables (so its name).
	 * It is similar to type 'int' in C language. */
    integer n = 0;
    /* Alternative definition of 'n' */
    /* reg [31:0] n = 0; */

	// UUT instance
	/* Instantiation of the UUT's is similar to previous examples. The
	 * "#(...)" construction is used to re-define parameters of the module.
	 * If not used, parameters will take its default values defined in the
	 * module's implementation. Parameter values can be specified implicitly
	 * in the order they where defined like "#(3, 7, 9)" or explicitly like
	 * "#(.delay(3), .width(9))". Here we use the value defined in the macro
	 * "DELAY" to select the delay for the instance */
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
		/* Simulation finishes after 7 time `BTIME which is enough to
		 * check all the interesting cases. */
		#(7*`BTIME) $finish;
	end

    /* The following 'always' processes make variables 'a' and 'b' to change 
     * from '0' to '1' and from '1' to '0' when the other variable is both 
     * '0' and '1', thus making it possible to detect any hazard that may
     * happen. */
    // 'a' changes between '0' and '1'. 'n' counts the number of changes.
    always
    begin
        #(`BTIME) a = ~a;
        n = n + 1;
    end
    // 'b' changes every time 'a' changes with a delay of BTIME/2, except
    // when 'a' has changed 3 times. This way, we go through all possible
    // cases: we test both edges of a signal for all possible values of the
    // other signal, both for 'a' and 'b'.
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

### 3.左上方點開test，點uut，左下方四個全選，再點Append

![Screenshot from 2022-08-09 22-19-55](https://user-images.githubusercontent.com/68816726/183674074-c4f73e26-9a7b-4f1a-b0e1-022dfbf96dd9.png)
