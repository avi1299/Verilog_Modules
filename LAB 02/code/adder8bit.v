`include "adderfromdecoder.v"
module adder8bit(SUM,C_OUT,X,Y,C_IN);
    input [7:0] X,Y;
    input C_IN;
    output [7:0] SUM;
    output C_OUT;
    wire c1,c2,c3,c4,c5,c6,c7;
    FADDER
        f1(SUM[0],c1,X[0],Y[0],C_IN),
        f2(SUM[1],c2,X[1],Y[1],c1),
        f3(SUM[2],c3,X[2],Y[2],c2),
        f4(SUM[3],c4,X[3],Y[3],c3),
        f5(SUM[4],c5,X[4],Y[4],c4),
        f6(SUM[5],c6,X[5],Y[5],c5),
        f7(SUM[6],c7,X[6],Y[6],c6),
        f8(SUM[7],C_OUT,X[7],Y[7],c7);
endmodule

module testbench_1;
    reg [7:0] X,Y;
    reg C_IN;
    wire [7:0] SUM;
    wire C_OUT;
    adder8bit a(SUM,C_OUT,X,Y,C_IN);
    initial
        $monitor(,$time,"X=%8b,Y=%8b,C_IN=%b,SUM=%8b,C_OUT=%b",X,Y,C_IN,SUM,C_OUT);
    initial
        begin
            #0 X=8'b00000000;Y=8'b00000000;C_IN=1'b0;
            #4 X=8'b10101010;Y=8'b01010101;C_IN=1'b0;
            #4 X=8'b00001111;Y=8'b00001111;C_IN=1'b1;
        end
endmodule