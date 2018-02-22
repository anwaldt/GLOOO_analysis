%% Calculate the Bernstein polynomial
%
% This function is based on the formula for K(x) of the master thesis,
% formaula described in chapter 2.2.2 Berzier cruves 
%
% B_i^n(x) = {n \choose i} x^i (1-x)^{n-i}
%
% Input: i : current index 
%        n : polynomial degree
% Ouput: coef : coefficents c of a polynomial in form:
%       c(1) + c(2)*x + ... + c(n)*x^(n-1)
%
% Warning: Assumption: x value lies between 0 and 1
%
% author: Moritz Götz
%
function [ coef ] = bernstein_poly( i, n )

%Check Input
if n > 12
    error('Polynomial can only work with degree n of maximum 7');
end

% Init Coefficents
coef = zeros(n + 1,1);


n_over_i = nchoosek(n,i);

% Get (1 - x)^a into a polynomial structure
switch (n - i)
    case 0 % 1
        coef(1) = 1;
    case 1 % 1 - x 
        coef(1) = 1;
        coef(2) = -1;
    case 2 % x^2 - 2 x + 1
        coef(1) = 1;
        coef(2) = -2;
        coef(3) = 1;
    case 3 % -x^3 + 3 x^2 - 3 x + 1
        coef(1) = 1;
        coef(2) = -3;
        coef(3) = 3;
        coef(4) = -1;
    case 4 % x^4 - 4 x^3 + 6 x^2 - 4 x + 1
        coef(1) = 1;
        coef(2) = -4;
        coef(3) = 6;
        coef(4) = -4;
        coef(5) = 1;
    case 5 %-x^5 + 5 x^4 - 10 x^3 + 10 x^2 - 5 x + 1 
        coef(1) = 1;
        coef(2) = -5;
        coef(3) = 10;
        coef(4) = -10;
        coef(5) = 5;
        coef(6) = -1;
    case 6 % x^6 - 6 x^5 + 15 x^4 - 20 x^3 + 15 x^2 - 6 x + 1
        coef(1) = 1;
        coef(2) = -6;
        coef(3) = 15;
        coef(4) = -20;
        coef(5) = 15;
        coef(6) = -6;
        coef(7) = 1;
    case 7 % -x^7 + 7 x^6 - 21 x^5 + 35 x^4 - 35 x^3 + 21 x^2 - 7 x + 1
        coef(1) = 1;
        coef(2) = -7;
        coef(3) = 21;
        coef(4) = -35;
        coef(5) = 35;
        coef(6) = -21;
        coef(7) = 7;
        coef(8) = -1;
    case 8 % x^8 - 8*x^7 + 28*x^6 - 56*x^5 + 70*x^4 - 56*x^3 + 28*x^2 - 8*x + 1
        coef(1) = 1;
        coef(2) = -8;
        coef(3) = 28;
        coef(4) = -56;
        coef(5) = 70;
        coef(6) = -56;
        coef(7) = 28;
        coef(8) = -8;
        coef(9) = 1;
     case 9 % - x^9 + 9*x^8 - 36*x^7 + 84*x^6 - 126*x^5 + 126*x^4 - 84*x^3 + 36*x^2 - 9*x + 1
        coef(1) = 1;
        coef(2) = -9;
        coef(3) = 36;
        coef(4) = -84;
        coef(5) = 126;
        coef(6) = -126;
        coef(7) = 84;
        coef(8) = -36;
        coef(9) = 9;   
        coef(10) = -1;   
    case 10 % x^10 - 10*x^9 + 45*x^8 - 120*x^7 + 210*x^6 - 252*x^5  ...
            % + 210*x^4 - 120*x^3 + 45*x^2 - 10*x + 1
        coef(1) = 1;
        coef(2) = -10;
        coef(3) = 45;
        coef(4) = -120;
        coef(5) = 210;
        coef(6) = -252;
        coef(7) = 210;
        coef(8) = -120;
        coef(9) = 45;   
        coef(10) = -10;
        coef(11) = 1;
    case 11 % - x^11 + 11*x^10 - 55*x^9 + 165*x^8 - 330*x^7 + 462*x^6  ...
            % - 462*x^5 + 330*x^4 - 165*x^3 + 55*x^2 - 11*x + 1            
        coef(1) = 1;
        coef(2) = -11;
        coef(3) = 55;
        coef(4) = -165;
        coef(5) = 330;
        coef(6) = -462;
        coef(7) = 462;
        coef(8) = -330;
        coef(9) = 165;   
        coef(10) = -55;
        coef(11) = 11;
        coef(12) = -1;        
    case 12 % x^12 - 12*x^11 + 66*x^10 - 220*x^9 + 495*x^8 - 792*x^7 ...
           % + 924*x^6 - 792*x^5 + 495*x^4 - 220*x^3 + 66*x^2 - 12*x + 1
        coef(1) = 1;
        coef(2) = -12;
        coef(3) = 66;
        coef(4) = -220;
        coef(5) = 495;
        coef(6) = -792;
        coef(7) = 924;
        coef(8) = -792;
        coef(9) = 495;   
        coef(10) = -220;
        coef(11) = 66;
        coef(12) = -12; 
        coef(13) = 1;         
end

% Multiply Coefficients by x^i (resulting in a shift)
if i > 0 && i < n
    coef = [zeros(i,1);coef(1:end - i)];
elseif i == n
    coef(n) = 1;
    coef(1) = 0;
end

% Multiply with n choose i
coef = n_over_i * coef;
    
end

