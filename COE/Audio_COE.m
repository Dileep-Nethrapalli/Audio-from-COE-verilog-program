% Read .wav Audio file 
 [y, Fs] = audioread('jarasa_jhoom_loo_mein.wav', 'native');
 
% Extract 6 seconds duration Audio (6*44100 = 264600) 
  ROWS_REQUIRED = 264600;   
  Stereo = y(1:ROWS_REQUIRED, :);
  
% Seperate Left and Right audio Channels
  Left_channel_int  = Stereo(:, 1);
  Right_channel_int = Stereo(:, 2);
 
% Extract Left audio Channel
  Left_channel = zeros(ROWS_REQUIRED, 1, 'double');
 
  for i = 1:1:ROWS_REQUIRED
     if(Left_channel_int(i) >= 0) 
        Left_channel(i) = double(Left_channel_int(i));
     else 
        Left_channel(i) = double(0);
     end   
  end    
 
  Left_channel_sound = Left_channel ./ 32767; 
  sound(Left_channel_sound, Fs, 16);
  pause((ROWS_REQUIRED/Fs) + 3);  
 
% Extract Right audio Channel
  Right_channel = zeros(ROWS_REQUIRED, 1, 'double');
  
  for j = 1:1:ROWS_REQUIRED
     if(Right_channel_int(j) >= 0) 
        Right_channel(j) = double(Right_channel_int(j));
     else 
        Right_channel(j) = double(0);
     end   
  end 
  
 Right_channel_sound = Right_channel ./ 32767;
 sound(Right_channel_sound, Fs, 16);
   
% write extracted Left and Right audio channel samples to COE files 
 fid_Left_channel = fopen('./jarasa_jhoom_loo_mein_Left_Hex.coe', 'wt');   
   fprintf(fid_Left_channel,'memory_initialization_radix = 16; \n');    
   fprintf(fid_Left_channel,'memory_initialization_vector = \n'); 
   
 fid_Right_channel = fopen('./jarasa_jhoom_loo_mein_Right_Hex.coe', 'wt');   
   fprintf(fid_Right_channel,'memory_initialization_radix = 16; \n');    
   fprintf(fid_Right_channel,'memory_initialization_vector = \n'); 
   
row_counter = 1;
for k = 1:1:ROWS_REQUIRED
    
    fprintf(fid_Left_channel,  '%c', dec2hex(Left_channel(k),  4));
    fprintf(fid_Right_channel, '%c', dec2hex(Right_channel(k), 4));

    if row_counter == ROWS_REQUIRED
        fprintf(fid_Left_channel,  ';');
        fprintf(fid_Right_channel, ';'); 
        break;
    else 
        fprintf(fid_Left_channel,  ',\n'); 
        fprintf(fid_Right_channel, ',\n');          
    end
       
       row_counter = row_counter+1; 
end 

 fclose(fid_Left_channel);
 fclose(fid_Right_channel);

 % Plot original Audio 
  time = (1:ROWS_REQUIRED)/Fs;
  
  Left_channel_original = plot(time, Left_channel_int);
  title('Left channel original');
  xlabel('seconds');
  ylabel('Amplitude');
  saveas(Left_channel_original, 'Left_channel_original.jpg');

  Right_channel_original = plot(time, Right_channel_int);
  title('Right channel original');
  xlabel('seconds');
  ylabel('Amplitude');
  saveas(Right_channel_original, 'Right_channel_original.jpg');    
  
 % Plot extracted Audio      
  Left_channel_extracted = plot(time, Left_channel);
  title('Left channel extracted');
  xlabel('seconds');
  ylabel('Amplitude');
  saveas(Left_channel_extracted, 'Left_channel_extracted.jpg');
   
  Right_channel_extracted = plot(time, Right_channel);
  title('Right channel extracted');
  xlabel('seconds');
  ylabel('Amplitude');
  saveas(Right_channel_extracted, 'Right_channel_extracted.jpg'); 
  
  
