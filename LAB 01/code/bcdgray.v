module bcdgray_gate (bcd,gray);
    output [3 : 0] gray;
    input  [3 : 0] bcd;
    buf (gray[3],bcd[3]);
    xor (gray[2],bcd[3],bcd[2]);
    xor (gray[1],bcd[2],bcd[1]);
    xor (gray[0],bcd[1],bcd[0]);
endmodule

module bcdgray_df (bcd,gray);
    output [3 : 0] gray;
    input  [3 : 0] bcd;
    assign gray[3] = bcd[3];
    assign gray[2] = bcd[3] ^ bcd[2];
    assign gray[1] = bcd[2] ^ bcd[1];
    assign gray[0] = bcd[1] ^ bcd[0];
endmodule

module testbench;
    reg [3 : 0] bcd;
    wire [3 : 0] gray;
    //Use of the following from below to switch from gate to df implemetation of the converter
    bcdgray_gate bg_g(bcd,gray);
    //bcdgray_df bg_df(bcd, gray);
    initial
        begin
            $monitor(,$time,"BCD = %b, GRAY = %b",bcd,gray);
            #1 bcd=4'b0000;
            #1 bcd=4'b0001;
            #1 bcd=4'b0010;
            #1 bcd=4'b0011;
            #1 bcd=4'b0100;
            #1 bcd=4'b0101;
            #1 bcd=4'b0110;
            #1 bcd=4'b0111;
            #1 bcd=4'b1000;
            #1 bcd=4'b1001;
            #1 $finish;
        end
endmodule