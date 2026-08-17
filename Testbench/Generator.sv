class Generator;
	mailbox#(transaction) mbx;
	event done;

	function new(mailbox#(transaction) mbx);
		this.mbx = mbx;
	endfunction

	task run;
		for(int i = 0; i<1000;i++)begin
			transaction tr = new;
			void'(tr.randomize());
			//tr.wr_en = 1;
			//tr.display;
			mbx.put(tr);
		end
	endtask
	

endclass