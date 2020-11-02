module mux3to2(out,sel,in1,in2,in3);
    input in1,in2,in3;
    input [1:0] sel;
    output out;
    wire a1,a2,a3;
    assign a1= in1 & ~sel[1] & ~sel[0];
    assign a2= in2 & ~sel[1] & sel[0];
    assign a3= in3 & sel[1] & ~sel[0];
    assign out =a1 |a2 |a3;
endmodule

module bit32_3to2mux(out,sel,in1,in2,in3);
    input [31:0] in1,in2,in3;
    output [31:0] out;
    input [1:0] sel;
    genvar j;
    //this is the variable that is be used in the generate block
    generate
        for(j=0;j<32;j=j+1)
        begin:
            mux_loop
            //mux_loop is the name of the loop
            mux3to2 m1(out[j],sel,in1[j],in2[j],in3[j]);
            //mux2to1 is instantiated every time it is called
        end
    endgenerate
endmodule

module tb_32bit3to2mux;
    // initial
    // begin
    //     $dumpfile("mux3to2_32.vcd");
    //     $dumpvars;
    // end
    reg [31:0] INP1, INP2,INP3;
    reg [1:0] SEL;
    wire [31:0] out;
    bit32_3to2mux M1(out,SEL,INP1,INP2,INP3);
    initial
    begin
        //$monitor(,$time, " INP1=%h INP2=%h INP3=%h OUT=%h SEL=%h",INP1,INP2,INP3,out,SEL);
        INP1=32'b10101010101010101010101010101010;
        INP2=32'b01010101010101010101010101010101;
        INP3=32'b11111111111111111111111111111111;
        SEL=2'b00;
        #10 SEL=2'b01;
        #10 SEL=2'b10;
        #10 SEL=2'b11;
        #10 $finish;
    end
endmodule