%% Function for Interpolation of f0 curve out of a transition object
%
% This functions uses the interpolate function but before a normalization
% of the curve is done (further info about the interpolation see the 
% interpolation function)
%
% Input: - f0 : f0 trajectory for interpolation
%        - INF 
%        - param           
%        - plot_it: (true / false) Plot all curves
% Ouput: - interp : structure which holds all the output data
%
% author : Moritz Götz

function [ interp ] = interpolate_f0( f0, INF, param, plot_it )

% Use the first and the last value of f0 for normalization
note1 = f0(1);
if isnan(note1) == 1
    note1 = get_frequency_for_note(INF.note1.char{1});
end
note2 = f0(end);
if isnan(note2) == 1
    note2 = get_frequency_for_note(INF.note2.char{1});
end

[in , ~ ] = normalize_f0( f0, note1, note2);

interp = interpolation(in, param.F0.numPoints, plot_it);

% Add info about interpolation
interp.length_smpl = length(f0) * param.lHop;
interp.length_s    = length(f0) * param.lHop / param.fs;

interp.note1 = note1;
interp.note2 = note2;

end

