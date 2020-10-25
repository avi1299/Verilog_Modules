`include "fulladder1bit.v"
module full4adder(OF,C_OUT,SUM,A,B,C_IN);
    output [3: 0] SUM;
    output C_OUT,OF;
    input [3 :0] A,B;
    input C_IN;
    wire C01,C12,C23;
    fulladder_df
        f1(C01,SUM[0],A[0],B[0],C_IN),
        f2(C12,SUM[1],A[1],B[1],C01),
        f3(C23,SUM[2],A[2],B[2],C12),
        f4(C_OUT,SUM[3],A[3],B[3],C23);
    assign OF=C23 ^ C_OUT;
endmodule

module testbench_1;
    reg [3:0] A,B;
    reg C_IN;
    output [3:0] SUM;
    output C_OUT,OF;
    full4adder adder(OF,C_OUT,SUM,A,B,C_IN);
    initial
        begin
            $monitor(,$time," A=%4b B=%4b C_IN=%b SUM=%4b C_OUT=%b",A,B,C_IN,SUM,C_OUT);
            #5 A=4'b0000;B=4'b0000;C_IN=1'b0;
            #5 A=4'b0100;B=4'b0010;C_IN=1'b0;
            #5 A=4'b0000;B=4'b0000;C_IN=1'b1;
            #5 A=4'b1000;B=4'b1000;C_IN=1'b0;
            #5 A=4'b1111;B=4'b1111;C_IN=1'b1;
            #5 $finish;
        end
endmodule