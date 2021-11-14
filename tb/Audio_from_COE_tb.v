`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  RUAS
// Engineer: Dileep Nethrapalli
// 
// Create Date: 02/12/2021 02:15:55 PM
// Design Name: 
// Module Name: Audio_COE_tb
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


module Audio_from_COE_tb( );

   reg Clock_100MHz, Clear_n;   
   wire AUD_PWM, AUD_SD, clock_706KHz;
   wire [3 :0] Sample;
   wire [18:0] Address;
   wire [15:0] Data;
   
 
   Audio_from_COE audio_DUT(
        .AUD_PWM(AUD_PWM), .AUD_SD(AUD_SD), 
        .Clock_100MHz(Clock_100MHz), 
        .Clear_n(Clear_n));
                        
    
   assign clock_706KHz = audio_DUT.clock_706KHz;  
   assign Sample = audio_DUT.Sample;
   assign Address = audio_DUT.Address;
   assign Data = audio_DUT.Data;                     
   
   initial   Clock_100MHz = 0;
   always #5 Clock_100MHz = ~Clock_100MHz;   
   
  initial
     begin
            Clear_n = 0;
       #100 Clear_n = 1;
     end        
       
    always@(Address)
      if(Address == 264599)
         $finish;     
   
endmodule
