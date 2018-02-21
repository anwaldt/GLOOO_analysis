%% Get Deviation in Cent
%
% source: http://www.sengpielaudio.com/Rechner-centfrequenz.htm
% basic formula : cent = 1200 * log2( f_out / f_in )
%
% Input - f     : frequency in Hz
%       - f_dev : second frequency, deviation is f_dev to f
%
% Ouput - cent : output in cent
%
%
% author: Moritz Goetz

function [ cent ] = get_deviation_cent (f, f_dev)

    cent = 1200 * log2( f_dev / f );

end
