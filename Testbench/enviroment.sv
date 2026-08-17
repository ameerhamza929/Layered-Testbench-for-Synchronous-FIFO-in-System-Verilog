class enviroment;
	mailbox#(transaction) mbx;
	mailbox#(transaction) mn2scb;
	Generator gr;
	Driver dr;	
	monitor mn;
	scoreboard sc;
	virtual if_a bus;

	function new(virtual if_a bus);
		this.bus = bus;
		mbx = new;
		mn2scb = new;
		gr = new(mbx);
		dr = new(mbx,bus);
		mn = new(bus,mn2scb);
		sc = new(mn2scb);
	endfunction
	
	task run;
		fork
			gr.run;
			dr.run;
			mn.run;
			sc.run;
		join_any
		repeat(1020)@(posedge bus.clk);
		$display ("No. of fails encountered are : %d",sc.countfail);
		$display ("Underflow encountered: %d",sc.countunderflow);
		$display ("Overflow encountered: %d",sc.countoverflow);
		$display ("Reads encountered: %d",sc.countread);
		$display ("Writes encountered: %d",sc.countwrite);
		$finish;

	endtask 		
	


endclass