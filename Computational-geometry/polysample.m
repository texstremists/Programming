function x = polysample(boundary, n, holes, safetyFactor)
% POLYSAMPLE  Uniformly distributed points in a polygon.
%   X = POLYSAMPLE(BOUNDARY, N) returns the coordinates in an Lx2 matrix X of L
%   uniformly distributed points in a polygon given by its vertices in an 
%   Mx2 matrix BOUNDARY. L <= N.
%   X = POLYSAMPLE(BOUNDARY, N, HOLES) additionally allows sampling points to be
%   excluded from internal polygons given by the cell array HOLES.
%   X = POLYSAMPLE(BOUNDARY, N, HOLES, SAFETYFACTOR) additionally allows to set 
%   a parameter which helps creating N number of points. It is not guaranteed 
%   that actually N points are generated. If not given, SAFETYFACTOR = 2.
%   Set HOLES = [] if the polygon contains no hole.
%   
%   Concave, self-intersecting and multiply-connected polygons are supported.
%   Disjoint polygons are not supported, however they can be sampled one-by-one.
%   
%   Dependency:  Mapping Toolbox
%   
%   Examples:
%       % 1) Sampling on the unit square
%       unitSquare = [1 0; 0 0; 0 1; 1 1];
%       x = polysample(unitSquare, 100);
%       patch(unitSquare(:,1), unitSquare(:,2), [1 1 1]);
%       line(x(:,1), x(:,2), 'LineStyle','none', 'Marker','o'); axis('equal');
%       
%       % 2) Sampling on an L-shaped domain
%       LshapedDomain = 10*[0 0; 1 0; 1 0.5; 0.5 0.5; 0.5 1; 0 1];
%       x = polysample(LshapedDomain, 1000, [], 1.5);
%       patch(LshapedDomain(:,1), LshapedDomain(:,2), [1 1 1]);
%       line(x(:,1), x(:,2), 'LineStyle','none', 'Marker','o'); axis('equal');
%       
%       % 3) Sampling on an annulus
%       angle = linspace(0, 2*pi, 100)';
%       outerRadius = 5; innerRadius = 3;
%       outerCircle = [outerRadius*cos(angle), outerRadius*sin(angle)];
%       innerCircle = [innerRadius*cos(angle), innerRadius*sin(angle)];
%       x = polysample(outerCircle, 200, {innerCircle});
%       patch(outerCircle(:,1), outerCircle(:,2), [1 1 1]);
%       patch(innerCircle(:,1), innerCircle(:,2), [1 1 1]);
%       line(x(:,1), x(:,2), 'LineStyle','none', 'Marker','o'); axis('equal');
%       
%   See also:
%       INPOLYGON, POLY2CW, POLY2CCW

%   Zoltan Csati
%   17/06/2018


assert(size(boundary,2) == 2, 'An Nx2 matrix is expected.');
assert(isnumeric(n) && n > 0 && ceil(n) == floor(n));
if nargin < 3
    holes = [];
    safetyFactor = 2;
elseif nargin < 4
    safetyFactor = 2;
end
if safetyFactor < 1 % cannot generate n points
   error('polysample:safetyFails', 'Third parameter must be at least 1.');
end

% Find the axis-aligned (non-minimal) bounding box of the polygon
maxCoord = max(boundary);
minCoord = min(boundary);
boundingBox = [minCoord(1), maxCoord(1), minCoord(2), maxCoord(2)];
boundingBoxArea = prod(maxCoord - minCoord);

% Area of the polygon excluding the holes
outerArea = polyarea(boundary(:,1), boundary(:,2));
holeArea = 0;
for iHole = holes
    holeArea = holeArea + polyarea(iHole{:}(:,1), iHole{:}(:,2));
end
polygonArea = outerArea - holeArea;
% Area proportionality to determine required number of sampling points
if abs(polygonArea) < 1e-10 % self-intersecting polygon with 0 signed area
    polygonArea = boundingBoxArea/2;
end
nGuessed = ceil(safetyFactor*(boundingBoxArea/polygonArea*n));

% Generate uniformly distributed seeds in the bounding box
x = [(boundingBox(2)-boundingBox(1))*rand(nGuessed,1) + boundingBox(1), ...
     (boundingBox(4)-boundingBox(3))*rand(nGuessed,1) + boundingBox(3)];

% Counter-clockwise orientation for the boundary, 
% clockwise for the holes (to subtract them, see INPOLYGON)
[boundaryX, boundaryY] = poly2ccw(boundary(:,1), boundary(:,2));
boundary = [boundaryX, boundaryY];
for iHole = 1:numel(holes)
    [holeX, holeY] = poly2cw(holes{iHole}(:,1), holes{iHole}(:,2));
    holes{iHole} = [holeX, holeY];
end

% Remove the points lying out of the polygon
totalPolygon = boundary;
for iHole = holes
    totalPolygon = [[NaN, NaN]; iHole{:}]; % NaN separates the polygons
end                                        % (see INPOLYGON)
totalPolygon = [boundary; totalPolygon];
in = inpolygon(x(:,1), x(:,2), totalPolygon(:,1), totalPolygon(:,2));
x(~in,:) = [];

% Remove the excessive number of points
excessive = size(x, 1) - n;
x(1:excessive,:) = [];

if size(x, 1) < n
    warning('Only %d sampling points generated.', size(x, 1));
end