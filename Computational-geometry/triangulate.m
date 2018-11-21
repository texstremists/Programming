function triangles = triangulate(polygon, doPlot)
% TRIANGULATE  Partition a polygon into triangles.
%   Constrained Delaunay triangulation of a convex or concave polygon to several
%   non-overlapping triangles.
%   Inputs:
%       polygon: Nx2 matrix; N vertices of the polygon
%       doPlot: 1x1 logical; whether to plot the triangulation or not
%               (default: false)
%   Output: cell array in which each member is a triangle given by their 
%      vertices in a 3x2 matrix.
%   
%   Example:
%       triangles = triangulate([0 0; 1 0; 0.5 0.5; 1 1; 0 1], true);
%   
%   See also:  delaunayTriangulation

%   Zoltan Csati
%   20/11/2018

assert(size(polygon,2) == 2, 'Polygon must have x and y coordinates.');
if nargin < 2
    doPlot = false;
end

nVertex = size(polygon,1);
if nVertex == 3 % already a triangle
    triangles = {polygon};
else
    % Constrain all sides of the polygon
    constraint = [(1:(nVertex-1))' (2:nVertex)'; nVertex 1];
    % Create the constrained Delaunay triangulation
    T = delaunayTriangulation(polygon, constraint);
    % Exclude triangles outside the domain
    inside = T.isInterior;
    tri = T.ConnectivityList(inside,:);
    % Return the coordinates of the proper triangles
    nTriangle = size(tri,1);
    triangles = cell(1,nTriangle);
    for iTriangle = 1:size(tri,1)
        triangles{iTriangle} = T.Points(tri(iTriangle,:),:);
    end
end

if doPlot
    for iTriangle = triangles
        patch(iTriangle{:}(:,1), iTriangle{:}(:,2), [0 1 0], 'FaceAlpha', 0.2);
    end
end
