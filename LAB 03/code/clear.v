module dff_sync_clear(d, clearb, clock, q);
    input d, clearb, clock;
    output q;
    reg q;
    always @ (posedge clock)
        begin
            if (!clearb) q <= d;
            else q <= 1'b0;
        end
endmodule

module dff_async_clear(d, clearb, clock, q);
    input d, clearb, clock;
    output q;
    reg q;
    always @ (clearb or posedge clock)
        begin
            if (!clearb) q <= d;
            else q <= 1'b0;
        end
endmodule

//The reset should be 0 to allow Q to be set according to D. Else with reset = 1, Q=0 
module Testing;
    reg d, clk, rst;
    wire q;
    dff_sync_clear dff (d, rst, clk, q); 
    //dff_async_clear dff (d, rst,clk, q);
    //Always at rising edge of clock display the signals
    always @(posedge clk)
        begin
            $display(,$time," d=%b, clk=%b, rst=%b, q=%b\n", d, clk, rst, q);
        end
    //Module to generate clock with period 10 time units
    initial 
        begin
            forever 
                begin
                    clk=0;
                    #5 clk=1;
                    #5 clk=0;
                end
        end
    initial 
        begin
            #1 d=0; rst=1;
            #3 d=1; rst=0;
            #50 d=1; rst=1;
            #20 d=0; rst=0;
            #1 $finish;
        end
endmodule

