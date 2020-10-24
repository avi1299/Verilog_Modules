module mux (a,b,s,f); 
    input a,b,s;
    output f;
    assign f = s ? a : b;
endmodule