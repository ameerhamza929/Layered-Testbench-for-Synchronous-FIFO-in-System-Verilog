module topped;
	
	parameter width = 8;
	parameter depth = 16; 
	logic clk = 0;
	initial begin
		forever #5 clk = ~clk;
	end

	if_a #(
		.width(width),
		.depth(depth)
	)bus (.clk(clk));

	FIFO #(
		.width(width),
		.depth(depth)
	)DUT(
		bus.UUT
	);
	
	tb_FIFO TB( bus.TB);


endmodule