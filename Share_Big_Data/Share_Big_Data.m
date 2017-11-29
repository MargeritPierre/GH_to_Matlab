%% EXAMPLE 3 : USE FILES TO SHARE BIG DATA

clc
clear all
close all

% Parameters
    port_Input = 9997 ;
    port_Output = 1110 ;
    packet_Length  = 1e6 ;
    timeout = 100 ;

while 1 % BREAK THE LOOP WITH CTRL + C
    msg = [] ;
    while isempty(msg) % While no msg Received
        try
            msg = judp('RECEIVE',port_Input,packet_Length,timeout) ;
        end
    end
    % Init time clock
        startTime = tic ;
    % Message conversion (message acts as a trigger here)
        msg = char(msg.') ; % to string
    % Read INPUT file
        inputFile = fopen('INPUT.txt') ;
        inputStr = fscanf(inputFile,'%s') ; % read as string
        fclose(inputFile) ;
    % Extract infos from input String
        inputStr = strsplit(inputStr,'-----') ;
        XX = str2num(inputStr{1}) ;
        YY = str2num(inputStr{2}) ;
        F = str2num(inputStr{3}) ;
        E = str2num(inputStr{4}) ;
    % Execute the function
        [U1,U2] = myMembrane(XX,YY,F,E) ;
    % Write OUTPUT file
        strU1 = mat2str(U1*1000) ;
        strU2 = mat2str(U2*1000) ;
        outputFile = fopen('OUTPUT.txt','w') ;
        fwrite(outputFile,[strU1,char(10),strU2]) ; % read as string
        fclose(outputFile) ;
        display('Output file Written.') ;
    % Format answer
        answer = 'True' ;
    % Send answer
        judp('SEND',port_Output,'127.0.0.1',int8(answer))
    % Measure analysis duration
        toc(startTime)
end




