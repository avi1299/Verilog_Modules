`include "adder8bit.v"
module adder32(SUM,C_OUT,X,Y,C_IN);
    input [31:0] X,Y;
    input C_IN;
    output [31:0] SUM;
    output C_OUT;
    wire c1,c2,c3;
    adder8bit
        f1(SUM[7:0],c1,X[7:0],Y[7:0],C_IN),
        f2(SUM[15:8],c2,X[15:8],Y[15:8],c1),
        f3(SUM[23:16],c3,X[23:16],Y[23:16],c2),
        f4(SUM[31:24],C_OUT,X[31:24],Y[31:24],c3);
endmodule

module testbench_2;
    reg [31:0] X,Y;
    reg C_IN;
    wire [31:0] SUM;
    wire C_OUT;
    adder32 a(SUM,C_OUT,X,Y,C_IN);
    initial
        $monitor(,$time,"X=%32b,Y=%32b,C_IN=%b,SUM=%32b,C_OUT=%b",X,Y,C_IN,SUM,C_OUT);
    initial
        begin
            #0 X=32'b00000000000000000000000000000000;Y=32'b00000000000000000000000000000000;C_IN=1'b0;
            #4 X=32'b10101010000000000000000000000000;Y=32'b01010101000000000000000000000000;C_IN=1'b0;
            #4 X=32'b00001111000000000000000000000000;Y=32'b00001111000000000000000000000000;C_IN=1'b1;
        end
endmodule