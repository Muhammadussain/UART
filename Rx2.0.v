module rx_2 (
  input wire clk,
  input wire rst,
  input wire  data_rx,
  input wire boud_in,
  input wire en,
  output reg [7:0] rx_reg
);

  localparam IDLE = 2'b00;
  localparam START = 2'b01;
  localparam DATA = 2'b10;
  localparam STOP = 2'b11;

  reg [7:0] int_reg=8'b00000000;

  reg [1:0] state;
  reg [1:0] nextstate;
  reg [3:0] statecounter=4'b0000;
  reg [7:0] shiftreg = 8'd0;
  reg [3:0] datacounter = 4'b0;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      state <= IDLE;
      statecounter <= 0;
    end
    else begin
      state <= nextstate;
      if (statecounter == 4'b1111) begin
        statecounter <= 0;
      end
      else if (boud_in) begin
        statecounter <= statecounter + 1;
      end
      if (state == DATA) begin
        if (statecounter == 4'b1111) begin
          datacounter <= datacounter + 1;
        end
      end
    end
  end

  always @(*) begin
   
    case (state)
      IDLE: begin
        datacounter = 3'b0;
        if (en) begin
          nextstate = START;
        end
      end

      START: begin
        datacounter = 3'b0;
        if (statecounter == 4'b1000) begin
          nextstate = DATA;
       
          
        end
      end   

      DATA: begin
        if(statecounter==4'b1111)begin
        int_reg [0] <= data_rx;
        int_reg = {int_reg[6:0],data_rx};
        end
        else if (datacounter == 4'b1001) begin
          nextstate = STOP;
          datacounter =0;
        end
      end

      STOP: begin
        if (statecounter == 4'b1111)
          nextstate = IDLE;
      
      end

      default: nextstate = IDLE;
    endcase
  end
initial begin
    
assign  rx_reg= int_reg;
end
endmodule
