%% EXAMPLE 1 : MESSAGE MIRROR

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
    % Display infos
        display(['msg : ',msg])
    % Send answer
        judp('SEND',port_Output,'127.0.0.1',int8(msg))
end


