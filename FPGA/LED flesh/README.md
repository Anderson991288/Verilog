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




