function group = multiview_multibody_affine_spectral(x,n,r,scale)
%function group = multiview_multibody_affine_spectral(x,n,r)
% Given a set of N image points in F frames ( x 3 by N by F), 
% computes the segmentation of the feature points group N by 1 and
% a base for all the motion subspaces.
% The clustering is obtained using GPCA + spectral clustering
% (See also GPCA_PDA_SPECTRAL)
%
% Inputs:
%   x           data points
%   n           number of motions
%   r           the dimension of the space in which the trajectories are projected
%               prior doing GPCA (default 5)

% If scale is one, the vectors after the projection are scaled with the
% square of the corresponding eigenvalues. If zero or omitted, there isn't 
% any scaling.
[void,N,F] = size(x);
if(nargin<3)
    r=5;
end
if(nargin<4)
    scale=0;
end
% Generate data matrix 2F by N
WW = reshape(permute(x(1:2,:,:),[1 3 2]),2*F,N);

% Project data onto r-Dimensional space
[U,S,V] = svd(WW',0);
WW1 = U(:,1:r);
if(scale>0)
    WW1=WW1*S(1:r,1:r).^scale;
end

WW1 = (cnormalize(WW1'))';

% Apply GPCA to segment the motion subspaces
group = gpca_pda_spectralcluster(WW1',n);
