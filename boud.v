module boud_rate (
    input wire clk,
    input wire rst,
    input wire [7:0]num,

    output reg boud_tick
);

reg [7:0] counter;

always @(posedge clk) begin
    if(rst) begin
        counter <= 0;
        boud_tick <=0;
    end
    else begin
        if (counter == num) begin
        counter <= 0;
        boud_tick = 1'b1;
    end
    else begin
        counter <= counter + 1;
        boud_tick = 1'b0;
    end
    end
    
end
endmodule