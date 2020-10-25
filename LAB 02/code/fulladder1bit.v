module fulladder_df(CARRY_OUT ,SUM, A, B, CARRY_IN);
    input A,B,CARRY_IN;
    output CARRY_OUT, SUM;
    assign
        SUM=A ^ B ^ CARRY_IN,
        CARRY_OUT= A & B | A & CARRY_IN | B & CARRY_IN;
endmodule

module testbench;
    reg A,B,CARRY_IN;
    output CARRY_OUT,SUM;
    //Choose which version of the full adder to test below
    fulladder_df full_adder (CARRY_OUT ,SUM, A, B, CARRY_IN);
    initial
        begin
            $monitor(,$time," A=%b B=%b C_IN=%b SUM=%b C_OUT=%b",A,B,CARRY_IN,SUM,CARRY_OUT);
            #5 A=1'b0;B=1'b0;CARRY_IN=1'b0;
            #5 A=1'b0;B=1'b0;CARRY_IN=1'b1;
            #5 A=1'b0;B=1'b1;CARRY_IN=1'b0;
            #5 A=1'b0;B=1'b1;CARRY_IN=1'b1;
            #5 A=1'b1;B=1'b0;CARRY_IN=1'b0;
            #5 A=1'b1;B=1'b0;CARRY_IN=1'b1;
            #5 A=1'b1;B=1'b1;CARRY_IN=1'b0;
            #5 A=1'b1;B=1'b1;CARRY_IN=1'b1;
            #5 $finish;
        end
endmodule