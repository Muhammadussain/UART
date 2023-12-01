module UART (
    
    input wire clk,
    input wire rst,
    input wire en,
    input wire [1:0] addr,
    input wire [7:0] wdata,
    input wire re,
    output reg [7:0] rxd,
    input wire we
);
wire tx;

wire [7:0] rx_reg;
reg [7:0] txd;
reg [7:0] Br;

wire [7:0] tx_data;
wire boud_in;
wire  boud_tick;
reg [7:0] rxout;

always @(*) begin
    case (addr) 
        2'b00: if (we)begin
            txd=wdata;
        end
        2'b01: if (re)begin
            rxd=rx_reg;
        end
        2'b10: if (we)begin
            Br=wdata;
        end
      
        
    endcase
end
tx_2 u_tx2(
    .clk(clk),
    .rst(rst),
    .en(en),
    .tx_data(txd),
    .boud_in(boud_tick),
    .tx(tx)
    );
rx_2 u_rx_2(
    .clk(clk),
    .rst(rst),
    .en(en),
    .data_rx(tx),
    .rx_reg(rx_reg),
    .boud_in(boud_tick)

);

boud_rate u_boud_rate (
   .clk(clk),
    .rst(rst),
    .num(Br),
    .boud_tick(boud_tick)
);

endmodule