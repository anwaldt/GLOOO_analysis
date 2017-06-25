% [y] = pick_inverse(CDF,XVAL, mode)
%
%  Inverse transform sampling with interpolation
%  between different distributions.
%
%  Arguments
%
%  CDF:  cell with cumulative distribution functions
%  XVAL: cell with belonging x values
%
%
% Henrik von Coler
%
% 2017-02-10


function [y] = pick_inverse(CDF,XVAL, mode)


% allocate array for mean calculation
nDistrubutions  = size(CDF,2);
% Y               = zeros(nDistrubutions,1);

% this mean could be omitted and calculated each time it is needed:
cdf  = mean(CDF,2);
xVal = mean(XVAL,2);

% create ONE random value to pick from all
% distributions for interpolation
r = rand;

% Loop over all distributions
% for i=1:nDistrubutions


% get the distribution parameters for thi loop run
%     cdf     = CDF{i};
%     xVal    = XVAL{i};

% get the neighbouring values in the CDF
greaters    = find(cdf>r);
upperVal    = greaters(1);
lowerVal    = max(1,upperVal-1);
upperSP     = cdf(upperVal);
lowerSP     = cdf(lowerVal);

% get the distance of these points
d       = upperSP-lowerSP;

% switch between 'interpolation' and 'closest' mode
switch mode
    
    case 'interpolate'
        
        % the interpolation mode adds additional
        % values and is thus not suited for truly
        % discrete distributions
        
        y = lowerVal*  (r-lowerSP)/d + upperVal * (upperSP-r)/d;
        
        
    case 'closest'
        
        y = lowerVal;
        
end

% get the proper x-values
try
    lB = xVal(max(1,floor(y)));
    uB = xVal(max(1,floor(y))+1);
catch
    disp('Can not get ITS value!')
end
% interpolate
frac    = rem(y,1);
y       = (1-frac)*lB + frac*uB;

% store result in array
%     Y(i)= y;

% end

% avarage between all y-values
% y = mean(Y);

