interface if_a #(
parameter width = 8,
parameter depth = 16) (input clk);
	timeunit 1ns;
	timeprecision 1ps;
	logic rst_n;
	logic wr_en;
	logic rd_en;
	logic [width-1:0] datain;
	logic [width-1:0] dataout;
	logic full;
	logic empty;
	logic overflow;
	logic underflow;
	logic [$clog2(depth):0]count;

	modport UUT (input rst_n,wr_en, rd_en, datain,clk, output dataout, full, empty, overflow, underflow,count);
	modport TB (output rst_n,wr_en, rd_en, datain, input dataout, full, empty, overflow, 		underflow,count,clk);	
	
	/*clocking cb @(posedge clk)
		default input #1step output #2ns		
		input dataout, full, empty, overflow,underflow;
		output rst_n,wr_en, rd_en, datain;
	endclocking*/

endinterface