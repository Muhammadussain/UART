module tx_2 (
  input wire clk,
  input wire rst,
  input wire [7:0] tx_data,
  input wire boud_in,
  input wire en, 
  output reg tx
);

  localparam IDLE = 2'b00;
  localparam START = 2'b01;
  localparam DATA = 2'b10;
  localparam STOP = 2'b11;

  reg [1:0] state;
  reg [1:0] nextstate;
  reg [4:0] statecounter;
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
        tx = 1'b1;
        datacounter = 3'b0;
        if (en) begin
          nextstate = START;
        end
      end

      START: begin
        tx = 1'b0;
        datacounter = 3'b0;
        if (statecounter == 4'b1111) begin
          nextstate = DATA;
           shiftreg=tx_data;
        end
      end   

      DATA: begin
        if(statecounter==4'b1111)begin
        tx <= shiftreg[7];
         shiftreg = {shiftreg[6:0],1'b0};
        end
        else if (datacounter == 4'b1001) begin
          nextstate = STOP;
          datacounter =0;
        end
      end

      STOP: begin
        if (statecounter == 4'b1111)
          nextstate = IDLE;
        tx = 1'b1;
      end

      default: nextstate = IDLE;
    endcase
  end

endmodule
