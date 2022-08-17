## latches

latches.v
```

`timescale 1ns / 1ps

module sra(
    input wire s,   // set (set to '1')
    input wire r,   // reset (set to '0')
    output reg q    // state (stored value)
   
    );


    always @(s, r)
        case ({s, r})

        2'b01: q <= 1'b0;
        2'b10: q <= 1'b1;
        2'b11: q <= 1'bx;
        endcase
endmodule 

module srg(
    input clk,      // clock signal
    input s,        // set (set to '1')
    input r,        // reset (set to '0')
    output reg q    // state (stored value)
    );

    always @(clk, s, r)
        if (clk == 1)
            case ({s, r})
            2'b01: q <= 1'b0;
            2'b10: q <= 1'b1;
            2'b11: q <= 1'bx;
            endcase
endmodule 

module srms (
    input wire clk,
    input wire s,
    input wire r,
    output wire q
    );

    srg master(.clk(clk), .s(s), .r(r), .q(qm));

    srg slave(.clk(clk_neg), .s(qm), .r(qm_neg), .q(q));
    assign qm_neg = ~qm;
    assign clk_neg = ~clk;

endmodule 

module srff (
    input wire clk, // clock signal
    input wire s,   // set (set to '1')
    input wire r,   // reset (set to '0')
    output reg q    // state (stored value)
    );


    always @(negedge clk)
        case ({s, r})
        2'b01: q <= 1'b0;
        2'b10: q <= 1'b1;
        2'b11: q <= 1'bx;
        endcase
endmodule

```
latches_tb.v
```
`timescale 1ns / 1ps

// Test bench

module test ();

    reg clk = 0;            // clock
    reg s = 0;              // set
    reg r = 0;              // reset
    wire qa, qg, qms, qff;  // latch outputs

    // Latch instantiation
    
    srff uut_srff(.clk(clk), .s(s), .r(r), .q(qff));

    // Simulation output and control
    initial	begin
        // Waveform generation
        $dumpfile("latches_tb.vcd");
        $dumpvars(0, test);

        // Text output
        $display("      time  clk s r   qa  qg  qms qff");
        $monitor("%d  %b   %b %b   %b   %b   %b   %b",
                   $stime, clk, s, r, qa, qg, qms, qff);

        // Control inputs
      
        #8  r = 1;    // t = 8
        #17 r = 0;    // t = 25
        #9  s = 1;    // t = 34
        #2  s = 0;    // t = 36
        #8  r = 1;    // t = 44
        #2  r = 0;    // t = 46
        #6  s = 1;    // t = 52

        #20 $finish;
    end

    // Periodic clock signal (20ns period)
    always
        #10 clk = ~clk;

endmodule
```

### 1.在終端機中，輸入：
```
iverilog latches.v latches_tb.v
vvp a.out
```
### 2.執行完後會在資料夾中看到" latches_tb.vcd "這個檔案，右鍵選擇選擇"Open with GTKWave"

### 3.左上方點開test，選擇要看的波形再點Append


![Screenshot from 2022-08-12 17-59-41](https://user-images.githubusercontent.com/68816726/184331790-e7d6d64d-bddb-450e-bed2-2c26bd3ca1f4.png)

