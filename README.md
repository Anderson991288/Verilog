## Install Icarus Verilog:
```
sudo apt update
sudo apt install iverilog
```

## Install GTKWave:
```
sudo apt update
sudo apt install gtkwave
```
### module：
   * verilog起始宣告的關鍵字，接著後面的括弧裡面放input,output
   * 最後面要加endmodule

### input output：
   * 輸入輸出腳位

###  wire:
  * wire 是連接硬體元件的連接線
  * wire 內定為一個位元的值，
   
    eg:
   
     ```
     wire b,c; //宣告兩條接線
     ```
###  reg:
  * reg的功能和變數很像，可以直接給定一個數值
  * 主要的功能為保持住電路中某個值
  * 內定值為x(don't care)
  * reg[7:0] A => 宣告一個名字為A的8bits的暫存器．
### assign：
  * 要求指定的訊號線要做什麼運算
    eg:
    ```
    assign “temp1 = a & b;
    ```
    把a and b 的結果指定給 temp1，這邊要注意的是指定的對象必須宣告為wire的形式．       
     
### always block:
  * always裡面的變數必須是宣告成reg的形式
  * 同一個變數只能在同一個always block出現
  * always觸發條件有兩種行為模式always@(posedge clk) 跟 always@(a or b)
  * 循序邏輯電路always@(posedge clk)：
    * 當clock上升的瞬間去做always block內的動作
  * 組合邏輯電路always@(a or b)：
    * 當a或者是b有變化時，才會去做always block裡的變化 
    * always@(a or b) 寫法等同於 always@(a , b)，也可以直接寫always@(＊) 

### if else:
  * 根據判斷式的先後順序有優先權的不同，以下面的例子就是reset >判斷條件1>判斷條件2>．．．．>判斷條件n
  ```
  always@(posedge clk)begin
  if(reset)begin

  end
  else if(判斷條件 1)begin
    敘述1
  end
  else if(判斷條件 2)begin
    敘述2
  end
      .
      .
      .
      .
      .
      .
  else begin
    敘述n
  end
end
  ```
