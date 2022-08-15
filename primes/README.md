## Primes

### primes.v
```
module primes (
    
    input wire [3:0] x, // input data (4 bits)
    output reg z        // output. 0-no prime, 1-prime
    );

    /* We use a procedural description for the circuit */
    always @* begin
        /* With the 'case' sentence we can execute a different operation
         * depending on the value of a variable or expression. In our case,
         * it is specially convenient since the output only depends on "x".*/
        case(x)         /* expression to test */
        2:  z = 1;      /* action in case the value is "2" */
        3:  z = 1;      /* etc. */
        5:  z = 1;
        7:  z = 1;
        11: z = 1;
        13: z = 1;
        default: z = 0; /* action in any other case
                         * Note that a combinational circuit should always
                         * generate an output value for any input value, so
                         * the 'default' is necessary in most cases when a
                         * 'case' statement to describe combinational
                         * behavior. */
        endcase
    end

endmodule 
```



### testbench file 
### primes_tb.v:
```
// Design:      primes
// File:        primes.v
// Description: Prime number detector
// Author:       Jorge Juan-Chico <jjchico@gmail.com>
// Date:        09/11/2018 (initial version)

/*
   Lesson 3.2: 4-bit prime number detector.

   This file contains a test bench for module 'primes'.
*/

`timescale 1ns / 1ps

// Base time to easy test pattern specification
`define BTIME 10

module test ();

    // Input
    /* The signal that generates the inputs to our circuit is a 4-bit 
     * variable. */
    reg [3:0] x;

    // Outputs
    wire z;

    // UUT instance
    /* Multi-bit signals are connected like bit signals */
    primes uut (.x(x), .z(z));

    /* The 'initial' process below initializes the test patterns and includes
       the simulation directives. */
    initial begin
        // Input initialization
        x = 4'b0000;
        /* 'x' is initialized to zero by using the zero value in binary
           indicating explicitly that it is a 4-bit signal. The complete 
           format for literal numbers in Verilog is:
         *   <number of bits>'<base><value>
         * where <base> may be, among others:
         *   b: binary
         *   o: octal
         *   h: hexadecimal
         *   d: decimal
         * If <base> is omitted, it is considered decimal. If the number of
         * bits is omitted, the value includes at least 32 bits, but it is 
         * automatically extended if necessary to complete the operations.
         * In general, if the number of bits is known in advance, it is
         * recommended to make it explicit in constants.
         * Alternatively, 'x' could have been initialized like:
         *   x = 4'h00      // hexadecimal
         *   x = 'b0000     // binary, number of bits omitted
         *   x = 0          // base and number of bits omitted. It is assumed
         *                  // a decimal zero with enough bits to assign all
         *                  // the bit of 'x' to zero.
         */

        // Waveform generation
        $dumpfile("primes_tb.vcd");
        $dumpvars(0,test);

        // Text output generation
        /* In this design, the text output is very convenient because it is
         * faster and easier to check than by looking at the detailed signal
         * waveforms. */
        $display("x   z");          // header
        $display("-----");
        $monitor("%d  %b", x, z);

        // Simulation ends
        /* Simulation end time is programmed as a function of 'BTIME'. The
         * value 16*`BTIME is enough for the inputs to go through all possible
         * values. */
        #(16*`BTIME) $finish;
    end

    // Input test pattern generation
    /* To make the input signal to go through all possible values we just 
     * increment 'x' every `BTIME nanoseconds. Multi-bit variables can be
     * used as regular integer variables and can be opperated with arithmetic
     * operators as expected. */
    always
        #(`BTIME) x = x + 1;

endmodule // test
```

### Open terminal and compile:
```
iverilog primes.v primes_tb.v
vvp a.out
```

![Screenshot from 2022-08-08 22-31-41](https://user-images.githubusercontent.com/68816726/183443971-17a02228-1e72-4925-9f6e-58f29d6a3232.png)


