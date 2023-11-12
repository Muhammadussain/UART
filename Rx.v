module rx (
    input wire clk,
    input wire rst,
    input wire en,
    input wire data,
    input wire boud_in,
     output reg rx_reg
 
);

reg [3:0] counter16;


localparam IDLE = 4'b1011;
localparam START = 4'b0000;
localparam DATA0 = 4'b0001;
localparam DATA1 = 4'b0010;
localparam DATA2 = 4'b0011;
localparam DATA3 = 4'b0100;
localparam DATA4 = 4'b0101;
localparam DATA5 = 4'b0110;
localparam DATA6 = 4'b0111;
localparam DATA7 = 4'b1000;
localparam STOP = 4'b1001;

reg [3:0] state;
reg [3:0] nextstate;

always @(posedge clk ) begin
    if (rst) begin
        state <= IDLE;
        counter16 <= 0;
        rx_reg<=0;
    end
    else begin
        state <= nextstate;
        if (counter16 == 4'b1111) begin
            counter16 <= 0;
        end
        else if(boud_in) begin
            counter16 <= counter16 + 1;
        end
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            if(en) begin
                nextstate = START;
                counter16 = 0;
              
            end
          
        end
        START: begin
            if(counter16 == 4'b1000) begin
                nextstate = DATA0;
                counter16 = 0;
              
            end
           
        end
        DATA0: begin
            rx_reg = data;
            if(counter16 == 4'b1111) begin
                nextstate = DATA1;
                counter16 = 0;
                
            end
        end
        DATA1: begin
            rx_reg = data;
            if(counter16 == 4'b1111) begin
                nextstate = DATA2;
                counter16 = 0;
               
            end
        end
        DATA2: begin
            rx_reg = data;
            if(counter16 == 4'b1111) begin
                nextstate = DATA3;
                counter16 = 0;
                
            end
        end
        DATA3: begin
            rx_reg = data;
            if(counter16 == 4'b1111) begin
                nextstate = DATA4;
                counter16 = 0;
                
            end
        end
        DATA4: begin
             rx_reg = data;
            if(counter16 == 4'b1111) begin
                nextstate = DATA5;
                counter16 = 0;
               
            end
        end
        DATA5: begin
            rx_reg = data;
            if(counter16 == 4'b1111) begin
                nextstate = DATA6;
                
            end
        end
        DATA6: begin
            rx_reg = data;
            if(counter16 == 4'b1111) begin
                nextstate = DATA7;
                counter16 = 0;
                
            end
        end
        DATA7: begin
            rx_reg = data;
            if(counter16 == 4'b1111) begin
                nextstate = STOP;
                counter16 = 0;
                
            end
        end
        STOP: begin
            if(counter16 == 4'b1111) begin
                nextstate = IDLE;
                counter16 = 0;
               //rx_reg = 1'b1;
            end
        end

        default: nextstate = IDLE;
    endcase
    
end



    
endmodule