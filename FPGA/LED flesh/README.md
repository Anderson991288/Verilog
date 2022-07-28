# 程式設計:

### 1.建一個.v檔，左邊Project Manager下， 點選Add Source

![11](https://user-images.githubusercontent.com/68816726/181551142-ccbbe445-52fe-4467-a7cd-5d187b8f3bbc.png)

### 2.選擇Add or Create Design Source，然後點選Next

![22](https://user-images.githubusercontent.com/68816726/181560349-2e9584f3-6951-4b98-ae9c-26cad5eb84ad.png)

### 3.可以添加已有的程式，這裡我們還沒有程式，選擇Create File

![33](https://user-images.githubusercontent.com/68816726/181561678-17eb1bbd-e416-4602-9e56-6c919809e010.png)

### 4.彈出對話框，輸入檔名led_flash， 點選OK

![44](https://user-images.githubusercontent.com/68816726/181562776-d5361c03-f845-4d9f-87a0-d770684249e5.png)

### 5.點選Finish

![55](https://user-images.githubusercontent.com/68816726/181563351-38db121c-bf3d-4fbe-a832-266e471d6c34.png)

### 6.提醒定義 I/O 的端口，這裡不定義，後面程式中會編寫

![66](https://user-images.githubusercontent.com/68816726/181564418-c9fbc367-a44b-43a8-b885-1bddef9e897a.png)

### 7.點選Yes

![Screenshot 2022-07-28 223853](https://user-images.githubusercontent.com/68816726/181564564-aef5bb2b-5ffe-4e12-977e-908018bf1b8e.png)

### 8.Source中有led_flash.v文件，點開並編輯

![111](https://user-images.githubusercontent.com/68816726/181566072-ca539b3a-a11a-4064-9812-5a369420225e.png)

### 9.程式碼如下

```
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
 if(rst_n==1'b0)begin
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
  if(rst_n==1'b0)begin
 led <= 2'b10;//reset state
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

### 10.先創建一個.xdc的約束檔，左側Project Manager下，點選Add Source

![1111](https://user-images.githubusercontent.com/68816726/181569691-2e8979fa-0fc1-4eec-9eaa-70243006396d.png)

### 11.點選Create File，在file name輸入top_pin，點選 OK

![222](https://user-images.githubusercontent.com/68816726/181570109-5c2512b8-56f7-4140-9ac0-6335e11e04c4.png)

### 12.點選Finish，完成約束檔的創建

![3333](https://user-images.githubusercontent.com/68816726/181570451-29090e3e-6741-4f97-9c96-1a974c86229f.png)


### 13.建好之後，在約束檔組下有個top_pin.xdc

![4444](https://user-images.githubusercontent.com/68816726/181570825-1d966d4c-1564-486b-82a7-6f3306d96067.png)

### 14.點開top_pin.xdc並編輯，程式碼如下

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

### 15.編輯完Ctrl+S存檔

### 16.依序點選 1 Run synthesized，2 Run Implementation，3 Generate Bitstream

![123](https://user-images.githubusercontent.com/68816726/181572115-32bf372c-ce35-4ff6-84e0-a8401794d8cd.png)

### 17.完成後，點選Open Hardware Manager

![1234](https://user-images.githubusercontent.com/68816726/181572816-3c90f1ca-3eff-49f5-895b-6b40bc6c1194.png)

### 18.將版子接上電腦，點選Open target， 然後點選Auto Connect

![12345](https://user-images.githubusercontent.com/68816726/181573438-82485b83-cee0-45c9-902b-34376936054d.png)

### 19.點選Program device，下载程式，彈出視窗，點選Program

![123456](https://user-images.githubusercontent.com/68816726/181573944-18ca4e02-fbe7-4f5b-85d8-d044603bfb9d.png)

### 20.下载完成後可以看到2顆LED開始閃爍

![AnyConv com__IMG_0114](https://user-images.githubusercontent.com/68816726/181575235-21f1ee4c-768a-46d3-b9bb-316d8b916f3a.jpg)


