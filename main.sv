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


module main( input logic sw[1:0], logic btnD, logic btnU,
             input logic[7:0] JA, logic[7:0] JB, logic[7:0] JC, logic[7:0] JD,
             output logic[6:0] seg, logic[7:0]an,
             output logic [3:0] vgaRed, logic [3:0] vgaBlue, logic [3:0] vgaGreen, logic Vsync, logic Hsync);
             
    logic[15:0]vcount;
    logic[11:0]hcount;
    logic[11:0]endcount;
    logic[11:0]line;
    logic[11:0]store = 0;
    logic[11:0]fetch = 0;
    logic[11:0]ram[3200];
    logic[15:0]maxhcount;
    logic[15:0]maxline;
    logic hstate;
    logic vdelay[2784];
    logic[11:0]i;
    logic[11:0]j;
    

    //JA now blue
    //JB now red
    //JC green
    //JD[1] is DE
    //JD[2] is HSync
    //JD[3] is VSync
    
    
        always_ff@(negedge JD[0])begin
            if(!sw[0])begin //pass through
                if(JD[1])begin
                    vgaBlue <= JA[7:4];
                    vgaRed <= JB[7:4];
                    vgaGreen <= JC[7:4];
                end
                else begin
                    vgaBlue <= 0;
                    vgaRed <= 0;
                    vgaGreen <= 0;
                end
   
            end // pass through
            
            if(!JD[3])begin
                store <= 0; //reset store
                fetch <= 0;
                line <= 0;
                endcount <= 0;
            end
            
            if(store >= 3199) store <= 0; //reset every four lines
            if(fetch >= 3199) fetch <= 0;
            
            if(sw[0]) begin // 3 line buffer
                
                if(JD[1])begin
                   ram[store] <= {JA[7:4],JB[7:4],JC[7:4]};
                   store <= store + 1;
                   hcount <= hcount + 1;
                end
                
                if(hcount == 800) begin
                    line <= line + 1; //maxvalue of hcount is 800 (gets to 800)
                    hcount <= 0;
                end
                                               
                if(line == 483) line <= 0;
                                                    
                if(line >= 480 && !JD[1] && endcount < 927) endcount <= endcount + 1;
                else endcount <= 0;
                                                    
                if(JD[1] && line >= 3)begin
                    vgaBlue <= ram[fetch][11:8];
                    vgaRed <= ram[fetch][7:4];
                    vgaGreen <= ram[fetch][3:0];
                    fetch <= fetch + 1;
                end
                else if(line >= 480 && line <= 482 && endcount > 126 && endcount < 927)begin
                    vgaBlue <= ram[fetch][11:8];
                    vgaRed <= ram[fetch][7:4];
                    vgaGreen <= ram[fetch][3:0];
                    fetch <= fetch + 1;
                    hcount <= hcount + 1;
                end
                else begin
                    vgaBlue <= 0;
                    vgaRed <= 0;
                    vgaGreen <= 0;
                end
                
                if(endcount > maxhcount) maxhcount <= endcount;
                if(line > maxline) maxline <= line;
            end // 3 line buffer
            
            
            if(sw[1] && !sw[0]) begin // threshold
                            
                            if(JD[1])begin
                               ram[store] <= (JA[7:4] + JB[7:4] + JC[7:4]);
                               store <= store + 1;
                               hcount <= hcount + 1;
                            end
                            
                            if(hcount == 800) begin
                                line <= line + 1; //maxvalue of hcount is 800 (gets to 800)
                                hcount <= 0;
                            end
                                                           
                            if(line == 483) line <= 0;
                                                                
                            if(line >= 480 && !JD[1] && endcount < 927) endcount <= endcount + 1;
                            else endcount <= 0;
                                                                
                            if(JD[1] && line >= 3)begin
                                if(ram[fetch] / 3 > 8)begin
                                    vgaBlue <= 15;
                                    vgaRed <= 15;
                                    vgaGreen <= 15;
                                end
                                else begin
                                    vgaBlue <= 0;
                                    vgaRed <= 0;
                                    vgaGreen <= 0;
                                end
                                fetch <= fetch + 1;
                            end
                            else if(line >= 480 && line <= 482 && endcount > 126 && endcount < 927)begin
                                if(ram[fetch] / 3 > 7)begin
                                    vgaBlue <= 15;
                                    vgaRed <= 15;
                                    vgaGreen <= 15;
                                end
                                else begin
                                    vgaBlue <= 0;
                                    vgaRed <= 0;
                                    vgaGreen <= 0;
                                end
                                fetch <= fetch + 1;
                                hcount <= hcount + 1;
                            end
                            else begin
                                vgaBlue <= 0;
                                vgaRed <= 0;
                                vgaGreen <= 0;
                            end
                            
                            if(endcount > maxhcount) maxhcount <= endcount;
                            if(line > maxline) maxline <= line;
                        end // threshold
            

            if(i < 2783) i <= i + 1;
            else i <= 0;
            
            if(i < 2783) j <= i + 1;
            else j <= 0;

            vdelay[i] <= JD[3];

//            if(sw[0]||sw[1])Vsync <= vdelay[j];
//            else 
            Vsync <= JD[3];
            Hsync <= JD[2];
            
            if(i > maxline)maxline <= i;
            if(j > maxhcount)maxhcount <= j;
            
            
        end
        
        
    Display data(JD[0], maxline[15:0], maxhcount[15:0], seg, an);
    
endmodule
