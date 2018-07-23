function rgb = colorname2RGB(colorname)
% Convert color name to its RGB equivalent.
%   Input must be a character array.
%   Output is an 1x3 double array, the normalized RGB.
%   Color shorthand notations are supported.
%
%   Examples:
%       blueRGB = colorname2RGB('blue'); % gives [0 0 1]
%       yellowRGB = colorname2RGB('y');  % gives [1 1 0]
%
%   See also:  https://mathworks.com/help/matlab/ref/patch.html#br92bi7-1-C

%   Zoltan Csati
%   23/07/2018

assert(ischar(colorname), 'colorname2RGB:nonCharType', 'Provide ''char'' type.');
switch colorname
    case 'red', rgb = [1 0 0];     case 'r', rgb = [1 0 0];
    case 'green', rgb = [0 1 0];   case 'g', rgb = [0 1 0];
    case 'blue', rgb = [0 0 1];    case 'b', rgb = [0 0 1];
    case 'yellow', rgb = [1 1 0];  case 'y', rgb = [1 1 0];
    case 'magenta', rgb = [1 0 1]; case 'm', rgb = [1 0 1];
    case 'cyan', rgb = [0 1 1];    case 'c', rgb = [0 1 1];
    case 'white', rgb = [1 1 1];   case 'w', rgb = [1 1 1];
    case 'black', rgb = [0 0 0];   case 'k', rgb = [0 0 0];
    otherwise, error('Unknown color.');
end