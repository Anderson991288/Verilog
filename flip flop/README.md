## flip-flop  

flip-flop.v
```
module srff (
    input wire clk, // clock
    input wire s,   // set input
    input wire r,   // reset input
    input wire cl,  // asynchronous clear
    input wire pr,  // asynchronous preset
    output reg q    // state
    );

    always @(posedge clk, negedge cl, negedge pr)
        if (!cl)
            q <= 1'b0;
        else if (!pr)
            q <= 1'b1;
        else
            case ({s, r})
            2'b01: q <= 1'b0;
            2'b10: q <= 1'b1;
            2'b11: q <= 1'bx;
            endcase
endmodule // srff

// JK flip-flop //


module jkff (
    input wire clk, // clock
    input wire j,   // input 'j'
    input wire k,   // input 'r'
    input wire cl,  // asynchronous clear
    input wire pr,  // asynchronous preset
    output reg q    // state
    );

    always @(posedge clk, negedge cl, negedge pr)
        if (!cl)
            q <= 1'b0;
        else if (!pr)
            q <= 1'b1;
        else
            case ({j, k})
            2'b01: q <= 1'b0;
            2'b10: q <= 1'b1;
            2'b11: q <= ~q;
            endcase
endmodule // jkff

// D flip-flop //


module dff (
    input wire clk, // clock
    input wire d,   // data input
    input wire cl,  // asynchronous clear
    input wire pr,  // asynchronous preset
    output reg q    // state
    );

    always @(posedge clk, negedge cl, negedge pr)
        if (!cl)
            q <= 1'b0;
        else if (!pr)
            q <= 1'b1;
        else
            q <= d;
endmodule // dff


// T flip-flop //


module tff(
    input wire clk, // clock
    input wire t,   // toggle input
    input wire cl,  // asynchronous clear
    input wire pr,  // asynchronous preset
    output reg q    // state
    );

    always @(posedge clk, negedge cl, negedge pr)
        if (!cl)
            q <= 1'b0;
        else if (!pr)
            q <= 1'b1;
        else if (t)
            q <= ~q;
endmodule // tff

```
alarm_tb.v
```
`timescale 1ns / 1ps

// Test bench

module test ();

    reg clk = 0;    // clock
    reg j = 0;      // set input (JK FF)
    reg k = 0;      // reset input (JK FF)
    reg d = 0;      // data input (D FF)
    wire s;         // set input (SR FF)
    wire r;         // reset input (SR FF)
    wire t;         // toggle input (T FF)
    reg cl = 1;     // asynchronous clear (all FF's)
    reg pr = 1;     // asynchronous preset (all FF's)
    wire qsr, qjk, qd, qt;  // flip-flops output terminals

    // Some inputs are shared by some flip-flops
    assign s = j;
    assign r = k;
    assign t = d;

    // Flip-flop instantiation
    srff uut_srff(.clk(clk), .s(s), .r(r), .cl(cl), .pr(pr), .q(qsr));
    jkff uut_jkff(.clk(clk), .j(j), .k(k), .cl(cl), .pr(pr), .q(qjk));
    dff uut_dff(.clk(clk), .d(d), .cl(cl), .pr(pr), .q(qd));
    tff uut_tff(.clk(clk), .t(t), .cl(cl), .pr(pr), .q(qt));

    // Simulation control
    initial begin
        // Waveform generation
        $dumpfile("flip-flops_tb.vcd");
        $dumpvars(0, test);

        // Simulation ends
        #180 $finish;
    end

    // Asynchronous clear and preset control
  
    initial fork
        #5   cl = 0;
        #20  cl = 1;
        #140 pr = 0;
        #160 pr = 1;
    join

    // JK and SR input control (s=j, r=k)
    initial fork
        #20  j = 1;
        #40  j = 0;
        #60  k = 1;
        #80  k = 0;
        #100 j = 1;
        #100 k = 1;
        #160 j = 0;
        #160 k = 0;
    join

    // D and T input control
    initial fork
        #20  d = 1;
        #40  d = 0;
        #80  d = 1;
        #140 d = 0;
    join

    // Clock signal generation (20ns period)
    always
        #10 clk = ~clk;

endmodule // test
```
### 1.在終端機中，輸入：
```
iverilog flip-flops.v flip-flops_tb.v
vvp a.out
```
### 2.執行完後會在資料夾中看到" flip-flops_tb.vcd "這個檔案，右鍵選擇選擇"Open with GTKWave"

### 3.左上方點開test，選擇要看的波形，再點Append

![Screenshot from 2022-08-12 18-03-07](https://user-images.githubusercontent.com/68816726/184333141-4a130705-9433-4d59-a3f0-0db5061aa413.png)
