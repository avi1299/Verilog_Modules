module MultiCycle_Control(opcode, state, PCWrite, PCWriteCond, IorD, MemRead, MemWrite, IRWrite, MemToReg, PCSource1, PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0, ALUSrcA, RegWrite, RegDst, NS);
    input [5:0] opcode;
	input [3:0] state;
	output PCWrite, PCWriteCond, IorD, MemRead, MemWrite, IRWrite, MemToReg, PCSource1, PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0, ALUSrcA, RegWrite, RegDst;
	output [3:0] NS;

    wire [16:0] ands;
		
	assign ands[0] = ((~state[0]) & (~state[1]) & (~state[2]) & (~state[3]) );
	assign ands[1] = ((state[0]) & (~state[1]) & (~state[2]) & (~state[3]) );
	assign ands[2] = ((~state[0]) & (state[1]) & (~state[2]) & (~state[3]) );
	assign ands[3] = ((state[0]) & (state[1]) & (~state[2]) & (~state[3]) );
	assign ands[4] = ((~state[0]) & (~state[1]) & (state[2]) & (~state[3]) );
	assign ands[5] = ((state[0]) & (~state[1]) & (state[2]) & (~state[3]) );
	assign ands[6] = ((~state[0]) & (state[1]) & (state[2]) & (~state[3]) );
	assign ands[7] = ((state[0]) & (state[1]) & (state[2]) & (~state[3]) );
	assign ands[8] = ((~state[0]) & (~state[1]) & (~state[2]) & (state[3]) );
	assign ands[9] = ((state[0]) & (~state[1]) & (~state[2]) & (state[3]) );
	assign ands[10] = ((state[0]) & (~state[1]) & (~state[2]) & (~state[3]) & (~opcode[0]) & (opcode[1]) & (~opcode[2]) & (~opcode[3]) & (~opcode[4]) & (~opcode[5]) );
	assign ands[11] = ((state[0]) & (~state[1]) & (~state[2]) & (~state[3]) & (~opcode[0]) & (~opcode[1]) & (opcode[2]) & (~opcode[3]) & (~opcode[4]) & (~opcode[5]) );
	assign ands[12] = ((state[0]) & (~state[1]) & (~state[2]) & (~state[3]) & (~opcode[0]) & (~opcode[1]) & (~opcode[2]) & (~opcode[3]) & (~opcode[4]) & (~opcode[5]) );
	assign ands[13] = ((~state[0]) & (state[1]) & (~state[2]) & (~state[3]) & (opcode[0]) & (opcode[1]) & (~opcode[2]) & (opcode[3]) & (~opcode[4]) & (opcode[5]) );
	assign ands[14] = ((state[0]) & (~state[1]) & (~state[2]) & (~state[3]) & (opcode[0]) & (opcode[1]) & (~opcode[2]) & (~opcode[3]) & (~opcode[4]) & (opcode[5]) );
	assign ands[15] = ((state[0]) & (~state[1]) & (~state[2]) & (~state[3]) & (opcode[0]) & (opcode[1]) & (~opcode[2]) & (opcode[3]) & (~opcode[4]) & (opcode[5]) );
	assign ands[16] = ((~state[0]) & (state[1]) & (~state[2]) & (~state[3]) & (opcode[0]) & (opcode[1]) & (~opcode[2]) & (~opcode[3]) & (~opcode[4]) & (opcode[5]) );
	
	assign PCWrite = ands[0] | ands[9];
	assign PCWriteCond = ands[8];
	assign IorD = ands[3] | ands[5];
	assign MemRead = ands[0] | ands[3];
	assign MemWrite = ands[5];
	assign IRWrite = ands[0];
	assign MemToReg = ands[4];
	assign PCSource1 = ands[9] ;
	assign PCSource0 = ands[8];
	assign ALUOp1 = ands[6];
	assign ALUOp0 = ands[8];
	assign ALUSrcB1 = ands[1] | ands[2];
	assign ALUSrcB0 = ands[0] | ands[1]; 
	assign ALUSrcA = ands[2] | ands[6] | ands[8] ;
	assign RegWrite = ands[4] | ands[7] ;
	assign RegDst = ands[7] ;
	
	assign NS[3] = ands[10] | ands[11] ;
	assign NS[2] = ands[12] | ands[13] | ands[3] | ands[6] ;
	assign NS[1] = ands[12] | ands[14] | ands[15] | ands[16] | ands[6] ;
	assign NS[0] = ands[16] | ands[13] | ands[10] | ands[6] | ands[0] ;
			
endmodule

module TestBench_MC;
    reg [5:0] opcode;
	reg [3:0] state;
	wire PCWrite, PCWriteCond, IorD, MemRead, MemWrite, IRWrite, MemToReg, PCSource1, PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0, ALUSrcA, RegWrite, RegDst;
	wire [3:0] NS;

    MultiCycle_Control MC(opcode, state, PCWrite, PCWriteCond, IorD, MemRead, MemWrite, IRWrite, MemToReg, PCSource1, PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0, ALUSrcA, RegWrite, RegDst, NS);

    initial begin
        $monitor("opcode: %b ",opcode,"state: %b ",state," PCWrite: %b ", PCWrite ,"PCWriteCond : %b ", PCWriteCond,"IorD: %b ", IorD," MemRead: %b ", MemRead," MemWrite: %b ", MemWrite," IRWrite: %b ", IRWrite," MemToReg: %b ", MemToReg," PCSource1: %b ", PCSource1," PCSource0: %b ", PCSource0," ALUOp1: %b ", ALUOp1," ALUOp0: %b", ALUOp0, " ALUSrcB1: %b ", ALUSrcB1," ALUSrcB0 : %b ", ALUSrcB0," ALUSrcA: %b ", ALUSrcA," RegWrite: %b ", RegWrite," RegDst: %b ", RegDst," NS: %b", NS );
        state = 4'b0000;
		#5 state = 4'b0001;
		#10 opcode = 6'b100011;  //6'h23;
		#15 state = 4'b0010;
        #20 state = 4'b0011;
        #25 state = 4'b0100;
        #30 $finish;
    end
endmodule