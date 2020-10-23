module bcdgraygate (bcd,gray)

parameter WIDTH=4;
output [WIDTH-1 : 0] gray;
input  [WIDTH-1 : 0] bcd;