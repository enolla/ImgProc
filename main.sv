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
             
    logic[1:0] start = 0;
    logic[3:0]slow;
    logic[15:0]width = 0;
    logic[15:0]height = 0;
    logic[15:0]fwidth;
    logic[15:0]fheight;
    logic[3:0]bright;
    logic[3:0]grayscale;
    logic[11:0]ram[3200];
    logic[11:0]store = 0;
    logic[11:0]fetch = 0;
    logic[15:0]maxwidth;
    logic[15:0]maxheigh;
    logic[15:0]written = 0;
    logic[15:0]maxwritten;
    logic[11:0]buffer;
    logic cycle = 0;
    logic[15:0]maxrhcount = 0;
    logic[15:0]maxlhcount = 0;
    logic[2:0]delay;
    logic[15:0]lhcount;
    logic[15:0]rhcount;
    logic[3:0]state;
    logic[31:0]de;
    logic[31:0]maxde;
    logic[31:0]maxlvcount;
    logic[31:0]lvcount;
    logic[31:0]rvcount;
    
    always_ff@(negedge JD[0])begin
    
        if(!JD[1] && !JD[3])begin
            state <= 0;
        end
        else if(!JD[1] && state == 0) begin
            lvcount <= lvcount + 1;
        end
        else if(lvcount > 20000) state <= 1;
        else if(state == 1 && JD[1]) state <= 2;
        else if(state == 2 && !JD[1] && JD[2]) lhcount <= lhcount + 1;
        else if(state == 2 && !JD[1] && !JD[2])begin
            de <= de + 1;
            state <= 3;
        end
        else if(state == 3 && !JD[1] && !JD[2])de <= de + 1;
        else if(state == 3 && !JD[1] && JD[2])rhcount <= rhcount + 1;
        else if(state == 3 && JD[1])begin
            maxlhcount <= lhcount;
            maxrhcount <= rhcount;
            state <= 4;
        end
        
        
        //        Vsync <= JD[3]; 
        //        Hsync <= JD[2]; 
        
    end

    Display data(JD[0], maxlhcount[15:0], maxrhcount[15:0], seg, an);

endmodule



/////////////////////////////////////////////////////////////////
// test code
/////////////////////////////////////////////////////////////////
               
//    if(!JD[1]) de <= de +1;
//    else de <= 0;
                   
//    if(de > maxde) maxde <= de;

//    if(!JD[1] && !JD[3]) lvcount <= lvcount + 1;
//    else lvcount <= 0;
    
//    if(JD[3])begin//reset
//        lvcount <= lvcount + 1;
//    end
//    else begin
//        lvcount <= 0;
//    end

//    else if(!JD[1] && JD[3] && state == 1)begin
//        rvcount <= rvcount + 1;
//    end
//    else if(JD[1] && JD[3] && state == 1)rvcount <= 0; 
    
//    if(lvcount > maxlvcount)maxlvcount <= lvcount;
    
    
//        if(!JD[3])begin //reset
//            hstate <= 0;
//            rhcount <= 0;
//            lhcount <= 0;
//        end
//        else if(JD[3] && !JD[1] && hstate == 0)begin
//            hstate <= 1;
//        end
//        else if(JD[3] && JD[1] && hstate == 1)begin
//            hstate <= 2;
//        end
//        else if(!JD[1] && JD[2] && hstate == 2)begin
//            rhcount <= rhcount + 1;
//            hstate <= 3;
//        end
//        else if(!JD[1] && JD[2] && hstate == 3)begin
//            rhcount <= rhcount + 1;
//        end
//        else if(!JD[1] && !JD[2] && hstate == 3)begin
//            hstate <= 4;
//        end
//        else if(!JD[1] && JD[2] && hstate <= 4)begin
//            lhcount <= 1;
//            hstate <= 5;
//        end
//        else if(!JD[1] && JD[2] && hstate <= 5)begin
//            lhcount <= 1;
//        end
//        else if(JD[1] && hstate == 5)begin
//            hstate <= 6;
//        end
        
//        if(lhcount > maxlhcount) maxlhcount <= lhcount;
//        if(rhcount > maxrhcount) maxrhcount <= rhcount;

//        Vsync <= JD[3]; 
//        Hsync <= JD[2]; 


////////////////////////////////////////////////////////
//one line buffer
//////////////////////////////////////////////////////////////
//    always_ff@(negedge JD[0])begin
//        if(JD[2] == 0)begin
//            vtimedown <= vtimedown + 1;
//            vtimeup <= 0;
//        end
//        else begin
//            vtimeup <= vtimeup + 1;
//            vtimedown <= 0;
//        end
                
//        if(JD[1] && delay == 0)begin
//            width <= width + 1;
//        end
//        else begin
//            width <= 0;
//        end
        
////        if((height / 2) != 0)begin
////            store <= 0;
////            height <= 0;
////        end

//        if(store > 1598) store <= 0;
//        if(fetch > 1598) fetch <= 0;
        
//        if(width > 0 && width < 801 && height == 0)begin
//            ram[store] <= {JA[7:4],JB[7:4],JC[7:4]};
//            store <= store + 1;
//            vgaRed <= 0;
//            vgaBlue <= 0;
//            vgaGreen <= 0;
//        end
//        else if(width > 0 && width < 801)begin
//            ram[store] <= {JA[7:4],JB[7:4],JC[7:4]};
//            store <= store + 1;
//            buffer <= ram[fetch];
//            fetch <= fetch + 1;
//            vgaRed <= buffer[11:8];
//            vgaBlue <= buffer[7:4];
//            vgaGreen <= buffer[3:0];
//        end
//        else if(width > 0 && width < 801 && height == 479)begin
//            buffer <= ram[fetch];
//            fetch <= fetch + 1;
//            vgaRed <= buffer[11:8];
//            vgaBlue <= buffer[7:4];
//            vgaGreen <= buffer[3:0];
//        end
//        else begin
//            vgaRed <= 0;
//            vgaBlue <= 0;
//            vgaGreen <= 0;
//        end
        
//        if(width == 800)begin
//            height <= height + 1;
//            //cycle <= !cycle;
//        end
//        if(Vsync == 0) height <= 0;
    
////        if(height > maxheight) maxheight <= height;
////        if(width > maxwidth) maxwidth <= width;
////        if(written > maxwritten) maxwritten <= written;
//        if(vtimedown > maxvdown)maxvdown <= vtimedown;
//        if(vtimeup > maxvup) maxvup <= vtimeup;
    
//        //syncs are low off the screen
//        Vsync <= JD[3]; 
//        Hsync <= JD[2]; 
//    end

//////////////////////////////////////////////////////////////////
//display and simple filter
//////////////////////////////////////////////////////////////////

//    always_ff@(negedge JD[0])begin
//        slow <= slow + 1;
//        if(btnD)bright <= bright - 1;
//        if(btnU)bright <= bright + 1;
//        grayscale <= (JA[7:4] + JB[7:4] + JC[7:4])/3;
//    if(sw[0])begin
//        if(JD[1])begin
//            if(grayscale - bright < 0 )begin
//                vgaRed <= 0;
//                vgaBlue <= 0;
//                vgaGreen <= 0;
//            end
//            else begin
//                vgaRed <= grayscale - bright;
//                vgaBlue <= grayscale - bright;
//                vgaGreen <= grayscale - bright;
//            end
//        end
//        else begin    
//            vgaRed <= 0;
//            vgaBlue <= 0;
//            vgaGreen <= 0;
//        end
//    end
//    else if(sw[1])begin
//        if(JD[1])begin
//            if(((JA[7:4] + JB[7:4] + JC[7:4])/3) > (8 - bright))begin
//                vgaRed <= 15;
//                vgaBlue <= 15;
//                vgaGreen <= 15;
//            end
//            else begin
//                vgaRed <= 0;
//                vgaBlue <= 0;
//                vgaGreen <= 0;
//            end
//        end
//        else begin    
//            vgaRed <= 0;
//            vgaBlue <= 0;
//            vgaGreen <= 0;
//        end
//    end
//    else if(JD[1] && start == 0)begin
//            width <= width +1;
//            vgaRed <= JA[7:4];
//            vgaBlue <= JB[7:4];
//            vgaGreen <= JC[7:4];
//            start <= 1;
//        end
//        else if(JD[1] && start == 1)begin
//            width <= width +1;
//            vgaRed <= JA[7:4];
//            vgaBlue <= JB[7:4];
//            vgaGreen <= JC[7:4];
//        end
//        else if(!JD[1] && start == 1)begin
//            height <= height + 1;
//            vgaRed <= 0;
//            vgaBlue <= 0;
//            vgaGreen <= 0;
//            start <= 0;
//            fwidth <= width;                
//        end
//        else begin
//            vgaRed <= 0;
//            vgaBlue <= 0;
//            vgaGreen <= 0;
//            width <= 0;

//        end
    
//        if(JD[3] == 0 && hstate == 1)
//            fheight <= height;
        
        
//        if(JD[3] == 0 && hstate == 0)
//            height <= 0;
    
//        if(!slow)
//         hstate <= JD[3];
    
//        Vsync <= JD[3];
//        Hsync <= JD[2];
//    end

//    Display data(JD[0], fwidth, fheight, seg, an);

//endmodule


//             output logic RamCLK, logic RamADVn, logic RamCEn, logic RamCRE,
//             output logic RamOEn, logic RamWEn, logic RamLBn, logic RamUBn, logic RamWait,
//             output logic[22:0] MemAdr, 
//             inout logic[15:0] MemDB,
         
//    parameter WRITE = 1'b1;
//    parameter READ = 1'b0;
//    logic RW;
//    logic[15:0] Data_In = 16'hABCD;
//    logic [15:0] Data_Out;
//    logic [2:0] transmission;
//    assign RW = sw[0];
             
//    MMU Memory(btnD, RW, Data_In, Data_Out, RamCLK, RamADVn, RamCEn, RamCRE, RamOEn, RamWEn, RamLBn, RamUBn, RamWait, MemAdr,transmission, MemDB);

    
