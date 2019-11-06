%% function [] = make_bark_filterbank()
%
%  create a cell structure with coefficients
%  for a bark-filter-bank!
%
% Henrik von Coler
% Created:  2018-11-05
%
%%

function [BF] = make_bark_filterbank(fs,order,ripple)


%%
edges = [20, 100, 200, 300, 400, 510, 630, 770, 920, 1080, 1270, 1480, 1720, 2000, 2320, 2700, 3150, 3700, 4400, 5300, 6400, 7700, 9500, 12000, 15500];


nEdges      = length(edges);
nFilters    = nEdges -1;
BF          = cell(nFilters,1);


for i=1:nFilters

   % [b,a] = cheby1(order, ripple,[edges(i)/(fs/2), edges(i+1)/(fs/2)]);
    [b,a] = butter(order,[edges(i)/(fs/2), edges(i+1)/(fs/2)]);

%    impz(b,a)
    
    coeff.b=b;
    coeff.a=a;
    coeff.fs = fs;
    
    BF{i} = coeff;
    
    pause(1)

end