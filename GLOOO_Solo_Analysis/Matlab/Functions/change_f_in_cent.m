%% Change frequency value 
%
% source: http://www.sengpielaudio.com/Rechner-centfrequenz.htm
% basic formula : cent = 1200 * log2( f_out / f_in )
%
% Input - f_in : input frequency in Hz
%       - cent : An equally tempered semitone spans 100 cents by definition 
%
% Ouput - f_out : output frequency in Hz
%
%
% author: Moritz Goetz

function [ f_out ] = change_f_in_cent( f_in, cent )

f_out = 2^(cent/1200 + log2(f_in));

end

