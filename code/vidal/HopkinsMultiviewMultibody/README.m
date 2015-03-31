% CONTENT OF THE PACKAGE
% ======================
% This package contains the code for the following multiview-multibody
% motion segmentation algorithms:
%   - GPCA with spectral clustering
%   - RANSAC
%   - Local Subspace Affinity (LSA)
%
% The corresponding implementations for the motion segmentation are
% contained in the functions
%   - multiview_multibody_affine_spectral.m
%   - multiview_multibody_affine_ransac.m
%   - multiview_multibody_affine_lsa.m
%
% Similarly, the general segmentation algorithms for the abstract problem
% of subspace clustering are implemented in
%   - gpca_pda_spectral.m
%   - ransac_subspaces.m
%   - lsa.m
%
% Please the help for each file for more information.
%
% DEMO OF ALGORITHMS
% ==================
% To have an example of how the algorithms work in practice, plese follow
% this steps:
% 1) Add the directory where this file is contained and its subdirectories
%    to the MATLAB path.
% 2) Install the Hopkins 155 database.
% 3) Run the file multiview_multibody_affine_demo.m
%       e.g. multiview_multibody_affine_demo('../Hopkins155','1R2RCR')
%    See the corresponding help for more information.
%
% This code has been tested with MATLAB 7.0.0.19920 (R14)
