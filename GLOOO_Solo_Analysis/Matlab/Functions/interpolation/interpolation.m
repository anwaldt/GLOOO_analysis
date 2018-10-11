%% Interpolation with different algorithms
%
% Interpolate a given set of values:
% the function uses the input values as y-values and takes a vector
% of the same length with values between 0 and 1 as x-values for
% interpolation
%
% the different interpolation / approximation methods are:
% - exponential smoothing
% - hyperbolic tangent 
% - bezier curve
% - spline interpolation
%
% Input: - in : vector with values for approximation
%        - num_values : number of values which are picked out of
%           'in' to approximate (only for spline and bezier used)            
%        - plot_it: (true / false) Plot all curves
% Ouput: - interp : structure which holds all the output data
%
% author : Moritz Götz

function [ interp ] = interpolation (in, num_values, plot_it)

n = length(in);
x_norm = linspace(0,1,n)';

%% Exponential 

% Calculate Exponential smoothing curve
dt = 1 / (n - 1);
tau = 0 : .01 : .5;
mean_rel_err = zeros(1,length(tau));
mean_abs_err = zeros(1,length(tau));


% Try different tau and pick the best result
for idx = 1 : length(tau) 
    y = exp_smooth( in(1), in(end), dt, tau(idx), n );

    % Measure interpolation errors
    interp_error = interpolation_error_measurement(in, y);
    mean_rel_err(idx) = interp_error.mean_rel_err;
    mean_abs_err(idx) = interp_error.mean_abs_err;
end

% Pick smallest error (Abs err) :
[~, idx_min] = min(mean_abs_err);

y = exp_smooth( in(1), in(end), dt, tau(idx_min), n );

interp_error = interpolation_error_measurement(in, y);

% Save Results in Output Structure:
exp_out.err         = interp_error;

exp_out.tau         = tau(idx_min);

exp_out.data_x      = x_norm; % Points used for interpolation
exp_out.data_y      = in;     % Points used for interpolation
exp_out.out_val     = y;

%% Hyperbolic Tangent
% Calculate curve
slope = 0 : .01 : .5;
mean_rel_err = zeros(1,length(slope));
mean_abs_err = zeros(1,length(slope));

% Try different slopes and pick the best result
for idx = 1 : length(slope) 
    y = hyp_tan_smooth( in(1), in(end), slope(idx), n );

    % Measure interpolation errors
    interp_error = interpolation_error_measurement(in, y);
    mean_rel_err(idx) = interp_error.mean_rel_err;
    mean_abs_err(idx) = interp_error.mean_abs_err;
end

% Pick smallest error (Abs err):
[~, idx_min] = min(mean_abs_err);

y = hyp_tan_smooth( in(1), in(end), slope(idx_min), n );

interp_error = interpolation_error_measurement(in, y);

% Save Result in Output Structure:
hyp_tan_out.err      = interp_error;

hyp_tan_out.slope     = slope(idx_min);

hyp_tan_out.data_x   = x_norm; % Points used for interpolation
hyp_tan_out.data_y   = in;% Points used for interpolation
hyp_tan_out.out_val  = y;

%% Pick Points out of the input data according to parameter num_val
% Pick only a few points out of the f0 trajectory for easier interpolation
f0_short = zeros(num_values,1);
x_short  = zeros(num_values,1);

for i = 2 : num_values - 1    
    % Interpolate linear between two points
    % Get index
    idx = n / (num_values - 1) * (i - 1);
    idx_floor = floor(idx);
    % Get x value
    x_short(i) = (i - 1)/(num_values - 1);
    % If x value differs from x value extracted with index: interpolate
    if abs(x_short(i) - x_norm(idx_floor) ) > 0.001
        idx_next = idx_floor + 1;                
        x_1 = x_norm(idx_floor);
        x_2 = x_norm(idx_next);
        y_1 = in(idx_floor);
        y_2 = in(idx_next);        
        f0_short(i)  = y_1 + ((y_2 - y_1) / (x_2 - x_1))* (x_short(i) - x_1);
    else
        f0_short(i)  = in(idx_floor); 
    end        
    
end

% Fill first and last point
f0_short(1)   = in(1);
f0_short(end) = in(end);
x_short(1)    = x_norm(1);
x_short(end)  = x_norm(end);

%% Spline Interpolation
% Calculate Spline
pp_short = natural_spline(x_short,f0_short);

% Evaluate Spline
y_out = ppval(pp_short,x_norm);

% Measure interpolation errors
interp_error = interpolation_error_measurement(in, y_out);

% Save Results in Output Structure:
spline_out.err         = interp_error;

spline_out.pp          = pp_short;

spline_out.data_x      = x_short; % Points used for interpolation
spline_out.data_y      = f0_short;% Points used for interpolation
spline_out.out_val     = y_out;

%% Bezier Interploation

% Calculate Bezier polynomial
[coeffs, control_points] = bezier_poly(x_short,f0_short);

% Evaluate polynomial
v_short = poly_eval(x_norm,coeffs);

% Measure interpolation errors
interp_error = interpolation_error_measurement(in, v_short);

% Save Results in Output Structure:
bezier_out.err         = interp_error;

bezier_out.coeffs      = coeffs;
bezier_out.ctrl_points = control_points;

bezier_out.data_x      = x_short; % Points used for interpolation
bezier_out.data_y      = f0_short; % Points used for interpolation
bezier_out.out_val     = v_short;

%% Generate Output Structure

interp.data_x      = x_norm;
interp.data_y      = in;

interp.exp     = exp_out;

interp.hyp_tan = hyp_tan_out;

interp.spline  = spline_out;

interp.bezier  = bezier_out;

%% Plot
if plot_it == true
  
    fig1 = figure;
    set(fig1,'units','normalized');
    set(fig1,'Position', [.2 .5 .6 .4]);
    % f0 
    plot(x_norm,in,'k');
    hold on;
    % Hyperbolic Tangent
    plot(x_norm,hyp_tan_out.out_val,'color',[.1 .4 .2],'LineStyle','--');
    % Exponential
    plot(x_norm,exp_out.out_val,'color',[.1 .4 .4]);
    % Bezier
    plot(x_norm,bezier_out.out_val,'color',[.1 .4 1],'LineStyle','--');
    % Spline
    plot(x_norm,spline_out.out_val,'color',[.1 .4 .8]);
    % Linear Connection
    plot([x_norm(1) , x_norm(end)], [in(1) , in(end)],'r');
    % Note 1 & Note 2
    plot(x_norm,zeros(size(x_norm)),'color',[.1 .1 .8]);
    plot(x_norm,ones(size(x_norm)),'color',[.1 .1 .5]);
    % Points used for interpolation
    plot(x_short,f0_short,'xr');
    
    % Text
    legend('f0', ...
        'Hyperbolic Tangent', ...        
        'Exponential', ...
        'Bezier', ...
        'Spline',...
        'Linear',...
        'Note 1', ...
        'Note 2', ...
        'Interpolation Points', ...
        'Location','northeastoutside');
    title('Interpolation');
    xlabel('x');
    ylabel('y');
    
    %Limits    
    yMin = min([min(hyp_tan_out.out_val), ...
        min(exp_out.out_val), ...
        min(bezier_out.out_val), ...
        min(spline_out.out_val), ...
        min(in)]);
    yMax = max([max(hyp_tan_out.out_val), ...
        max(exp_out.out_val), ...
        max(bezier_out.out_val), ...
        max(spline_out.out_val), ...
        max(in)]);
    ylim([yMin,yMax]);
    xlim([0,1]);
end

end