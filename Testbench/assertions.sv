module mod_checker #(
	parameter width = 8,
	parameter depth = 16)( if_a.TB bus);
	
	timeunit 1ns;
	timeprecision 1ps;

	property range_safety; 
		@(posedge bus.clk)
		(bus.count >=0) && (bus.count <=depth);
	endproperty

	property flag_consis;
		@(posedge bus.clk)
		 (bus.empty |-> (bus.count == 0))
		 and
		 (bus.full |-> (bus.count == depth));
	endproperty

	property mutual_exclusion;
		@(posedge bus.clk)
		bus.full |-> !bus.empty;
	endproperty

	property reset;
		@(posedge bus.clk) disable iff (bus.rst_n)
		(bus.empty == 1)
		and
		(bus.full == 0)
		and
		(bus.underflow == 0)
		and
		(bus.overflow == 0)
		and
		(bus.dataout == 0)
	endproperty

	property legal_write;
		@(posedge bus.clk) disable iff (!bus.rst_n || bus.full)
		bus.wr_en |=> (bus.count == $past(bus.count)+1);
	endproperty

	property legal_read;
		@(posedge bus.clk) disable iff (!bus.rst_n || bus.empty)
		bus.rd_en |=> (bus.count == $past(bus.count)-1);
	endproperty

	property block_write;
		@(posedge bus.clk)
		(bus.wr_en && bus.full) |=> (bus.count == $past(bus.count));
	endproperty

	property block_read;
		@(posedge bus.clk)
		(bus.rd_en && bus.empty) |=> (bus.count == $past(bus.count));
	endproperty

	property overflow;
		@(posedge bus.clk)
		($past(bus.wr_en) && bus.full && $past(bus.full)) |-> (bus.overflow);
	endproperty

	property underflow;
		@(posedge bus.clk)
		($past(bus.rd_en) && bus.empty && $past(bus.empty)) |-> (bus.underflow);
	endproperty

	property legal_op;
		@(posedge bus.clk)
		((bus.wr_en && !bus.full) |-> (!bus.overflow))
		or
		((bus.rd_en && !bus.empty) |-> (!bus.underflow));
	endproperty

	property known_sig;
		@(posedge bus.clk) 
		(!$isunknown(bus.overflow))
		or
		(!$isunknown(bus.full))
		or
		(!$isunknown(bus.empty))
		or
		(!$isunknown(bus.dataout)); // check tommowrow
	endproperty

	property dataout_change;
		@(posedge bus.clk)disable iff(bus.empty)
		(bus.rd_en) |=> (bus.dataout != $past(bus.dataout));

	endproperty

	assert property (dataout_change)
	else $error ("Dataout on Read has failed");


	assert property(known_sig)
	else $error ("known signal value is failed");

	assert property (legal_op)
	else $error("Legal op failed");

	assert property (underflow)
	else $error("underflow is not working");

	assert property (overflow) $display("current interface values are: rst_n = %d | wr_en = %d | rd_en = %d | datain = %d | dataout = %d | full = %d | empty = %d | overflow = %d | underflow = %d | dataout = %d | count = %d",bus.rst_n,bus.wr_en,bus.rd_en,bus.datain,bus.dataout,bus.full,bus.empty,bus.overflow,bus.underflow, bus.dataout,bus.count);
	else $error("Overflow is not working");

	assert property (block_read)
	else $error("Read is not blocking");

	assert property (legal_read)
	else $error("Read is not legal"); 
	
	assert property (block_write)
	else $error("Write is not blocking");

	assert property(legal_write)
	else $error("Write is not legal");

	assert property(reset)
	else $error("Reset Failed");

	assert property(mutual_exclusion)
	else $error("Mutual exclusion failed");

	assert property(flag_consis)
	else $error("flag_consis failed");

	assert property(range_safety) //$display("assert working");
	else $error("Range safety failed");


	

endmodule