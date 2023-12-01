`timescale 1ns/1ps
module UART_tb ();
    reg clk;
    reg rst;
    reg en;
    reg [1:0] addr;

    reg [7:0] wdata;
    reg re;
    reg we;
    wire rx_reg;

    

UART u_UART (
    .clk(clk),
    .rst(rst),
    .en(en),
    .addr(addr),
    .re(re),
    .we(we),

    .wdata(wdata)
   
);

initial begin
    rst = 1'b1;

   
    clk = 1'b1;
    en = 1'b1;
    we=1'b1;


    re=1'b1;
    addr=2'b01;

    
    #50 rst = 1'b0;
    #50 en=1'b0;
    we=1'b1;
    addr=2'b10;
    wdata = 8'd130;
    #50;
    we=1'b1;
    addr=2'b00;
    wdata = 8'b11110000;
    #50;
      re=1'b1;
    addr=2'b01;
    #50;
    
    
    


    #10000000;
    $finish;

end

always begin
        #25;
        clk = ~clk;
end

initial begin
        $dumpfile("UART.vcd");
        $dumpvars(0,UART_tb);
end

endmodule