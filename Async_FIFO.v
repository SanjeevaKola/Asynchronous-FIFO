`timescale 1ns / 1ps

module Async_FIFO(rd_clk,wr_clk,reset,data_out,r_empty,w_full);

parameter ptr =4;
parameter width=8;
parameter depth= 1<< ptr;

input rd_clk,wr_clk;
input reset;
output w_full,r_empty;
output [width-1 : 0] data_out;

wire [width-1 :0] data_in;
wire [ptr:0] rd_ptr_grey, wr_ptr_grey;
wire [ptr:0] rd_ptr_bin, wr_ptr_bin;

reg [ptr:0] rd_ptr,read_s1,read_s2;
reg [ptr:0] wr_ptr,write_s1,write_s2;
reg [width-1:0] mem[depth-1:0];
reg [7:0] transmitter_ptr;
reg full,empty;

always @(posedge reset or posedge wr_clk)
begin
	if (reset) begin
		wr_ptr <=0;
		transmitter_ptr <=0;
	end
	else if (full == 1'b0) begin
		wr_ptr <= wr_ptr+1;
		transmitter_ptr<= transmitter_ptr+1;
		mem[wr_ptr[ptr-1:0]]<= data_in;
	end
end

transmitter t(transmitter_ptr,data_in);


always @(posedge wr_clk) begin
	read_s1 <= rd_ptr_grey;
	read_s2 <= read_s1;
end


always @(posedge reset or posedge rd_clk) 
begin
	if (reset) begin
		rd_ptr <=0;
	end
	else if(empty ==1'b0) begin
		rd_ptr <= rd_ptr +1;
	end
end

always @ (posedge rd_clk) begin
	write_s1 <= wr_ptr_grey;
	write_s2 <= write_s1;
end



always @(*)
begin	
	if(wr_ptr_bin==rd_ptr)
		empty=1;
	else
		empty=0;
end

always @(*)
begin
	if({~wr_ptr[ptr],wr_ptr[ptr-1:0]}==rd_ptr_bin)
		full = 1;
	else
		full = 0;
end
	
	assign data_out = mem[rd_ptr[ptr-1 : 0]];
	assign w_full = full;
	assign r_empty=empty;
	
	assign wr_ptr_grey = wr_ptr ^ (wr_ptr >> 1);
    assign rd_ptr_grey = rd_ptr ^ (rd_ptr >> 1);
	
	assign wr_ptr_bin[4]=write_s2[4];
	assign wr_ptr_bin[3]=write_s2[3] ^ wr_ptr_bin[4];
	assign wr_ptr_bin[2]=write_s2[2] ^ wr_ptr_bin[3];
	assign wr_ptr_bin[1]=write_s2[1] ^ wr_ptr_bin[2];
	assign wr_ptr_bin[0]=write_s2[0] ^ wr_ptr_bin[1];
	
	assign rd_ptr_bin[4]=read_s2[4];
	assign rd_ptr_bin[3]=read_s2[3] ^ rd_ptr_bin[4];
	assign rd_ptr_bin[2]=read_s2[2] ^ rd_ptr_bin[3];
	assign rd_ptr_bin[1]=read_s2[1] ^ rd_ptr_bin[2];
	assign rd_ptr_bin[0]=read_s2[0] ^ rd_ptr_bin[1];

endmodule
	

	

	

	
	
	