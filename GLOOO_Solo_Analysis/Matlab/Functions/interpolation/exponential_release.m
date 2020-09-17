%%
%
% - for modeling amplitudes during release
% HvC
% 2020-09-15

function [ y ] = exponential_release(L, lambda)

x = linspace(0,L,L);

y = (-1/L +1 ) * exp((-lambda * x)/L);