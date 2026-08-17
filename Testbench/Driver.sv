class Driver;
	mailbox#(transaction) mbx;
	event done;
	virtual if_a bus;	
	
	function new(mailbox#(transaction) mbx,virtual if_a bus);
		this.mbx = mbx;
		this.bus = bus;
	endfunction
	


	task run;
		transaction tr;
		bus.rst_n = 0;
		#10;
		bus.rst_n = 1;
		forever begin
			@(negedge bus.clk)
			mbx.get(tr);
			bus.wr_en = tr.wr_en;
			bus.rd_en = tr.rd_en;
			bus.datain = tr.datain;
			//$display("we at bus.datain = %d, bus.rd_en= %d and bus.wr_en = %d ",bus.datain,bus.rd_en,bus.wr_en);
		end

	endtask


endclass