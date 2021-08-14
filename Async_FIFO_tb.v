`timescale 1ns / 1ps

module Async_FIFO_tb;

	reg read_clk;
	reg write_clk;
	reg reset;

	wire [7:0] data_out;
	wire r_empty;
	wire w_full;

	Async_FIFO dut (
		.rd_clk(read_clk), 
		.wr_clk(write_clk), 
		.reset(reset), 
		.data_out(data_out), 
		.r_empty(r_empty), 
		.w_full(w_full)
	);

	initial begin
		
		read_clk = 0;
		write_clk = 0;
		reset = 1;
		#2 reset=0;
	end
		always begin
		#3 write_clk = ~write_clk;
		end
		always begin
		#30 read_clk = ~read_clk;
		end

      
endmodule

