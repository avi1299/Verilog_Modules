module shiftreg(SO,LD_VAL,EN, in, CLK);
    parameter n = 4;
    input EN,in,CLK;
    input [3:0] LD_VAL;
    reg [n-1:0] Q;
    output reg SO;
    initial
        begin
        #1 Q=LD_VAL;SO = Q[0];
        end
    always @(posedge CLK)
    begin
        if (EN)
        begin
            SO = Q[0];
            Q  = {in,Q[n-1:1]};
        end
    end
        
endmodule

module fulladder(CARRY_OUT ,SUM, A, B, CARRY_IN);
    input A,B,CARRY_IN;
    output CARRY_OUT, SUM;
    assign
        SUM=A ^ B ^ CARRY_IN,
        CARRY_OUT= A & B | A & CARRY_IN | B & CARRY_IN;
endmodule

module dflipflop(Q,D,CLK,CLEAR);
    input D,CLK,CLEAR;
    output reg Q;
    initial
        #1 Q=0;
    always @(posedge CLK)
    begin
        if(CLEAR) Q = 1'b0;
        else Q = D;
    end
endmodule

module serialadder4(shift_control,LD_A,LD_B,CLK);
    initial
    begin
        $dumpfile("serialadder4.vcd");
        $dumpvars;
    end
    input shift_control,CLK;
    input [3:0] LD_B,LD_A;
    wire w;
    wire sum,cout_temp,cin,soA,soB;
    assign w = CLK & shift_control;
    shiftreg A(soA,LD_A,shift_control, sum, CLK);
    shiftreg B(soB,LD_B,shift_control, 1'b0, CLK);
    fulladder FA(cout_temp,sum,soA,soB,cin);
    dflipflop D(cin,cout_temp,w,1'b0);
endmodule

module testbench;
    reg shift_control, CLK;
    reg [3:0] LD_A=4'b0111,LD_B=4'b0111;
    //reg [n-1:0] Q;
    serialadder4 SA(shift_control,LD_A,LD_B,CLK);
    initial
        begin
            CLK=0;
        end
    always
        #2 CLK=~CLK;
    initial
        $monitor($time," A=%4b B=%4b COUT=%b\n",SA.A.Q,SA.B.Q,SA.D.Q);
    initial
        begin
            LD_A=4'b0111;LD_B=4'b0111;shift_control=1'b1;
            #20 $finish;
        end
endmodule