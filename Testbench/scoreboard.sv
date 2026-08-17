class scoreboard#(parameter width = 8, parameter depth = 16);
	mailbox#(transaction)mn2scb;

	logic [width-1:0] mem_array [$:depth-1];
	logic [$clog2(depth):0] count;	
	logic full,empty,overflow,underflow;
	logic [width-1:0] expected_data;
	int countfail = 0;
	int countunderflow = 0;				
	int countoverflow = 0;
	int countread = 0;
	int countwrite = 0;
	function new(mailbox#(transaction)mn2scb);
		this.mn2scb = mn2scb;
	endfunction	
	
	task run;
		forever begin
			transaction tr;
			mn2scb.get(tr);	
			if(!tr.rst_n)begin
				count = 0;
				full = 0;
				empty = 1;
				overflow = 0;
				underflow = 0;
				expected_data = 0;
				//empty = 1;
				//full = 0;
			end
			else begin
				if(tr.wr_en && !full)begin			
					mem_array.push_front(tr.datain);
					count++;
					expected_data = expected_data;
					countwrite++;
				end
				else if(tr.rd_en && !empty)begin
					expected_data = mem_array.pop_back();
					count--;
					countread++;
				end
				if(tr.rd_en && empty) begin underflow = 1; countunderflow++; end
				else underflow = 0;
				if(tr.wr_en && full) begin overflow = 1; countoverflow++; end
				else overflow = 0;
				if(mem_array.size == 0) empty = 1;
				else empty = 0;
				if(mem_array.size == depth) full = 1;
				else full = 0;
				
				
			end	

			if(tr.dataout == expected_data && tr.overflow == overflow && tr.underflow == underflow && tr.empty == empty && tr.full == full)begin
				$display("PASS |||| ID = %d, the transaction is wr_en = %d, rd_en = %d,datain = %d, while  exp_full = %d and act_full = %d | exp_empty = %d and act_empty = %d | exp_overflow = %d and act_overflow = %d | exp_underflow = %d and act_underflow = %d | exp_dataout = %d and act_dataout = %d",tr.id,tr.wr_en,tr.rd_en,tr.datain, full,tr.full,empty,tr.empty,overflow,tr.overflow,underflow,tr.underflow, expected_data,tr.dataout);

			end  	
			else begin
				countfail++;
				$display("FAIL |||| ID = %d, the transaction is wr_en = %d, rd_en = %d,datain = %d, while  exp_full = %d and act_full = %d | exp_empty = %d and act_empty = %d | exp_overflow = %d and act_overflow = %d | exp_underflow = %d and act_underflow = %d | exp_dataout = %d and act_dataout = %d",tr.id,tr.wr_en,tr.rd_en,tr.datain, full,tr.full,empty,tr.empty,overflow,tr.overflow,underflow,tr.underflow, expected_data,tr.dataout);
			end
			
		end
	endtask
	
	
endclass