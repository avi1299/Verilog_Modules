module mux2to1(out,sel,in1,in2);
    input in1,in2,sel;
    output out;
    wire not_sel,a1,a2;
    not (not_sel,sel);
    and (a1,sel,in2);
    and (a2,not_sel,in1);
    or(out,a1,a2);
endmodule

module bit8_2to1mux(out,sel,in1,in2);
    input [7:0] in1,in2;
    output [7:0] out;
    input sel;
    genvar j;
    //this is the variable that is be used in the generate block
    generate
        for(j=0;j<8;j=j+1)
        begin:
            mux_loop
            //mux_loop is the name of the loop
            mux2to1 m1(out[j],sel,in1[j],in2[j]);
            //mux2to1 is instantiated every time it is called
        end
    endgenerate
endmodule

module bit32_mux2to1(out,sel,in1,in2);
    input [31:0] in1,in2;
    output [31:0] out;
    input sel;
    genvar j;
    //this is the variable that is be used in the generate block
    generate
        for(j=0;j<4;j=j+1)
        begin:
            mux_loop
            //mux_loop is the name of the loop
            bit8_2to1mux m1(out[j*8+7:j*8],sel,in1[j*8+7:j*8],in2[j*8+7:j*8]);
            //mux2to1 is instantiated every time it is called
        end
    endgenerate
endmodule

module tb_32bit2to1mux;
    // initial
    // begin
    //     $dumpfile("mux2to1_32.vcd");
    //     $dumpvars;
    // end
    reg [31:0] INP1, INP2;
    reg SEL;
    wire [31:0] out;
    bit32_mux2to1 M1(out,SEL,INP1,INP2);
    initial
    begin
        $monitor(,$time, " INP1=%32b INP2=%32b OUT=%32b SEL=%b",INP1,INP2,out,SEL);
        INP1=32'b10101010101010101010101010101010;
        INP2=32'b01010101010101010101010101010101;
        SEL=1'b0;
        #10 SEL=1'b1;
        #10 $finish;
    end
endmodule