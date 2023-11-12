module TX (
    input wire clk,
    input wire rst,
    input wire en,
    input wire [7:0] tx_data,
    input wire boud_in,

    output reg tx
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
            tx = 1'b1;
            if(en) begin
                nextstate = START;
                counter16 = 0;
                
            end
      
        end
        START: begin
            tx = 1'b0;
            if(counter16 == 4'b1111) begin
                nextstate = DATA0;
                counter16 = 0;
                
            end
        
        end
        DATA0: begin
            tx = tx_data[0];
            if(counter16 == 4'b1111) begin
                nextstate = DATA1;
                counter16 = 0;
                
            end
        end
        DATA1: begin
             tx = tx_data[1];
            if(counter16 == 4'b1111) begin
                nextstate = DATA2;
                counter16 = 0;
               
            end
        end
        DATA2: begin
             tx = tx_data[2];
            if(counter16 == 4'b1111) begin
                nextstate = DATA3;
                counter16 = 0;
               
            end
        end
        DATA3: begin
            tx = tx_data[3];
            if(counter16 == 4'b1111) begin
                nextstate = DATA4;
                counter16 = 0;
                
            end
        end
        DATA4: begin
            tx = tx_data[4];
            if(counter16 == 4'b1111) begin
                nextstate = DATA5;
                counter16 = 0;
                
            end
        end
        DATA5: begin
            tx = tx_data[5];
            if(counter16 == 4'b1111) begin
                nextstate = DATA6;
                
            end
        end
        DATA6: begin
             tx = tx_data[6];
            if(counter16 == 4'b1111) begin
                nextstate = DATA7;
                counter16 = 0;
               
            end
        end
        DATA7: begin
            tx = tx_data[7];
            if(counter16 == 4'b1111) begin
                nextstate = STOP;
                counter16 = 0;
                
            end
        end
        STOP: begin
            if(counter16 == 4'b1111) begin
                nextstate = IDLE;
                counter16 = 0;
                tx = 1'b1;
            end
        end

        default: nextstate = IDLE;
    endcase
    
end



    
endmodule