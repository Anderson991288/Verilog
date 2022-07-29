## Vivado xilinx IP 開發和設計

### 1.開一個新的Project
### 2.選擇IP Catalog，彈出IP Catalog 的頁面，搜尋clock，選擇clocking wizard，彈出clock IP 的配置頁面

![1](https://user-images.githubusercontent.com/68816726/181781859-4a2c7ad4-f31f-47d1-a7ae-10fc8828d483.png)

### 3.修改IP名稱、輸入時鐘頻率為50M

![2](https://user-images.githubusercontent.com/68816726/181782169-46f7f349-ca8e-49ba-98fd-520ed14ae3ee.png)

### 4. output clocks頁面，可以選擇輸出時鐘的個數，輸出時鐘的頻率，相位，占空比等，完成的輸出時鐘波形的控制

![3](https://user-images.githubusercontent.com/68816726/181782992-666b3942-a5f4-46c7-bd2d-fddee1c4a910.png)
![4](https://user-images.githubusercontent.com/68816726/181783253-bf3b2b30-00a9-4229-b431-9208ce9a25e7.png)

### 5.生成的 IP

![5](https://user-images.githubusercontent.com/68816726/181784389-3c356287-cd2c-4d26-a698-64e874a8e3d1.png)

### 6. 新增一個pll_led.v檔，並寫好程式碼。通過調用所生成的IP核，來驅動LED燈，在此程式中，使用了2個相同的計數器

![6](https://user-images.githubusercontent.com/68816726/181784551-75c764ae-e72a-463b-a51d-9ae3f007d198.png)


```
module pll_led(
 input wire clk ,
 input wire rst_n ,
 output reg [1:0] led 
 
 );

 //==================================================
 //parameter define
 //==================================================
 parameter CNT_MAX = 50_000_000 - 1;

 //==================================================

 //internal signals
 //==================================================
 reg [27:0] timer1;//counter for clk_out1
 reg [27:0] timer2;//counter for clk_out2
 wire locked;
 wire clk_out1;
 wire clk_out2;


 //--------------------timer1--------------------
 always @(posedge clk_out1 or negedge rst_n)begin
 if(rst_n==1'b0)begin
 timer1 <= 'd0;
 end
 else if(locked==1'b1)begin
 if(timer1==CNT_MAX)
 timer1 <= 'd0;
 else
 timer1 <= timer1 + 1'b1;
 end
 else begin
 timer1 <='d0;
 end
 end

 //--------------------timer2--------------------
 always @(posedge clk_out2 or negedge rst_n)begin
 if(rst_n==1'b0)begin
 timer2 <= 'd0;
 end
 else if(locked==1'b1)begin
 if(timer2==CNT_MAX)
 timer2 <= 'd0;
 else
 timer2 <= timer2 + 1'b1;
 end
 else begin
 timer2 <='d0;
 end
 end


 //--------------------led1--------------------
 always @(posedge clk_out1 or negedge rst_n)begin
 if(rst_n==1'b0)begin
 led[0] <= 1'b1;
 end
 else if(timer1 == CNT_MAX)begin
 led[0] <= ~led[0];
 end
 else begin
 led[0] <= led[0];
 end
 end

 //--------------------led2--------------------
 always @(posedge clk_out2 or negedge rst_n)begin
 if(rst_n==1'b0)begin
 led[1] <= 1'b1;
 end
 else if(timer2 == CNT_MAX)begin
 led[1] <= ~led[1];
 end
 else begin
 led[1] <= led[1];
 end
 end


 clock clock_inst
 (
 // Clock out ports
 .clk_out1(clk_out1), // output clk_out1
 .clk_out2(clk_out2), // output clk_out2
 // Status and control signals
 .reset(~rst_n), // input reset
 .locked(locked), // output locked
 // Clock in ports
 .clk_in1(clk) // input clk_in1
 );

 endmodule
 ```
 ### 7.新增模擬檔
 
![7](https://user-images.githubusercontent.com/68816726/181790222-df9cec1d-21b4-41db-ac9a-e29f06e583cd.png)

### 8.create file，將檔案命名為tb_pll_led

![8](https://user-images.githubusercontent.com/68816726/181790347-1883bb86-6a0f-4810-bda9-9ab4b3120c5d.png)

### 9.編輯模擬檔，程式如下
```
`timescale 1ns/1ps
module tb_pll_led (); /* this is automatically generated */
parameter CNT_MAX = 100_000 - 1;
reg clk;
wire [1:0] led;
reg rst_n;
pll_led #(
.CNT_MAX(CNT_MAX)
) inst_pll_led (
.clk (clk),
.rst_n (rst_n),
.led (led)
);
initial begin
clk = 0;
forever #(10) clk = ~clk;
end
initial begin
rst_n = 0;
#500;
rst_n = 1;
end
endmodule

```
![9](https://user-images.githubusercontent.com/68816726/181790613-34307b19-e0b1-4b1f-89b9-47a87b6b0951.png)

### 10.進行模擬

![10](https://user-images.githubusercontent.com/68816726/181793713-b150dfd0-0d5d-44a8-a775-35bdfd6c5d4b.png)
![11](https://user-images.githubusercontent.com/68816726/181793763-bdf07efb-35ee-40a4-8dd9-a22e524aa82b.png)

### 11.新增一個Constraint file ， Add Source -> Add or Create Constraints –> ok

![12](https://user-images.githubusercontent.com/68816726/181794296-e494707a-eb51-4f92-8e94-9a73a56e9b9a.png)

### 12.命名為top_pind的.xdc檔

![13](https://user-images.githubusercontent.com/68816726/181794330-289c74b4-3c3c-4021-b176-159377d0dd0d.png)

### 13.編輯.xdc 檔
```
############## clock define##################
create_clock -period 20.000 [get_ports clk]
set_property PACKAGE_PIN N18 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
############## key define##################
set_property PACKAGE_PIN P16 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
##############LED define##################
set_property PACKAGE_PIN P15 [get_ports {led[0]}]
set_property PACKAGE_PIN U12 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports clk]


```

![14](https://user-images.githubusercontent.com/68816726/181794543-5b5d9014-98cb-4ebb-aab0-6fc89ad35022.png)

### 15.產生.bit檔，下載到版子上，可以看到 2 個 led 燈以不同的頻率在閃爍


![AnyConv com__IMG_0117](https://user-images.githubusercontent.com/68816726/181795843-5f8992db-11d9-4b9d-93dd-d47c20d6d123.jpg)

![IMG_0116_MOV_AdobeExpress (1)](https://user-images.githubusercontent.com/68816726/181797931-e4156f3a-b9b0-4ba8-8e62-a5a3df281e7f.gif)



