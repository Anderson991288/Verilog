## Primes

### primes.v
```
module primes (
    
    input wire [3:0] x, // input data (4 bits)
    output reg z        // output. 0-no prime, 1-prime
    );

   
    always @* begin
       
        case(x)         /* expression to test */
        2:  z = 1;      /* action in case the value is "2" */
        3:  z = 1;      /* etc. */
        5:  z = 1;
        7:  z = 1;
        11: z = 1;
        13: z = 1;
        default: z = 0; 
    end

endmodule 
```



### testbench file 
### primes_tb.v:
```

`timescale 1ns / 1ps

// Base time to easy test pattern specification
`define BTIME 10

module test ();

    // Input
  
    reg [3:0] x;

    // Outputs
    wire z;

    // UUT instance

    primes uut (.x(x), .z(z));

    initial begin
        // Input initialization
        x = 4'b0000;
      

        // Waveform generation
        $dumpfile("primes_tb.vcd");
        $dumpvars(0,test);

        // Text output generation
      
        $display("x   z");          // header
        $display("-----");
        $monitor("%d  %b", x, z);

        // Simulation ends
      
        #(16*`BTIME) $finish;
    end

    // Input test pattern generation
   
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


