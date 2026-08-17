class Test;

    enviroment en;
    virtual if_a bus;

    function new(virtual if_a bus);
        this.bus = bus;
        en = new(bus);
    endfunction

    task run();
    begin
        en.run();
    end
    endtask

endclass