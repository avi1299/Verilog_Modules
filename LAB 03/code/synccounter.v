module jkflipflop(Q,J,K,CLK);
    initial
    begin
        $dumpfile("synccounter.vcd");
        $dumpvars;
    end
    input CLK,K,J;
    output reg Q;
    initial
        Q=1'b0;
    always @(posedge CLK)
        case ({J,K})
            2'b00 : Q <= Q;
            2'b01 : Q <= 1'b0;
            2'b10 : Q <= 1'b1;
            2'b11 : Q <= ~Q;
        endcase
endmodule

module synccounter(Q,CLK);
    input CLK;
    output [3:0] Q;
    wire w0,w1;
    assign w0=Q[0]&Q[1];
    assign w1=w0 & Q[2];
    jkflipflop
        j1(Q[0],1'b1,1'b1,CLK),
        j2(Q[1],Q[0],Q[0],CLK),
        j3(Q[2],w0,w0,CLK),
        j4(Q[3],w1,w1,CLK);
endmodule

module testbench;
    reg CLK;
    wire [3:0]Q;
    synccounter sync(Q,CLK);
    //integer i;
    always
        #2 CLK=~CLK;
    initial
        begin
            CLK=0;
            $monitor(,$time," OUT=%b",Q);
            #64 $finish;
            /*for(i=0;i<=20;i=i+1)
            begin
                #1 CLK=1;
                #1 CLK=2; 
                $monitor(,$time," OUT=%b",OUT);
            end*/
        end 
endmodule