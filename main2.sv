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
    logic[11:0]whitecount;
    logic[11:0]maxwhitecount;
    logic[11:0]x;
    logic[11:0]y;
    logic[11:0]finaly;
    logic[11:0]finalx;
    logic xstate;
    logic[11:0]leftx;
    logic[11:0]rightx;
    logic[15:0]maxhcount;
    logic[15:0]maxline;
    logic hstate;
    logic[11:0]i;
    logic[11:0]j;
    

    //JA now blue
    //JB now red
    //JC green
    //JD[0] is clk
    //JD[1] is DE
    //JD[2] is HSync
    //JD[3] is VSync
    
//    if(JD[1])begin
//        vgaBlue <= JA[7:4];
//        vgaRed <= JB[7:4];
//        vgaGreen <= JC[7:4];
//    end
//    else begin
//        vgaBlue <= 0;
//        vgaRed <= 0;
//        vgaGreen <= 0;
//    end
    
    
    always_ff@(negedge JD[0])begin
        
        if(!JD[3])begin //reset maxwhitecount and line for new frame
            finaly <= y;
            finalx <= x;
            maxwhitecount <= 0;
            line <= 0;
            xstate <= 0;
        end
                        
        if(JD[1])begin //DE has gone high writing data
            hcount <= hcount + 1;
        
            if(((JA[7:4] + JB[7:4] + JC[7:4]) / 3) > 9)begin
                whitecount <= whitecount + 1;
            end
            
            if((((JA[7:4] + JB[7:4] + JC[7:4]) / 3) > 9) && xstate == 0)begin
                leftx <= hcount;
                xstate <= 1;
            end
            
            if((((JA[7:4] + JB[7:4] + JC[7:4]) / 3) < 9) && xstate == 1)begin
                rightx <= hcount - 1;
                xstate <= 0;
            end
        end
        
        if(hcount == 800) begin
            if(whitecount > maxwhitecount)begin
                maxwhitecount <= whitecount;
                y <= line;
                x <= (leftx + rightx)/ 2;
            end
            line <= line + 1; //maxvalue of hcount is 800 (gets to 800)
            whitecount <= 0;
            leftx <= 0;
            rightx <= 0;
            hcount <= 0;
        end
                                           
  
        if(endcount > maxhcount) maxhcount <= endcount;
        if(line > maxline) maxline <= line;
             

        if(JD[1] && (line + 3 == finaly || line + 2 == finaly || line + 1 == finaly) && hcount == finalx)begin
            vgaBlue <= 15;
            vgaRed <= 15;
            vgaGreen <= 15;
        end
        else if(JD[1] && (line == finaly) && (hcount + 3 == finalx || hcount + 2 == finalx || hcount + 1 == finalx || hcount == finalx || hcount - 1 == finalx || hcount - 2 == finalx || hcount - 3 == finalx))begin
            vgaBlue <= 15;
            vgaRed <= 15;
            vgaGreen <= 15;
        end
        else if(JD[1] && (line - 1 == finaly || line - 2 == finaly || line - 3 == finaly) && hcount == finalx)begin
            vgaBlue <= 15;
            vgaRed <= 15;
            vgaGreen <= 15;
        end
        else begin
            vgaBlue <= 0;
            vgaRed <= 0;
            vgaGreen <= 0;
        end

        Vsync <= JD[3];
        Hsync <= JD[2];
        
            
    end
        
        
    Display data(JD[0], finalx[11:0], finaly[11:0], seg, an);
    
endmodule



//            if(!JD[3])begin
//                store <= 0; //reset store
//                fetch <= 0;
//                line <= 0;
//                endcount <= 0;
//            end
            
//            if(store >= 3199) store <= 0; //reset every four lines
//            if(fetch >= 3199) fetch <= 0;
            
//            if(sw[0]) begin // 3 line buffer
                
//                if(JD[1])begin
//                   ram[store] <= {JA[7:4],JB[7:4],JC[7:4]};
//                   store <= store + 1;
//                   hcount <= hcount + 1;
//                end
                
//                if(hcount == 800) begin
//                    line <= line + 1; //maxvalue of hcount is 800 (gets to 800)
//                    hcount <= 0;
//                end
                                               
//                if(line == 483) line <= 0;
                                                    
//                if(line >= 480 && !JD[1] && endcount < 927) endcount <= endcount + 1;
//                else endcount <= 0;
                                                    
//                if(JD[1] && line >= 3)begin
//                    vgaBlue <= ram[fetch][11:8];
//                    vgaRed <= ram[fetch][7:4];
//                    vgaGreen <= ram[fetch][3:0];
//                    fetch <= fetch + 1;
//                end
//                else if(line >= 480 && line <= 482 && endcount > 126 && endcount < 927)begin
//                    vgaBlue <= ram[fetch][11:8];
//                    vgaRed <= ram[fetch][7:4];
//                    vgaGreen <= ram[fetch][3:0];
//                    fetch <= fetch + 1;
//                    hcount <= hcount + 1;
//                end
//                else begin
//                    vgaBlue <= 0;
//                    vgaRed <= 0;
//                    vgaGreen <= 0;
//                end
                
//                if(endcount > maxhcount) maxhcount <= endcount;
//                if(line > maxline) maxline <= line;
//            end // 3 line buffer

//            if(i < 2783) i <= i + 1;
//            else i <= 0;
            
//            if(i < 2783) j <= i + 1;
//            else j <= 0;

//            vdelay[i] <= JD[3];

////            if(sw[0]||sw[1])Vsync <= vdelay[j];
////            else 

//              if(i > maxline)maxline <= i;
//              if(j > maxhcount)maxhcount <= j;
