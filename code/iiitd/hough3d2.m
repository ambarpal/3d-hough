function hough3d2( points, subset_size, theta_step, phi_step, rho_step )
    n_points = size(points, 1);

    points_x = points(:, 1);
    points_y = points(:, 2);
    points_z = points(:, 3);
    
    index = randperm(n_points);
     
    x = points_x(index(1:subset_size));
    y = points_y(index(1:subset_size));
    z = points_z(index(1:subset_size));
        
    x_min = min(x); y_min = min(y); z_min = min(z);
    x_max = max(x); y_max = max(y); z_max = max(z);
    
    dist_min = 0;
    dist_max = sqrt(x_max.^2 + y_max.^2 + z_max.^2);

    n_theta = (360 / theta_step) + 1;
    n_phi   = (360 / phi_step) + 1;
    n_rho   = ceil(2 * (dist_max - dist_min)/rho_step);
    
    theta_bins = linspace(0, 360, n_theta);
    phi_bins   = linspace(0, 360, n_phi);
    rho_bins   = linspace(dist_min, dist_max, n_rho);
    
    accumilator = zeros(n_theta, n_phi, n_rho);
    
    % generate nchoosek combinations for a subset
    combinations   = nchoosek(1:subset_size, 3);
    n_combinations = length(combinations);
    voted_bins = zeros(n_combinations, 3);        
    vote_idx = 1;
    
    for idx = 1:n_combinations
            
        % extract the 3 points
        comb = combinations(idx, :);
        p1 = points(comb(1), :);
        p2 = points(comb(2), :);
        p3 = points(comb(3), :);
        
        % plot the points being considered
%         plot3(p1(1), p1(2), p1(3), 'or', 'MarkerSize', 11, 'MarkerFaceColor', 'r');
%         plot3(p2(1), p2(2), p2(3), 'or', 'MarkerSize', 11, 'MarkerFaceColor', 'r');
%         plot3(p3(1), p3(2), p3(3), 'or', 'MarkerSize', 11, 'MarkerFaceColor', 'r');
%         simplePlanePlot([p1; p2; p3], 'r');
        
        % calculate normal

        
        % plot the normal
%         vector = 10 * normal./norm(normal);
%         plot3([0, vector(1)]', [0, vector(2)]', [0, vector(3)]', 'r', 'LineWidth', 2);

        normal = cross(p1-p2, p1-p3);        
        A = normal(1); B = normal(2); C = normal(3); D = -dot(normal, p1);
        
        if (D > 0)
            A = -A; B = -B; C = -C; D = -D;            
        end
        
        % deduce spherical co-od's of the normal
        theta = myTan(B, A);
        phi   = myTan(sqrt(A.^2 + B.^2), C);
        rho   = abs(D/(sqrt(A.^2 + B.^2 + C.^2)));
        
        % || (theta == 0 && phi == 0 && rho == 0)
        if(isnan(theta) || isnan(phi))
            continue;
        end
        
        [theta_bin, phi_bin, rho_bin] = bin(theta, phi, rho, n_theta, n_phi, n_rho, dist_min, dist_max);
        curr_votes = accumilator(theta_bin, phi_bin, rho_bin);
        if(curr_votes == 0)
            voted_bins(vote_idx, :) = [theta_bin; phi_bin; rho_bin];
            vote_idx = vote_idx + 1;
        end
        
        accumilator(theta_bin, phi_bin, rho_bin) = curr_votes + 1;
    end
    
    bins = zeros(n_combinations, 4);
    for i = 1:vote_idx - 1
        votes = accumilator(voted_bins(i, 1), voted_bins(i, 2), voted_bins(i, 3));
        bins(i, :) = [votes; voted_bins(i, 1); voted_bins(i, 2); voted_bins(i, 3)];
    end
    
    bins = sortrows(bins, [-1]);
    
    for i = 1:min(3, vote_idx-1)
        theta = theta_bins(bins(i, 2));
        phi   = phi_bins(bins(i, 3));
        rho   = rho_bins(bins(i, 4));
        
        x = rho .* sind(phi) .* cosd(theta);
        y = rho .* sind(phi) .* sind(theta);
        z = rho .* cosd(phi);

        simplePlanePlot([x y z], 'r');
    end