function hough3d(points, numToPlot, mode)

    % define spherical constants
    numTheta = 10;  thetaLow = 0;   thetaHigh = 360;
    numPhi   = 10;  phiLow   = 0;   phiHigh   = 360;
    numRho   = 100; rhoLow   = 0;   rhoHigh   = 50;    
    
    % define spherical step sizes
    thetaStep = (thetaHigh - thetaLow)/numTheta;
    phiStep   = (phiHigh - phiLow)/numPhi;
    rhoStep   = (rhoHigh - rhoLow)/numRho;
    
    deltaDistFromPlane = 0.5;
    
    % initialize matrices
    votes = zeros( numTheta, numPhi, numRho);
    parameterMatrix = zeros( numTheta * numPhi * numRho, 4);
    totalVotes = 0;
    
    for px = 1:size(points, 1)
        for i = 1:numTheta
            for j = 1:numPhi
                for k = 1:numRho                   
                    % current bin parameters
                    theta = thetaStep * i;
                    phi   = phiStep * j;
                    rho   = rhoStep * k;

                    % convert to rectangular co-ordinate system
                    x = rho .* sind(phi) .* cosd(theta);
                    y = rho .* sind(phi) .* sind(theta);
                    z = rho .* cosd(phi);

                    % calculate normal vector
                    nVector = [x y z];
                    nCap = nVector / rho;
                    
                    % get current point
                    pVector = points(px, :);

                    % calculate distance from plane
                    distFromPlane = (pVector - nVector) * nCap.';

                    if ( abs(distFromPlane) <= deltaDistFromPlane )
                        votes(i, j, k) = votes(i, j, k) + 1;
                        totalVotes = totalVotes + 1;
                        parameterMatrix(i*j*k, :) = [votes(i,j,k) x y z];
                    end           
                end
            end
        end
    end

    % sort by number of votes and remove all accumulators where votes == 0
    parameterMatrix = sortrows(parameterMatrix, [-1]);
    parameterMatrix = parameterMatrix(parameterMatrix(:, 1) > 0, :);
    
    switch mode
        % plot top numToPlot planes
        case 'topn'                
            for i = 0:numToPlot
                simplePlanePlot(parameterMatrix(i+1, 2:4), 'r');
            end

        % only plot duplicate planes once 
        case 'nodups'
            normalVectors = zeros(size(parameterMatrix, 1), 3);
            plotted = 0;
            for i = 1:size(parameterMatrix)
                x = parameterMatrix(i, 2);
                y = parameterMatrix(i, 3);
                z = parameterMatrix(i, 4);
                rho = sqrt(x.^2 + y.^2 + z.^2);

                nVector = [x y z];
                nCap = nVector / rho;
                
                % check if this normal has already been plotted
                [~, idx] = ismember(nCap, normalVectors, 'rows');

                % if not, plot it and add it to normalVectors 
                if(idx == 0)
                    normalVectors(i, :) = nCap;
                    simplePlanePlot(parameterMatrix(i, 2:4), 'r');
                    plotted = plotted + 1;
                    if(plotted == numToPlot)
                        break
                    end
                end
            end
    end
    
end