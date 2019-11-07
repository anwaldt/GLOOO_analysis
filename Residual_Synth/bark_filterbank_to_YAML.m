%% function [BF] = bark_filterbank_to_YAML(C,name,fs)
%
% Export Cell array with bark filter coefficients
% to yaml with unique names for use in synthesis!
%
% Henrik von Coler
% 2018-11-05


function [] = bark_filterbank_to_YAML(C, G, name, fs, order)


nFilters = size(C,1);


for i=1:nFilters
    
    b = C{i}.b;
    a = C{i}.a;
    
    mu    = G{i}.mu;
    sigma = G{i}.sigma;
    
    eval(['BF.COEFFICIENTS.band_' num2str(i) '.b' ' = b;']);
    eval(['BF.COEFFICIENTS.band_' num2str(i) '.a' ' = a;']);
    
    eval(['BF.GAUSS.band_' num2str(i) '.mu' ' = mu;']);
    eval(['BF.GAUSS.band_' num2str(i) '.sigma' ' = sigma;']);
    
end

BF.PARAMETERS.fs    = fs;
BF.PARAMETERS.order = order;

YAML.write(name,BF);