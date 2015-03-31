N = 60;    % number of points per plane
a = 50;    % min value of co-ordinate
b = -50;   % max value of co-ordinate
c = 10;     % value of the constant co-ordinate

% seed random stream for reprucible results
s = RandStream('mcg16807', 'Seed', 0);
RandStream.setGlobalStream(s)
points = [];

% y-z plane
% x = (ones(1, N) * c).';
% y = a + (b-a).*rand(N,1);
% z = a + (b-a).*rand(N,1);    
% simplePlanePlot([x y z], 'b');
% points = [points; x y z];

% x-z plane
% x = a + (b-a).*rand(N,1);
% y = (ones(1, N) * c).';
% z = a + (b-a).*rand(N,1);
% simplePlanePlot([x y z], 'b');
% points = [points; [x y z]];

% x-y plane
% x = a + (b-a).*rand(N,1);
% y = a + (b-a).*rand(N,1);
% z = (ones(1, N) * c).';    
% simplePlanePlot([x y z], 'b');
% points = [points; [x y z]];

% x + y + z = 1
% x = a + (b-a).*rand(N,1);
% y = a + (b-a).*rand(N,1);
% z = -(x + y) + 1;
% simplePlanePlot([x y z], 'b');
% points = [points; [x y z]];

% x + y - z = 1
% x = a + (b-a).*rand(N,1);
% y = a + (b-a).*rand(N,1);
% z = (x + y) - 1;
% simplePlanePlot([x y z], 'b');
% points = [points; [x y z]];

% plane for 2*x + 3*y + 4*z = 1
% x = a + (b-a).*rand(N,1);
% y = a + (b-a).*rand(N,1);
% z = -(2*x + 3*y)/4 + 1;
% simplePlanePlot([x y z], 'b');
% points = [points; [x y z]];

x = a + (b-a).*rand(N,1);
y = a + (b-a).*rand(N,1);
z = -(2*x + 3*y)/4 + 1;
simplePlanePlot([x y z], 'b');
points = [points; [x y z]];

% plane for 10*x + 30*y + 13*z = 33
% x = a + (b-a).*rand(N,1);
% y = a + (b-a).*rand(N,1);
% z = -(10*x + 30*y - 33)/13;
% simplePlanePlot([x y z], 'b');
% points = [points; [x y z]];

% add random noise
points = points + randn(size(points));

% plot the origin
plot3(0, 0, 0, 'MarkerSize', 11, 'Marker', 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k');

% plot all the points
scatter3(points(:,1), points(:,2), points(:,3), 'g', 'filled');

% modes - 'topn', 'nodups'
%hough3d(points, 1, 'topn');

hough3d2(points, length(points)/2, 5, 5, 0.1);