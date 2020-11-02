module d_ff(q,d,clk,reset);
    input d,clk,reset;
    output q;
    reg q;
    always@(posedge clk)
    begin
        if(!reset)
            q <= 1'b0;
        else 
        q <= d;
    end
endmodule

module reg_32bit(q,d,clk,reset);
    input [31:0] d;
    input clk,reset;
    output [31:0] q;
    genvar i;
    generate 
        for(i = 0; i < 32; i = i+1)
        begin: FF
            d_ff DFF(q[i], d[i], clk, reset);
        end
    endgenerate
endmodule

// module tb32reg;
//     reg [31:0] d;
//     reg clk,reset;
//     wire [31:0] q;
//     reg_32bit R(q,d,clk,reset);
//     always @(clk)
//         #5 clk<=~clk;
//     initial
//     begin
//         //$monitor($time," q=%h,d=%h,clk=%h,reset=%h",q,d,clk,reset);
//         clk= 1'b1;
//         reset=1'b0;//reset the register
//         #20 reset=1'b1;
//         #20 d=32'hAFAFAFAF;
//         #200 $finish;
//     end
// endmodule

module mux4_1(regData,q1,q2,q3,q4,reg_no);
    input [31:0] q1,q2,q3,q4;
    input [1:0] reg_no;
    output [31:0] regData;
    assign regData = reg_no[1]?(reg_no[0]?q4:q3):(reg_no[0]?q2:q1);
endmodule

module decoder2_4 (register,reg_no);
    input [1:0] reg_no;
    output [3:0] register;
    assign register =4'b0001 << reg_no;
endmodule

module register_file(read_1,read_2,R1,R2,WR,reset,write_data,RegWrite,CLK);
    input [1:0] R1,R2,WR;
    input [31:0] write_data;
    input RegWrite,CLK,reset;
    output [31:0] read_1,read_2;
    wire [3:0] DecodedR1,DecodedR2,DecodedWR;
    wire [31:0] q1,q2,q3,q4;
    wire [3:0] clks;
    genvar i;
    generate
        for(i=0;i<4;i=i+1)
        begin
            assign clks[i]=CLK & DecodedWR[i] & RegWrite;
        end
    endgenerate
    decoder2_4 Read1(DecodedR1,R1);
    decoder2_4 Read2(DecodedR2,R2);
    decoder2_4 Write(DecodedWR,WR);
    mux4_1 M1(read_1,q1,q2,q3,q4,R1);
    mux4_1 M2(read_2,q1,q2,q3,q4,R2);
    reg_32bit Reg1(q1,write_data,clks[0],reset);
    reg_32bit Reg2(q2,write_data,clks[1],reset);
    reg_32bit Reg3(q3,write_data,clks[2],reset);
    reg_32bit Reg4(q4,write_data,clks[3],reset);
endmodule

module testbench;
    reg [1:0] R1,R2,WR;
    reg [31:0] write_data;
    reg RegWrite,CLK,reset;
    wire [31:0] read_1, read_2;
    register_file RF(read_1,read_2,R1,R2,WR,reset,write_data,RegWrite,CLK);
    always
        #5 CLK=~CLK;
    initial
    begin
        $monitor($time," read_1 =%h,read_2=%h,R1=%h,R2=%h,WR=%h,reset=%h,write_data=%h,RegWrite=%h,CLK=%h",read_1,read_2,R1,R2,WR,reset,write_data,RegWrite,CLK);
        reset=1'b0;
        R1=2'b00;
        R2=2'b11;
        WR=2'b00;
        CLK=1'b0;
        write_data=32'hffffffff;
        RegWrite =1'b0;
        #20 reset =1'b1;
        #40 RegWrite =1'b1;
        #20 WR=2'b01;
        #20 WR=2'b10;
        #20 WR=2'b11;
        #200 $finish;
    end
endmodule



