module MEM1(S, G);
	input[2:0] S;
	output[8:0] G;
	reg[8:0] mem[0:7];
	
	reg[8:0] G;
	
	//Initialize the memory
	initial
	begin
		 mem[0] = 9'b000111111;  
		 mem[1] = 9'b001100011;  
		 mem[2] = 9'b010100111;  
		 mem[3] = 9'b011101011;  
		 mem[4] = 9'b100101111;  
		 mem[5] = 9'b101110011;  
		 mem[6] = 9'b110110111;  
		 mem[7] = 9'b111111011;  
	end
	
	always @(S)
		begin
			case(S)
				3'b000: G = mem[0];
				3'b001: G = mem[1];
				3'b010: G = mem[2];
				3'b011: G = mem[3];
				3'b100: G = mem[4];
				3'b101: G = mem[5];
				3'b110: G = mem[6];
				3'b111: G = mem[7];
			endcase
		
		end
endmodule

module MEM2(S, G);
	input[2:0] S;
	output[8:0] G;
	reg[8:0] mem[0:7];
	
	reg[8:0] G;
	
	//Initialize the memory
	initial
	begin
		 mem[0] = 9'b000000000;  
		 mem[1] = 9'b001000100;  
		 mem[2] = 9'b010001000;  
		 mem[3] = 9'b011001100;  
		 mem[4] = 9'b100010000;  
		 mem[5] = 9'b101010100;  
		 mem[6] = 9'b110011000;  
		 mem[7] = 9'b111011100;  
	end
	
	always @(S)
		begin
			case(S)
				3'b000: G = mem[0];
				3'b001: G = mem[1];
				3'b010: G = mem[2];
				3'b011: G = mem[3];
				3'b100: G = mem[4];
				3'b101: G = mem[5];
				3'b110: G = mem[6];
				3'b111: G = mem[7];
			endcase
		
		end
endmodule

module RSFF(q, qbar, r,s, clk, reset);
    input r,s, clk, reset;
    output q, qbar;

    reg q;
    wire qbar;
    assign qbar = ~q;
    initial 
        q <= 1'b0;
    always @(posedge clk or reset)
    begin
        if(reset)
            q <= 1'b0;
        else if(r & s)
            q <= 1'b0;
        else if(r & ~s)
            q <= 1'b0;
        else if(~r & s)
            q <= 1'b1;
    end
endmodule

module DFF(q, qbar, d, clk, reset);
    input d,clk,reset;
    output q,qbar;
    RSFF R(q, qbar, ~d,d, clk, reset);
endmodule

module Ripple_Counter(clk, reset, q);
    input clk, reset;
    output [3:0] q;

    wire [3:0] qbar;

    DFF DFF1(q[0], qbar[0], qbar[0], clk, reset);
    DFF DFF2(q[1], qbar[1], qbar[1], qbar[0], reset);
    DFF DFF3(q[2], qbar[2], qbar[2], qbar[1], reset);
    DFF DFF4(q[3], qbar[3], qbar[3], qbar[2], reset);

endmodule

module Parity_Checker(res,data8,data1);
    input data1;
    input [7:0]data8;
    output res;
    assign res=((data8[0]^data8[1]^data8[2]^data8[3]^data8[4]^data8[5]^data8[6]^data8[7])==data1)?1:0;
endmodule

module MUX2To1(sel, in1, in2, out);
	input sel, in1, in2;
	output out;
	assign out = (~sel & in1) | (sel & in2);
endmodule

module MUX16To8(sel,F, C, E);
	input[7:0] F, C;
    input sel;
	output[7:0] E;
		
	genvar j;
	
	generate for(j = 0; j < 8; j = j+1)
		begin: mux_loop
			MUX2To1 M21(sel,F[j], C[j], E[j]);
		end
	endgenerate
endmodule

module Fetch_Data(data,parity,RC);
    input [3:0] RC;
    output parity;
    output [7:0] data;
    wire [8:0] G1,G2;
    MEM1 MM(RC[2:0], G1);
    MEM2 MN(RC[2:0], G2);
    MUX2To1  MS2(RC[3],G1[0],G2[0],parity);
    MUX16To8 MS8(RC[3],G1[8:1],G2[8:1],data);
endmodule

module Design(res,clk,reset);
    input clk,reset;
    output res;
    wire [3:0] RC;
    wire parity;
    wire [7:0]data;
    Ripple_Counter R1(clk, reset, RC);
    Fetch_Data FD(data,parity,RC);
    Parity_Checker PC(res,data,parity);
endmodule

module tb;
    initial	
	begin
		$dumpfile("2017B5A70667P.vcd");
		$dumpvars;
	end
	reg clock, reset;
	wire res;
	
	Design D(res,clock,reset);
	initial
        begin
		clock = 1'b0;
        reset=1'b0;
        end
	always
		#2 clock <= ~clock;
	
	initial
		begin
			$monitor($time, " Value=%8b, Parity=%b, Output = %b",D.data,D.parity,res);
			#200 $finish;			
		end
endmodule