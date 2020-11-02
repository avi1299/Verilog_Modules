`include "andor32.v"
`include "FA.v"
`include "mux3to2_32.v"

module ALU(a,b,Binvert,Carryin,Operation,Result,CarryOut);
    input [31:0]a,b;
    input Binvert,Carryin;
    input [1:0] Operation;
    output CarryOut;
    output [31:0] Result;
    wire [31:0] TruB,Sum,And,Or;
    genvar j;
    generate
        for(j=0;j<32;j=j+1)
            xor(TruB[j],b[j],Binvert);
    endgenerate
    FA_32 FA(CarryOut, Sum,a,TruB,Carryin);
    bit32AND A(And,a,TruB);
    bit32OR O(Or,a,TruB);
    bit32_3to2mux OP(Result,Operation,And,Or,Sum);
endmodule


module tbALU;
    reg Binvert, Carryin;
    reg [1:0] Operation;
    reg [31:0] a,b;
    wire [31:0] Result;
    wire CarryOut;
    ALU alu(a,b,Binvert,Carryin,Operation,Result,CarryOut);
    initial
    begin
        $monitor(,$time," a=%h,b=%h,Binvert=%h,Carryin=%h,Operation=%h,Result=%h,CarryOut=%h",a,b,Binvert,Carryin,Operation,Result,CarryOut);
        a=32'ha5a5a5a5;
        b=32'h5a5a5a5a;
        Operation=2'b00;
        Binvert=1'b0;
        Carryin=1'b0; //must perform AND resulting in zero
        #5 Operation=2'b01; //OR
        #5 Operation=2'b10; //ADD
        #5 Binvert=1'b1;Carryin=1'b1;//SUB
        #100 $finish;
    end
endmodule
