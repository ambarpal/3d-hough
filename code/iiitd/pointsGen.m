function [ points ] = pointsGen( testNo )
%POINTSGEN Generates a Nx3 array of points

N = 60;    % number of points per plane
a = 50;    % min value of co-ordinate
b = -50;   % max value of co-ordinate
c = 10;     % value of the constant co-ordinate

% seed random stream for reprucible results
s = RandStream('mcg16807', 'Seed', 0);
RandStream.setGlobalStream(s)
points = [];
if testNo == 1
    x = a + (b-a).*rand(N,1);
    y = a + (b-a).*rand(N,1);
    z = -(2*x + 3*y)/4;
    simplePlanePlot([x y z], 'b');
    points = [points; [x y z]];
elseif testNo == 2
    % plane for 10*x + 30*y + 13*z = 33
    x = a + (b-a).*rand(N,1);
    y = a + (b-a).*rand(N,1);
    z = -(10*x + 30*y - 33)/13;
    simplePlanePlot([x y z], 'b');
    points = [points; [x y z]];
end

end

