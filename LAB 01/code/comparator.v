//We have to make a 4 bit magnitude comparator using behavioral, dataflow, gate level modelling
module comparator_gate(ALB, AGB, AEB, A , B);
    output ALB,AGB,AEB;
    input [3 : 0] A, B;
    wire [3 : 0] NotA, NotB,X,Y,Z;
    xnor
        x1(X[3],A[3],B[3]),
        x2(X[2],A[2],B[2]),
        x3(X[1],A[1],B[1]),
        x4(X[0],A[0],B[0]);
    and (AEB,X[3],X[2],X[1],X[0]);
    not
        n1(NotA[3],A[3]),
        n2(NotA[2],A[2]),
        n3(NotA[1],A[1]),
        n4(NotA[0],A[0]),
        n5(NotB[3],B[3]),
        n6(NotB[2],B[2]),
        n7(NotB[1],B[1]),
        n8(NotB[0],B[0]);
    and
        a1(Z[3],NotA[3],B[3]),
        a2(Y[3],A[3],NotB[3]),
        a3(Z[2],NotA[2],B[2],X[3]),
        a4(Y[2],A[2],NotB[2],X[3]),
        a5(Z[1],NotA[1],B[1],X[3],X[2]),
        a6(Y[1],A[1],NotB[1],X[3],X[2]),
        a7(Z[0],NotA[0],B[0],X[3],X[2],X[1]),
        a8(Y[0],A[0],NotB[0],X[3],X[2],X[1]);
    or
        o1(AGB,Y[3],Y[2],Y[1],Y[0]),
        o2(ALB,Z[3],Z[2],Z[1],Z[0]);
endmodule

module comparator_df(ALB, AGB, AEB, A , B);
    output ALB,AGB,AEB;
    input [3 : 0] A, B;
    wire [3 : 0] X;
    
    assign 
        X[3]=A[3] ~^ B[3],
        X[2]=A[2] ~^ B[2],
        X[1]=A[1] ~^ B[1],
        X[0]=A[0] ~^ B[0];
    
    assign 
        AEB=X[3] & X[2] & X[1] & X[0],
        AGB=(A[3] & ~B[3]) | (A[2] & ~B[2] & X[3]) | (A[1] & ~B[1] & X[3] & X[2]) | (A[0] & ~B[0] & X[3] & X[2] & X[1]),
        ALB=(~A[3] & B[3]) | (~A[2] & B[2] & X[3]) | (~A[1] & B[1] & X[3] & X[2]) | (~A[0] & B[0] & X[3] & X[2] & X[1]);
endmodule

module comparator_bh(ALB, AGB, AEB, A , B);
//NOTE: In behavioural, replace all the outputs/wires with reg
    output reg ALB,AGB,AEB;
    input [3 : 0] A, B;
    reg [3 : 0] X;

	always@(A or B)
	begin
		X[3] = A[3] ~^ B[3];
		X[2] = A[2] ~^ B[2];
        X[1] = A[1] ~^ B[1];
        X[0] = A[0] ~^ B[0];
        AEB=X[3] & X[2] & X[1] & X[0];
        AGB=(A[3] & ~B[3]) | (A[2] & ~B[2] & X[3]) | (A[1] & ~B[1] & X[3] & X[2]) | (A[0] & ~B[0] & X[3] & X[2] & X[1]);
        ALB=(~A[3] & B[3]) | (~A[2] & B[2] & X[3]) | (~A[1] & B[1] & X[3] & X[2]) | (~A[0] & B[0] & X[3] & X[2] & X[1]);
		
		if(ALB)
			$display("At %0d, A < B", $time);
		else if(AGB)
			$display("At %0d, A > B", $time);
		else if(AEB)
			$display("At %0d, A = B", $time);
	end
endmodule

module testbench;
	reg [3:0] A, B;
	wire ALB, AGB, AEB;
	//Switch between the three implementations of the comparator module
	comparator_bh comp(ALB, AGB, AEB, A , B);
	initial
		begin
			$monitor(,$time," A = %4b, A = %4b, ALB = %1b, AGB = %1b, AEB = %1b", A, B, ALB, AGB, AEB);
			#5 A=4'b0000; B=4'b0000;
			#5 A=4'b0001; B=4'b0010;
			#5 A=4'b0010; B=4'b0100;
			#5 A=4'b0011; B=4'b1000;
			#5 A=4'b0100; B=4'b1010;
			#5 A=4'b0101; B=4'b0010;
			#5 A=4'b0110; B=4'b0100;
			#5 A=4'b0111; B=4'b1000;
			#5 A=4'b1000; B=4'b1111;
			#5 A=4'b1001; B=4'b1000;
			#5 $finish;
        end
endmodule


