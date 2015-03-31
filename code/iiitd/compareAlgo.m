function compareAlgo( minVal, maxVal, numPoints, testList )
%COMPAREPLANES Compares SSC and Hough for the given testList
% testList specifies the testNumbers that should be taken to generate
% points
% minVal specifies the minimum value of the coordinate
% maxVal specifies the maximum value of the coordinate
% numPoints specifies the number of points to be generated

s = RandStream('mcg16807', 'Seed', 0);
RandStream.setGlobalStream(s)
x = minVal + (maxVal-minVal).*rand(numPoints,1);
y = minVal + (maxVal-minVal).*rand(numPoints,1); 
points = [];

if ismember(1, testList(:)) == 1
    disp('x + y + z = 1');
    z = 1 - ( x + y );
    simplePlanePlot([x y z], 'b');
    points = [points; [x y z]];
end
if ismember(2, testList(:)) == 1
    disp('x + y + z = 1');
    z = -(10*x + 30*y - 33)/13;
    simplePlanePlot([x y z], 'b');
    points = [points; [x y z]];
end

points = points + randn(size(points));
plot3(0, 0, 0, 'MarkerSize', 11, 'Marker', 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k');
scatter3(points(:,1), points(:,2), points(:,3), 'g', 'filled');
hold off;

grps = SSC(points.');
scatter3(points(:,1), points(:,2), points(:,3),20.*ones(1,size(points,1)),grps(:,1),'filled');
% hough3d2(points, length(points)/2, 5, 5, 0.1);
end

