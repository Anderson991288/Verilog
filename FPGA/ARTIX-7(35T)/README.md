## LED flash:

### 修改先前的程式碼，使用其他板子實現

### led_flash.v
* 這裡修改了兩個always block裡面的 rst_n==1'b1


```
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/28/2022 11:23:10 AM
// Design Name: 
// Module Name: led_flash
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module led_flash(
input wire clk ,//System differential clock
 input wire rst_n ,//system reset
 output reg [1:0] led //output led
 );
 
 //==================================================
 //internal singals
 //==================================================
 
 
 reg [27:0] cnt ;//0.25s counter
 wire add_cnt ; 
 wire end_cnt ;
 

 //--------------------cnt--------------------
 always @(posedge clk or negedge rst_n)begin
 if(rst_n==1'b1)begin
 cnt <= 'd0;
 end
 else if(add_cnt)begin


 if(end_cnt)
 cnt <= 'd0;
 else
 cnt <= cnt + 1'b1;
 end 
 end
 
 assign add_cnt = 1; 
 assign end_cnt = add_cnt && cnt== 10_000_000 - 1; 
 
 
 //--------------------led--------------------
 always @(posedge clk or negedge rst_n)begin 
  if(rst_n==1'b1)begin
 led <= 2'b01;//reset state
 end 
 else if(end_cnt)begin
 led <= {led[0], led[1]};
 end 

 else begin
 led <= led; //keep the state
 end 
 end

endmodule
```


### xdc file:

* 這裡需修改兩個版子相對應的pin腳，可以參考下面的資料來做修改

![螢幕擷取畫面 2022-08-01 232210](https://user-images.githubusercontent.com/68816726/182183509-69d60bc2-12e4-491a-9db1-31d9eaa080c8.png)


```
############## clock define##################
create_clock -period 20.000 [get_ports clk]
set_property PACKAGE_PIN L17 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
############## key define##################
set_property PACKAGE_PIN B18 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
##############LED define##################
set_property PACKAGE_PIN B16 [get_ports {led[0]}]
set_property PACKAGE_PIN C17 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
```
### 完成:

![IMG_0238_MOV_AdobeExpress](https://user-images.githubusercontent.com/68816726/182184911-c1c45d12-1c9b-4cda-875a-f65e61848a73.gif)

(按reset鍵會重新回到紅燈)

[cmod_a7_sch_rev_c0.pdf](https://github.com/Anderson991288/Verilog/files/9235060/cmod_a7_sch_rev_c0.pdf)

[cmod-artix7-35t.txt](https://github.com/Anderson991288/Verilog/files/9235096/cmod-artix7-35t.txt)
