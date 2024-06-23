`include "pipe_MIPS32.v"


module test_mips32;

  reg clk1, clk2;
  integer k;

  // Instantiating the pipe_MIPS32 module
  pipe_MIPS32 mips (
    .clk1(clk1),
    .clk2(clk2)
  );

  // Clock generation
  initial begin
    clk1 = 0; clk2 = 0;
    repeat (20) begin
      #5 clk1 = 1;  // Phase 1 of the clock
      #5 clk1 = 0;  // Phase 1 of the clock
      #5 clk2 = 1;  // Phase 2 of the clock
      #5 clk2 = 0;  // Phase 2 of the clock
    end
  end

  initial begin
    for (k = 0; k < 32; k = k + 1)
      mips.Reg[k] = k;

    mips.Mem[0] = 32'h28010078; // ADDI R1, R0, 120
    mips.Mem[1] = 32'h0ce77800; // OR R7, R7, R7 (dummy instruction)
    mips.Mem[2] = 32'h20220000; // LW R2,0(R1)
    mips.Mem[3] = 32'h0ce77800; // OR R7, R7, R7 (dummy instruction)
    mips.Mem[4] = 32'h2842002d; // ADDI R2, R2, 45
    mips.Mem[5] = 32'h0ce77800; // OR R7, R7, R7 (dummy instruction)
    mips.Mem[6] = 32'h24220001; // SW R2,1(R1)
    mips.Mem[7] = 32'hfc000000; // HLT
    
    mips.Mem[120] = 85;
    mips.HALTED = 0;
    mips.PC = 0;
    mips.TAKEN_BRANCH = 0;

    // Display initial register values before simulation
    #500
    
    $display("Mem[120] : %4d \nMem[121] : %4d" , mips.Mem[120], mips.Mem[121]);

  end

  // Dumping variables for waveform analysis
  initial begin
    $dumpfile("test_mips32.vcd");
    $dumpvars(0, test_mips32.mips); // Dump variables for the mips instance in addition_mips module

    #600 $finish; // Finish simulation after 300 time units
  end

endmodule
