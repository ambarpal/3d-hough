function planePlot(points)
% convert points from cartesian to hesse normal form

% hesse = zeros(size(points), 3);
% for row = 1: size(points, 1)
%     r = points(row, :);
%     x = r(1); y = r(2); z = r(3);
%     theta = atan(y/x);
%     phi = atan(sqrt(x.^2 + y.^2)/z);
%     rho = sqrt(x.^2 + y.^2 + z.^2);
%     hesse(row, :) = [theta, phi, rho];
% end

numTheta = 10;
numPhi = 10;
numRho = 100;

thetaLow = 0;
thetaHigh = 360;
phiLow = 0;
phiHigh = 360;
rhoLow = 0;
rhoHigh = 100;

deltaDistFromPlane = 1;
plotTolerance = 0;
% plot only those datapoints which have votes greater than or equal to
% max - plotTolerance
% lower the plot tolerance, better are the points displayed

format long g
votes = zeros( numTheta, numPhi, numRho);
for px = 1:size(points, 1)
    for i = 1:numTheta
        for j = 1:numPhi
            for k = 1:numRho
                % current bin parameters
                theta = (thetaHigh - thetaLow)/numTheta * i;
                phi = (phiHigh - phiLow)/numPhi * j;
                rho = (rhoHigh - rhoLow)/numRho * k;

                x = rho .* sind(phi) .* cosd(theta);
                y = rho .* sind(phi) .* sind(theta);
                z = rho .* cosd(phi);
                
                nVector = [x y z];
                nCap = nVector / rho;
                pVector = points(px, :);
                distFromPlane = (pVector - nVector) * nCap.';
                
                if ( abs(distFromPlane) < deltaDistFromPlane)
                    votes(i, j, k) = votes(i, j, k) + 1;
                end
                
            end
        end
    end
end

hold on
% visualizing the results
dataC = zeros( numTheta * numPhi * numRho, 4);
dataS = zeros( numTheta * numPhi * numRho, 4);
m = max(max(max(votes)));
c = 1;
for i = 1:numTheta
    for j = 1:numPhi
        for k = 1:numRho
            % current bin parameters
            theta = (thetaHigh - thetaLow)/numTheta * i;
            phi = (phiHigh - phiLow)/numPhi * j;
            rho = (rhoHigh - rhoLow)/numRho * k;
            if ( votes(i,j,k) >= m - plotTolerance )
                x = rho .* sind(phi) .* cosd(theta);
                y = rho .* sind(phi) .* sind(theta);
                z = rho .* cosd(phi);
                
                  syms A B C
%                 nVector = [x y z];
%                 P = [A,B,C];
%                 planeFunction = (P - nVector)*(nVector.')
%                 planeFunction = @(A,B)(x*x + y*y + z*z - A*x - B*y)/z*z
%                 planeEqn = solve(planeFunction, C);
                ezmesh(@(A,B)(x*x + y*y + z*z - A*x - B*y)/z, 10);
                
                dataC(c, :) = [x y z votes(i, j, k)/m];
                dataS(c, :) = [theta phi rho votes(i,j,k)/m];
                c = c + 1;
            end
        end
    end
end

s = ones(size(dataC,1), 1) * 20;
scatter3(dataC(:,1), dataC(:,2), dataC(:,3), s, dataC(:,4));
xlabel('X');
ylabel('Y');
zlabel('Z');
colorbar;

% figure;
s = ones(size(dataS,1), 1) * 20;
scatter3(dataS(:,1), dataS(:,2), dataS(:,3), s, dataS(:,4));
xlabel('Theta');
ylabel('Phi');
zlabel('Rho');
colorbar;

end