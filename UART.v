module UART (
    
    input wire clk,
    input wire rst,
    input wire en,
    input wire [1:0] addr,
    input wire [7:0] wdata,
    input wire re,
    output wire  rx_reg,
    input wire we
);
wire tx;


reg [7:0] txd;
reg [7:0] Br;
reg [7:0] rxd;

wire [7:0] tx_data;
wire boud_in;
wire  boud_tick;
reg [7:0] rxout;

always@(*)begin

rxout=rx_reg;


end


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
TX u_TX(
    .clk(clk),
    .rst(rst),
    .en(en),
    .tx_data(txd),
    .boud_in(boud_tick),
    .tx(tx)
    );
rx u_rx(
    .clk(clk),
    .rst(rst),
    .en(en),
    .data(tx),
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