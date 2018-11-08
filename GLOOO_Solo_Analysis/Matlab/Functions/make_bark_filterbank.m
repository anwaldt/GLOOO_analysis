%% function [] = make_bark_filterbank()
%
%  create a cell structure with coefficients
%  for a bark-filter-bank!
%
% Henrik von Coler
% Created:  2018-11-05
%
%%

function [BF] = make_bark_filterbank(fs,order)


%%
edges = [20, 100, 200, 300, 400, 510, 630, 770, 920, 1080, 1270, 1480, 1720, 2000, 2320, 2700, 3150, 3700, 4400, 5300, 6400, 7700, 9500, 12000, 15500];


nEdges = length(edges);

nFilters = nEdges -1;


BF = cell(nFilters,1);

 
fCent = 50;

fCut  = [20 100]; 

for i=1:nFilters

    [b,a] = cheby1(order, 3,[edges(i)/fs, edges(i+1)/fs]);

    %freqz(b,a)
    
    coeff.b=b;
    coeff.a=a;
    coeff.fs = fs;
    
    BF{i} = coeff;

end