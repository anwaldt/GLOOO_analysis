%% Function to compare a vector x and the approximated data x_tilde
%
% Input: x : vector
%        x_tilde : vector which is the result of an interpolation of x
%
%   ---> both vectors must have the same size!
%
% Ouput: error_meas : struct which holds different measurements for errors
%
% author: Moritz Götz

function [error_meas] = interpolation_error_measurement(x, x_tilde)

if (size(x) ~= size(x_tilde))
    error('Input vectors must have the same size!');
end

% Relative Error
rel_err = abs(x - x_tilde)./abs(x);
mean_rel_err = mean(rel_err);

% Standard deviation
std_dev_err = sqrt( (1/length(x)) * sum( (rel_err - mean_rel_err).^2 ) );
rel_std_dev_err = std_dev_err / mean_rel_err;

% Abs Error
abs_err      = abs(x - x_tilde);
mean_abs_err = mean(abs_err);
mean_abs_std = sqrt( (1/length(x)) * sum( (abs_err - mean_abs_err).^2 ) );

% Save Results in Ouput Structure
error_meas.rel_err          = rel_err;
error_meas.mean_rel_err     = mean_rel_err;
error_meas.std_dev_err      = std_dev_err;
error_meas.rel_std_dev_err  = rel_std_dev_err;

error_meas.mean_abs_err     = mean_abs_err;
error_meas.abs_err          = abs_err;
error_meas.mean_abs_std     = mean_abs_std;

end