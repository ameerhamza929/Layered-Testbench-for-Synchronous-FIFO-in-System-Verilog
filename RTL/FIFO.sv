module FIFO #(
	parameter width = 8,
	parameter depth = 16
)(
	if_a.UUT bus
);
	timeunit 1ns;
	timeprecision 1ps;
		
	logic [width-1:0] mem_array [0:depth-1];
	//logic [$clog2(depth):0] count;
	logic [$clog2(depth)-1:0] rd_ptr,wr_ptr;	
	integer i;
	always@(posedge bus.clk or negedge bus.rst_n)begin
		if(!bus.rst_n)begin
			bus.underflow <= 0;
			bus.overflow  <= 0;
			rd_ptr <= '0;
			wr_ptr <= '0;
			bus.dataout <= 0;
			for (i=0; i<depth; i++)begin
				mem_array[i] <= '0;
			end	
			bus.count <= '0;
		end
		else begin
			if(bus.wr_en)begin
				if(!bus.full)begin
					mem_array[wr_ptr]<= bus.datain;
					wr_ptr <= wr_ptr + 1;
				        bus.count <= bus.count + 1;				

				end
				else begin
					bus.overflow <= 1;
				end

			end
			if(bus.rd_en)begin	
				if(!bus.empty)begin
					bus.dataout <= mem_array[rd_ptr] ;
					rd_ptr <= rd_ptr + 1;
					bus.count <= bus.count - 1;	
				end
				else begin
					bus.underflow <= 1;
				end
							

			end
			if(!bus.empty || bus.wr_en) bus.underflow <= 0;
			if(!bus.full || bus.rd_en) bus.overflow <= 0;
		end		

	end
	
	/*always@(posedge bus.clk or negedge bus.rst_n)begin
		if(!bus.rst_n)begin
			bus.full <= 0;
			bus.empty <= 0;
		end
		else begin
			bus.full <= 0;
			bus.empty <= 0;
			if(count == depth) bus.full <= 1;
			if(count == 0) bus.empty <= 1; 
		end
	end*/

	assign bus.full = (bus.count == depth);
	assign bus.empty = (bus.count == 0);

	
endmodule