module ALUControl (ALUOp1,ALUOp2,ALUOp,Funct);
    input [5:0] Funct;
    input ALUOp1,ALUOp2;
    output [2:0] ALUOp;
    wire a010,a110,a000,a001,a111;
    assign
        a010=(~ALUOp1 & ~ALUOp2) | (ALUOp2 & ~Funct[0] & ~Funct[1] & ~Funct[2] & ~Funct[3]),
        a110=(ALUOp1 & ~ALUOp2) | (ALUOp2 & ~Funct[0] & Funct[1] & ~Funct[2] & ~Funct[3]),
        a000=ALUOp2 & ~Funct[0] & ~Funct[1] & Funct[2] & ~Funct[3],
        a001=ALUOp2 & Funct[0] & ~Funct[1] & Funct[2] & ~Funct[3],
        a111=ALUOp2 & ~Funct[0] & Funct[1] & ~Funct[2] & Funct[3],
        ALUOp[2]=a110 | a111,
        ALUOp[1]=a110 | a111 | a010,
        ALUOp[0]=a001 | a111;
endmodule

module tbalucontrol;
    reg [5:0]Funct;
    reg ALUOp1,ALUOp2;
    wire [2:0]Op;
    ALUControl A(ALUOp1,ALUOp2,Op,Funct);
    initial
    begin
        $monitor($time," ALUOp2 = %b,ALUOp1=%b,Op=%3b,Funct=%6b",ALUOp2,ALUOp1,Op,Funct);
        ALUOp1=1'b0;ALUOp2=1'b0;Funct=6'b000000;
        #5 ALUOp1=1'b1;
        #5 ALUOp2=1'b1;
        #5 Funct=6'b000010;
        #5 Funct=6'b000100;
        #5 Funct=6'b000101;
        #5 Funct=6'b001010;
        #50 $finish;
    end
endmodule
