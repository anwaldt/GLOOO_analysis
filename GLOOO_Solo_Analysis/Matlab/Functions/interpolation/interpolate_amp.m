%% Interpolate the Amplitude out of a transition object

function [ interp ] = interpolate_amp( amp, num_values, plot_it )    
    
    % Normalize Amplitude
    in = (amp - min(amp)) ...
        ./ ( max(amp - min(amp)));            

    [ interp ] = interpolation (in, num_values, plot_it);

end

