`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2016 01:57:56 PM
// Design Name: 
// Module Name: main
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


module main( input logic clk,
             input logic btnD, logic[2:0] sw,
             output logic[6:0] seg, logic[7:0]an,
             output logic RamCLK, logic RamADVn, logic RamCEn, logic RamCRE,
             output logic RamOEn, logic RamWEn, logic RamLBn, logic RamUBn, logic
 RamWait,
             output logic[22:0] MemAdr, 
             inout logic[15:0] MemDB);
             
             
           /*  how to use inout
             inout a,b;
             input wire enable;
             
             wire a_out, b_out;
             wire a_in, b_in;
             
             //output assignment of inout port
             assign a = (enable) ? a_out : 1'bz;
             assign b = (enable) ? b_out : 1'bz;
             
             //input assignment of inout port
             assign a_in = (enable) ? a : 1'bz;
             assign b_in = (enable) ? b : 1'bz;
             
             */
             
endmodule
