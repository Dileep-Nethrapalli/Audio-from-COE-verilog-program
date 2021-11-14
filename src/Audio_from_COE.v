`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  RUAS
// Engineer: Dileep Nethrapalli
// 
// Create Date: 10/16/2020 02:26:08 PM
// Design Name: 
// Module Name: Audio_COE
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


module Audio_from_COE(output reg AUD_PWM, 
                 output AUD_SD, 
                 input Clock_100MHz, Clear_n);
                
                
   // Generate Audio Shutdown(AUD_SD) signal
     // 0 = Audio Shutdown
     // 1 = Audio Enable 
     assign AUD_SD = Clear_n;
     
    
 //Bitrate = bits per sample * samples per second * no of channels
   // Bitrate = 16 * 44100 * 1 = 705600Hz = 706KHz = 1.42us  
   // Create a clock of 706KHz(1.42us)  
   // 1.42us clock = 0.71us ON + 0.71us OFF
   // 100MHz = 10ns = 1;  0.71us = x;  x = 71;
   // 70 = 100_0110b

    reg clock_706KHz;  
    reg [6:0] count_71;
                      
    always@(posedge Clock_100MHz, negedge Clear_n)
       if(!Clear_n)
          begin
            clock_706KHz <= 0;
            count_71 <= 0;
          end         
       else if(count_71 == 70)
         begin
           clock_706KHz <= ~clock_706KHz;
           count_71 <= 0;
         end 
        else
           count_71 <= count_71 + 1;
                    
         
 // Instantiate a Block ROM IP of Width 16 and Depth 264600
    reg  [3 :0] Sample;
    reg  [18:0] Address;    
    reg  [15:0] Data;
    wire [15:0] ROM_data;
    
    Block_ROM_16x264600 BROM_ip (
         .clka(clock_706KHz), // input clka
         .rsta(!Clear_n),     // input rsta
         .addra(Address),     // input [18 : 0] addra
         .douta(ROM_data)     // output [15 : 0]  douta
        ); 
 
 
   // Generate ROM Address                  
      always@(negedge Clock_100MHz, negedge Clear_n) 
        if(!Clear_n)       
           Address <= 0;  
        else if((Address == 264599) && (Sample == 0) && 
                (!clock_706KHz) && (count_71 == 35))
           Address <= 0;              
        else if((Sample == 0) && (!clock_706KHz) && 
                (count_71 == 35))
           Address <= Address + 1;     
                
                
   // Read data from memory        
      always@(posedge Clock_100MHz, negedge Clear_n)  
        if(!Clear_n)       
           Data <= 0; 
        else 
           Data <= ROM_data;          
       
            
   // Generate sample count         
      always@(posedge clock_706KHz, negedge Clear_n)  
        if(!Clear_n)       
           Sample <= 15;
        else if(Sample == 0)    
           Sample <= 15; 
        else
           Sample <= Sample - 1;   
                          
                   
   // Assign ROM data output to the PWM to get hear the sound
      always@(negedge clock_706KHz, negedge Clear_n)  
        if(!Clear_n)       
           AUD_PWM <= 0;  
        else
          case(Sample) 
               15 : AUD_PWM <= Data[15]; 
               14 : AUD_PWM <= Data[14]; 
               13 : AUD_PWM <= Data[13];
               12 : AUD_PWM <= Data[12];
               11 : AUD_PWM <= Data[11];
               10 : AUD_PWM <= Data[10];
                9 : AUD_PWM <= Data[9];
                8 : AUD_PWM <= Data[8]; 
                7 : AUD_PWM <= Data[7];
                6 : AUD_PWM <= Data[6];
                5 : AUD_PWM <= Data[5];
                4 : AUD_PWM <= Data[4]; 
                3 : AUD_PWM <= Data[3];
                2 : AUD_PWM <= Data[2];
                1 : AUD_PWM <= Data[1];
                0 : AUD_PWM <= Data[0];  
          endcase  
    
endmodule
