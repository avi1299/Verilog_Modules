module ANDarray (RegDst,ALUSrc, MemtoReg, RegWrite,MemRead, MemWrite,Branch,ALUOp1,ALUOp2,Op);
    input [5:0] Op;
    output RegDst,ALUSrc,MemtoReg, RegWrite, MemRead,MemWrite,Branch,ALUOp1,ALUOp2;
    wire Rformat, lw,sw,beq;
    assign Rformat= (~Op[0])& (~Op[1])& (~Op[2])& (~Op[3])&(~Op[4])& (~Op[5]);
    assign lw= (Op[0])& (Op[1])& (~Op[2])& (~Op[3])&(~Op[4])& (Op[5]);
    assign sw= (Op[0])& (Op[1])& (~Op[2])& (Op[3])&(~Op[4])& (Op[5]);
    assign beq= (~Op[0])& (~Op[1])& (Op[2])& (~Op[3])&(~Op[4])& (~Op[5]);
// complete rest of the module
    assign 
        RegDst=Rformat,
        ALUSrc=lw |sw,
        MemtoReg=lw, 
        RegWrite=lw|Rformat, 
        MemRead=lw,
        MemWrite=sw,
        Branch=beq,
        ALUOp1=Rformat,
        ALUOp2=beq;
endmodule

module tbmaincontrol;
    reg [5:0]Op;
    wire RegDst,ALUSrc,MemtoReg, RegWrite, MemRead,MemWrite,Branch,ALUOp1,ALUOp2;
    ANDarray A(RegDst,ALUSrc, MemtoReg, RegWrite,MemRead, MemWrite,Branch,ALUOp1,ALUOp2,Op);
    initial
    begin
        $monitor($time," RegDst=%h,ALUSrc=%h, MemtoReg=%h, RegWrite=%h,MemRead=%h, MemWrite=%h,Branch=%h,ALUOp1=%h,ALUOp2=%h,Op=%6b",RegDst,ALUSrc, MemtoReg, RegWrite,MemRead, MemWrite,Branch,ALUOp1,ALUOp2,Op);
        Op=6'b000000;
        #5 Op=6'b100011;
        #5 Op=6'b101011;
        #5 Op=6'b000100;
        #50 $finish;
    end
endmodule
