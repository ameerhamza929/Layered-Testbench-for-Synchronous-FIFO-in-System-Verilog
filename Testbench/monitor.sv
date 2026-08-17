class monitor;
	virtual if_a bus; 
	mailbox#(transaction) mn2scb;

	function new(virtual if_a bus,mailbox#(transaction) mn2scb);
		this.bus = bus;
		this.mn2scb = mn2scb;
	endfunction	

	task run;
		transaction tr;
		$display("Monitor starting.....");
		forever begin
			@(posedge bus.clk)
			
			$display("current interface values are: rst_n = %d | wr_en = %d | rd_en = %d | datain = %d | dataout = %d | full = %d | empty = %d | overflow = %d | underflow = %d | dataout = %d | count = %d",bus.rst_n,bus.wr_en,bus.rd_en,bus.datain,bus.dataout,bus.full,bus.empty,bus.overflow,bus.underflow, bus.dataout,bus.count);
			#0.5ns;
			tr = new;
			tr.rst_n = bus.rst_n;
			tr.wr_en = bus.wr_en;
			tr.rd_en = bus.rd_en;
			tr.datain = bus.datain;
			tr.dataout = bus.dataout;
			tr.full  = bus.full;
			tr.empty = bus.empty;
			tr.overflow = bus.overflow;
			tr.underflow = bus.underflow;
			tr.dataout = bus.dataout;
			mn2scb.put(tr);
		end
	endtask

endclass