function mat_from_velodyne( base_dir, calib_dir)
%MAT_FROM_VELODYNE Summary of this function goes here
%   Detailed explanation goes here

close all; dbstop error; clc;

if nargin<1
  base_dir  = '/home/vinayak/workspace/subspace/data/kitti/2011_09_26/2011_09_26_drive_0001_sync';
end
if nargin<2
  calib_dir = '/home/vinayak/workspace/subspace/data/kitti/2011_09_26/2011_09_26_calib';
end
cam       = 2; % 0-based index
frame     = 0; % 0-based index

% load calibration
calib = loadCalibrationCamToCam(fullfile(calib_dir,'calib_cam_to_cam.txt'));
Tr_velo_to_cam = loadCalibrationRigid(fullfile(calib_dir,'calib_velo_to_cam.txt'));

% compute projection matrix velodyne->image plane
R_cam_to_rect = eye(4); % 4x4 identify matrix
R_cam_to_rect(1:3,1:3) = calib.R_rect{1};
P_velo_to_img = calib.P_rect{cam+1}*R_cam_to_rect*Tr_velo_to_cam;

colors = {[1 0 0], [0 1 0], [0 0 1], [1 1 0]};
%colors = {'r', 'g', 'b'};

% load and display image
for f=0:0
    [x, ~] = img_to_mat(base_dir, f, P_velo_to_img);
    tic;
    [~, grps] = evalc('SSC(x);');
    %grps = gpca_pda_spectralcluster(x,2);
    disp(['elapsed time is: ', num2str(toc), ' secs']);
    
%     color matrix code for SSC    
    grp_1 = grps(:,1);
    color_matrix = zeros(3,size(grp_1, 1));
    for idx=1:size(grp_1)
      color_matrix(:,idx) = colors{grp_1(idx)}.';
    end

%     color matrix code for GPCA   
%     color_matrix = zeros(3,size(grps, 2));
%     for idx=1:size(grps, 2)
%       color_matrix(:,idx) = colors{grps(idx)}.';
%     end

    color_matrix = color_matrix.';
    
    x = x.';
    x_x = x(:,1);
    x_y = x(:,2);
    x_z = x(:,3); 
    scatter3(x_x, x_y, x_z, [], color_matrix);
    save('~/workspace/subspace/09_26_x1.mat', 'x', 'grps')
    
    %for g=1:size(grps)
        %grp_temp = grps(:,g);
        %img = imread(sprintf('%s/image_%02d/data/%010d.png',base_dir,cam,frame));
        %figure('Position',[20 100 size(img,2) size(img,1)]); axes('Position',[0 0 1 1]);
        %imshow(img); hold on;
        %for i=1:size(grp_temp)
          %disp(colors(grp_temp(i)))
          %plot(x(1,i),x(2,i),'o','LineWidth',4,'MarkerSize',3, 'Color', colors{grp_temp(i)});
       %   x_x = x(:,1);
      %    x_y = x(:,2);
      %    x_z = x(:,3);
     %     scatter3(x_x, x_y, x_z)
        %end    
    %end
end

% save('./demo.mat', 'K', 'width', 'height', 'y', 'x', 'points', 'frames');
end