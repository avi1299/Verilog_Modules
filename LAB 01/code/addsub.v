`include "fulladder4bit.v"
module addsub(C_OUT,SUM,A,B,SEL);
    output [3: 0] SUM;
    output C_OUT;
    input [3 :0] A,B;
    input SEL;
    wire C01,C12,C23;
    wire [3:0] TruB;
    assign
        TruB[3]=SEL ^ B[3],
        TruB[2]=SEL ^ B[2],
        TruB[1]=SEL ^ B[1],
        TruB[0]=SEL ^ B[0];
    full4adder f1(C_OUT,SUM,A,TruB,SEL);
endmodule

module testbench_2;
    reg [3:0] A,B;
    reg SEL;
    output [3:0] SUM;
    output C_OUT;
    addsub as(C_OUT,SUM,A,B,SEL);
    initial
        begin
            $monitor(,$time," A=%4b B=%4b SEL=%b RES=%4b C_OUT=%b",A,B,SEL,SUM,C_OUT);
            #5 A=4'b0000;B=4'b0000;SEL=1'b0;
            #5 A=4'b0100;B=4'b0010;SEL=1'b1;
            #5 A=4'b0100;B=4'b0001;SEL=1'b1;
            #5 A=4'b1000;B=4'b1000;SEL=1'b0;
            #5 A=4'b1111;B=4'b1111;SEL=1'b1;
            #5 $finish;
        end
endmodule