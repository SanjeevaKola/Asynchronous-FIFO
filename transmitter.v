`timescale 1ns / 1ps

module transmitter(wr_ptr,data_out);

reg [7:0] input_RAM [127:0];
output [7:0] data_out;
input [7:0] wr_ptr;

integer k;
initial begin

for(k=0;k<64;k=k+1)
input_RAM[k] = k;
end

assign data_out = input_RAM[wr_ptr];

endmodule