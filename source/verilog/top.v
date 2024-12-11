`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ChrisBowman.com
// Engineer: Christopher R. Bowman
// email: <my initials>@ChrisBowman.com
// 
// Create Date: 20/09/2023 19:52:52 PM
// Design Name: 
// Module Name: top
// Project Name: zynq_static_leds
// Target Devices: xc7z020clg400-1
// Tool Versions: 2023.1
// Description: simple project using only the fabric.  Set a static pattern on
// the leds
// 
// Dependencies: none
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    output [3:0] led
);

assign led = { 1'b1, 1'b0, 1'b1, 1'b0 };

endmodule
