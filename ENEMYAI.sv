`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2026 02:04:35 PM
// Design Name: 
// Module Name: ENEMYAI
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ENEMYAI(
    input logic clk,
    input logic move_signal,
    output logic [1:0] move_select_ai
    );
    
    logic [1:0] counter;
    
    always_ff @(posedge clk) begin
    counter <= counter+1;
    
        if(counter == 2'b11)begin
            counter <= 2'b00; 
            end
            
    end
    always_comb begin
    
    if(move_signal == 1'b1) begin
        move_select_ai = counter;
    end
    else begin
        move_select_ai = 2'b0;
    end
    
    end
    
    
    
    
    
    
endmodule
