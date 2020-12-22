module bit32AND (out,in1,in2);
    input [31:0] in1,in2;
    output [31:0] out;
    assign {out}=in1 &in2;
endmodule

module bit32OR (out,in1,in2);
    input [31:0] in1,in2;
    output [31:0] out;
    assign {out}=in1 | in2;
endmodule

module tb32bitandor;
reg [31:0] IN1,IN2;
wire [31:0] OUTA,OUTO;
bit32AND a1 (OUTA,IN1,IN2);
bit32OR o1 (OUTO,IN1,IN2);
initial
begin
    //$monitor(,$time," IN1=%h IN2=%h AND=%h OR=%h",IN1,IN2,OUTA,OUTO);
    IN1=32'hA5A5;
    IN2=32'h5A5A;
    #10 IN1=32'h5A5A;
    #20 $finish;
end
endmodule
