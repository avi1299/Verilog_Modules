module FA_dataflow (Cout, Sum,In1,In2,Cin);
    input In1,In2;
    input Cin;
    output Cout;
    output Sum;
    assign {Cout,Sum}=In1+In2+Cin;
endmodule

module FA_32(Cout, Sum,In1,In2,Cin);
    input [31:0] In1, In2;
    input Cin;
    output Cout;
    output [31:0] Sum;
    wire [32:0] cout_temp;
    assign cout_temp[0]=Cin;
    genvar j;
    generate
        for(j=0;j<32;j=j+1)
        begin:
            FA_mod
            FA_dataflow FA1(cout_temp[j+1], Sum[j],In1[j],In2[j],cout_temp[j]);
        end
        assign Cout=cout_temp[32];
    endgenerate
endmodule

module tb_32FA;
    // initial
    // begin
    //     $dumpfile("FA.vcd");
    //     $dumpvars;
    // end
    reg [31:0] INP1, INP2;
    reg CIN;
    wire [31:0] SUM;
    wire COUT;
    FA_32 FA(COUT, SUM,INP1,INP2,CIN);
    initial
    begin
        //$monitor(,$time, " INP1=%h INP2=%h CIN=%h SUM=%h COUT=%h",INP1,INP2,CIN,SUM,COUT);
        INP1=32'h00001111;
        INP2=32'h0000aaaa;
        CIN=1'b0;
        #10  INP1=32'h00001111;INP2=32'h0011aaaa;
        #10 $finish;
    end
endmodule
