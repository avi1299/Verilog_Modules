module REG1(clk,EN,numin,numout);
    input clk,EN;
    input [3:0] numin;
    output [3:0] numout;
    reg [3:0] numout;
    always @(posedge clk)
    if(EN)
        numout = numin;
endmodule

module ROTATOR (clk, Enable, numo, numrotated);
    input [3:0] numo;
    input clk,Enable;
    output [3:0] numrotated;
    reg [3:0] numrotated;
    always @(posedge clk) begin
        if(Enable)
            {numrotated} = {numo[0],numo[3:1]};
    end
endmodule

module MULTIPLIER(op1, op2, product);
    input [3:0] op1,op2;
    output reg [7:0] product;
    always @(op1 or op2)
        product=op1*op2;
endmodule

module DECODER (sel, out1);
    input [3:0] sel;
    output reg [15:0] out1;
    always @(sel)
        out1 = 16'b0000000000000001 << sel;
endmodule

module MEMORY(WE, DataToWrite, RegSel, ReadData);
  input WE;
  input [7:0] DataToWrite;
  input [15:0]  RegSel;
  output  [7:0] ReadData;
  reg [7:0] ReadData;
  reg [7:0] Mem [0:15];
  always  @ (WE or DataToWrite or RegSel) begin
    case(RegSel)
      16'h8000: begin
        if(WE)
          Mem[4'h0] = DataToWrite;
        {ReadData} = Mem[4'h0];
      end
      16'h4000: begin
        if(WE)
          Mem[4'h1] = DataToWrite;
        {ReadData} = Mem[4'h1];
      end
      16'h2000: begin
        if(WE)
          Mem[4'h2] = DataToWrite;
        {ReadData} = Mem[4'h2];
      end
      16'h1000: begin
        if(WE)
          Mem[4'h3] = DataToWrite;
        {ReadData} = Mem[4'h3];
      end
      16'h0800: begin
        if(WE)
          Mem[4'h4] = DataToWrite;
        {ReadData} = Mem[4'h4];
      end
      16'h0400: begin
        if(WE)
          Mem[4'h5] = DataToWrite;
        {ReadData} = Mem[4'h5];
      end
      16'h0200: begin
        if(WE)
          Mem[4'h6] = DataToWrite;
        {ReadData} = Mem[4'h6];
      end
      16'h0100: begin
        if(WE)
          Mem[4'h7] = DataToWrite;
        {ReadData} = Mem[4'h7];
      end
      16'h0080: begin
        if(WE)
          Mem[4'h8] = DataToWrite;
        {ReadData} = Mem[4'h8];
      end
      16'h0040: begin
        if(WE)
          Mem[4'h9] = DataToWrite;
        {ReadData} = Mem[4'h9];
      end
      16'h0020: begin
        if(WE)
          Mem[4'hA] = DataToWrite;
        {ReadData} = Mem[4'hA];
      end
      16'h0010: begin
        if(WE)
          Mem[4'hB] = DataToWrite;
        {ReadData} = Mem[4'hB];
      end
      16'h0008: begin
        if(WE)
          Mem[4'hC] = DataToWrite;
        {ReadData} = Mem[4'hC];
      end
      16'h0004: begin
        if(WE)
          Mem[4'hD] = DataToWrite;
        {ReadData} = Mem[4'hD];
      end
      16'h0002: begin
        if(WE)
          Mem[4'hE] = DataToWrite;
        {ReadData} = Mem[4'hE];
      end
      16'h0001: begin
        if(WE)
          Mem[4'hF] = DataToWrite;
        {ReadData} = Mem[4'hF];
      end
    endcase
  end
endmodule

module DATAPATH(Num, Key, StoredValue);
  input [3:0] Num, Key;
  output  [7:0] StoredValue;

  reg clock, EN, WE;
  reg [3:0] sel;
  wire  [3:0] RegOut, RotOut1, RotOut2;
  wire  [7:0] Encrypt;
  wire  [15:0]  Addr;

  initial 
    begin
      #0  clock = 1'b1; EN = 1'b1; WE = 1'b1; sel = 4'h8;
    end
  
  always
    #2  clock = ~clock;
  
  REG1  mod1(clock, EN, Num, RegOut);
  ROTATOR mod2(clock, EN, RegOut, RotOut1);
  ROTATOR mod3(clock, EN, RotOut1, RotOut2);
  MULTIPLIER  mod4(RotOut2, Key, Encrypt);
  DECODER mod5(sel, Addr);
  MEMORY  mod6(WE, Encrypt, Addr, StoredValue);
endmodule

module TESTBENCH;
  reg [3:0] Num, Key;
  wire  [7:0] StoredValue;

  DATAPATH  mod(Num, Key, StoredValue);
  
  initial begin
    $monitor($time, " Number = %b, Key = %b, StoredValue = %b.", Num, Key, StoredValue);
    #0  Num = 4'b1000;  Key = 4'b1000;
    #20 Num = 4'b1001;  Key = 4'b1000;
    #20 Num = 4'b1100;  Key = 4'b1010;
    #20 Num = 4'b1011;  Key = 4'b1110;
    #50 $finish;
  end
endmodule