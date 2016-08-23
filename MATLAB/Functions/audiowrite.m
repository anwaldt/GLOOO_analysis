function [  ] = audiowrite( name,signal,fs )
%AUDIOWRITE Summary of this function goes here
%   Detailed explanation goes here

wavwrite(signal,fs,name);

end

