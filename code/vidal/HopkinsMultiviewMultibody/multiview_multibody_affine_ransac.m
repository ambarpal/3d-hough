function [group,b,WW] = multiview_multibody_affine_ransac(x,n,threshold,r,scale)
%function [group,b,WW] = multiview_multibody_affine_ransac(x,n,threshold,r)
% Given a set of N image points in F frames ( x 3 by N by F), 
% computes the segmentation of the feature points group N by 1 and
% a base for all the motion subspaces.
% The clustering is obtained using RANSAC (See also RANSAC_SUBSPACES)
%
% Inputs:
%   x           data points
%   n           number of motions
%   threshold   threshold for RANSAC
%   r           the dimension of the space in which the trajectories are projected
%               prior doing RANSAC (default 5)

% If scale is one, the vectors after the projection are scaled with the
% square of the corresponding eigenvalues. If zero or omitted, there isn't 
% any scaling.
[void,N,F] = size(x);
if(nargin<4)
    r=5;
end
if(nargin<5)
    scale=0;
end
% Generate data matrix 2F by N
WW = reshape(permute(x(1:2,:,:),[1 3 2]),2*F,N);

% Project data onto r-Dimensional space
[U,S,V] = svd(WW',0);
if(r>0)
    WW1 = U(:,1:r);
else
    WW1=WW';
end

if(scale>0 & r>0)
    WW1=WW1*S(1:r,1:r).^scale;
end

% Apply RANSAC to segment the motion subspaces
%sigmadata=mean(sqrt(sum(x.^2))); threshold=threshold*sigmadata.^2;
[b,group] = ransac_subspaces(WW1',4,n,threshold);
