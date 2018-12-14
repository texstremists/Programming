function [b, a] = swap(a, b)
%SWAP  Swap two inputs.
%   [A, B] = SWAP(A, B) swaps the two input arguments: A will be the previous B
%   and B will be the previous A.
%   Provide the same variables for output and input to do the swapping in-place.
%   Similar to the "deal" function but has no error checking, works only for two
%   inputs and outputs, and its name reflects what it does.
%   Use "deal" if you want to assign the inputs to different outputs. Although
%   this function can do that, its name will not reflect what it does any more.
%   
%   Example:
%       % Swap inputs
%       a = 1; b = 3;
%       [a, b] = swap(a, b); % returns a=3 and b=1
%       
%   See also:  DEAL

%   Zoltan Csati
%   12/11/2018