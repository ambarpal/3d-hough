function  [x, velo_img] = img_to_mat( base_dir, frame, P_velo_to_img )
%IMG_TO_MAT Summary of this function goes here
%   Detailed explanation goes here
    cam = 2;
    
    img = imread(sprintf('%s/image_%02d/data/%010d.png',base_dir,cam,frame));
    [height, width, dim] = size(img);
    K = [width/2, 0, width/2; 0, height/2, height/2; 0, 0, 1];

    % load velodyne points
    fid = fopen(sprintf('%s/velodyne_points/data/%010d.bin',base_dir,frame),'rb');
    velo = fread(fid,[4 inf],'single')';
    velo = velo(1:5:end,:); % remove every 5th point for display speed
    fclose(fid);

    % remove all points behind image plane (approximation
    idx = velo(:,1)<5;
    velo(idx,:) = [];
    velo = velo(:, 1:3);
    %velo = velo(1: 3: end, :);
    %velo = velo(1:10,:);
    
    % project to image plane (exclude luminance)
    %velo_img = project(velo(:,1:4), P_velo_to_img);
    % velo_img = velo(:, 1:3);
    velo_img = [];
%     velo_img = velo_img(velo_img(:,1) < width, :);
%     velo_img = velo_img(velo_img(:,2) < height, :);
%     velo_img = velo_img(velo_img(:,1) > 0, :);
%     velo_img = velo_img(velo_img(:,2) > 0, :);
%    x = velo_img.';
    x_norm = normc(velo);
    x = x_norm.';
end

