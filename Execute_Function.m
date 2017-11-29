%% EXAMPLE 2 : SOLVE A FUNCTION

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
    % Message conversion
        msg = char(msg.') ; % to string
        input = str2num(msg) ; % to number
    % Execute the function
        output = myFunction(input) ;
    % Format answer
        answer = num2str(output) ; % to string
    % Display infos
        display(char(10))
        display(['msg : ',msg])
        display(['answer : ',answer])
    % Send answer
        judp('SEND',port_Output,'127.0.0.1',int8(answer))
end




