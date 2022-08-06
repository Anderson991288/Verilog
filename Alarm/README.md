## Alarm

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

  /* The function is described in a procedural block using 'if-else'
   * statements. The sensitivity list "@(*)" automatically includes all
   * the signals in the block which is the right way to describe a
   * combinational operation, so it is called "combinational sensitivity
   * list". This way we can avoid to forget any of the involved signals.
   * The equivalent sensitivity list in this case is
   * "@(engine, door, lights). */

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
    /* It is good practice to use a line of code for every connected signal.
     * This way it is easier to check if all the signal of the module have been
     * connected, and to add or remove signal in the future if needed. */
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
        /* We change the input signals so that the circuit should activate
         * the alarm (the siren rings). We test the cases of interest:
         *   - door open with engine on,
         *   - door open with engine off and lights on. */

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

