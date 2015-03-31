function simplePlanePlot( points, color, varargin)
    
    if (size(points, 1) >= 3)
        % Extract 3 points
        pointA = points(1:1, :);
        pointB = points(2:2, :);
        pointC = points(3:3, :);

        % Calculate plane normal
        normal = cross(pointA-pointB, pointA-pointC); 

        % Transform points to x,y,z
        x = [pointA(1) pointB(1) pointC(1)];  
        y = [pointA(2) pointB(2) pointC(2)];
        z = [pointA(3) pointB(3) pointC(3)];
    else
        % Given the normal
        normal = points(1:1, :);
        pointA = points(1:1, :);
    end
    
    % Find all coefficients of plane equation    
    A = normal(1); B = normal(2); C = normal(3);
    D = -dot(normal, pointA);

    % Decide on a suitable showing range
%     xLim = [min(x) max(x)];
%     zLim = [min(z) max(z)];
%     yLim = [min(y) max(y)];
    xLim = [-50 50];
    yLim = [-50 50];
    zLim = [-50 50];

    if(B == 0 && C == 0)
        [Y, Z] = meshgrid(yLim, zLim);
        X = (B * Y + C * Z + D)/ (-A);
    elseif (A == 0 && C == 0)
        [X, Z] = meshgrid(xLim, zLim);
        Y = (A * X + C * Z + D)/ (-B);
    else 
        [X, Y] = meshgrid(xLim, yLim);
        Z = (A * X + B * Y + D)/ (-C);
    end
           
    reOrder = [1 2  4 3];
    hold on;
    patch(X(reOrder), Y(reOrder), Z(reOrder), color);
    grid on;
    alpha(0.3);
    
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    
    theta = myTan(B, A);
    phi   = myTan(sqrt(A.^2 + B.^2), C);
    rho   = abs(D/(sqrt(A.^2 + B.^2 + C.^2)));
    
    disp([num2str(A), 'x ', num2str(B),  'y ', num2str(C), 'z = ', num2str(D)]); 
    disp(['(', num2str(theta), ', ', num2str(phi), ', ', num2str(rho), ')']);
    
end