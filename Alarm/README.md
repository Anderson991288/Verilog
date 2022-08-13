## Alarm

###  wire:
  * wire 是連接硬體元件的連接線
  * wire 內定為一個位元的值，
   
   eg:
   
     ```
     wire b,c; //宣告兩條接線
     ```
     
     
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

alarm.v
```
module alarm(
    input wire door,    // door sensor: 0-closed, 1-open
    input wire engine,  // engine sensor: 0-off, 1-on
    input wire lights,  // lights sensor: 0-off, 1-on
    output reg siren    // alarm siren. 0-off, 1-on
                        /* The output is declared as 'reg' because it will be
                         * assigned from an 'always' block. */
    );


    always @(*)
        if (engine == 1 && door == 1)
            siren = 1;  // activate when 1st condition is met
        else if (engine == 0 && lights == 1 && door == 1)
            siren = 1;  // also activate when 2nd condition is met
        else
            siren = 0;  // in any other case, the siren is off

endmodule	// alarm

```
alarm_tb.v
```
module test();

    // Inputs
    reg door, engine, lights;

    // Output
    wire siren;

    // Unit Under Test (UUT) instance

    alarm uut (
        .door(door),
        .engine(engine),
        .lights(lights),
        .siren(siren)
        );

    // Input initialization and simulation control
    initial begin
        // Input initialization
        door = 0;     // closed
        engine = 0;   // off
        lights = 0;   // off

        // Waveform generation statements
        $dumpfile("alarm_tb.vcd");
        $dumpvars(0,test);

        // Circuit test


        // Door open and engine on
        #10 engine = 1;     // start engine
        #10 door = 1;       // open door
                            // siren should activate here
        #10 door = 0;       // close door
                            // siren should deactivate here
        #10 engine = 0;     // engine off
        #10 lights = 1;     // lights on
        #10 door = 1;       // open door
                            // siren should activate here
        #10 lights = 0;     // lights off
                            // siren should deactivate here
        #10 door = 0;       // close door

        // Simulation ends
        #20 $finish;
    end

endmodule // test

```
### 1.在終端機中，輸入：
```
iverilog alarm_tb.v alarm.v
vvp a.out
```
### 2.執行完後會在資料夾中看到" alarm_tb.vcd "這個檔案，右鍵選擇選擇"Open with GTKWave"

### 3.左上方點開test，點uut，左下方四個全選，再點Append

![Screenshot from 2022-08-06 22-08-28](https://user-images.githubusercontent.com/68816726/183252931-1e162a34-f81c-4648-af4f-767f987c4b00.png)

