function group = multiview_multibody_affine_lsa(x,n,r,spectralalg)
%function group = multiview_multibody_affine_lsa(x,n,r,spectralalg)
% Given a set of N image points in F frames ( x 3 by N by F), 
% computes the segmentation of the feature points group N by 1 and
% a base for all the motion subspaces.
% The clustering is obtained using LSA (See also LSA)
%
% Inputs:
%   x           data points
%   n           number of motions
%   r           the dimension of the space in which the trajectories are projected
%               prior doing GPCA (default 5)
%   spectralalg spectral algorithm to use (see LSA)

DEBUG=0;

[void,N,F] = size(x);

%dimension of the projection
if(exist('r','var')==0)
    r=5;
end

if(exist('spectralalg','var')==0)
    spectralalg='kmeans';
end

if(r==0)
    r=min(2*F,N);
end

%number of neighbours
k=6;
%dimension for the subspaces
rp=min(4,r-1);
%constant for the model selection
%kappa=2e-4;    %for head
%kappa2=kappa;%1e-3;
%kappa=2e-7;    %for two_cranes
%kappa2=0.1;
kappa=2e-7;
kappa2=0.1;

%PCA + normalization
% Generate data matrix 2F by N
WW = reshape(permute(x(1:2,:,:),[1 3 2]),2*F,N);
[U,S,V] = svd(WW',0);
% kappa=linspace(0,1,200);
% for (i=1:length(kappa))
%    matrank(i)=modelselection(diag(S),kappa(i));
% end
% plot(kappa,matrank);
% pause

if(r>0)
    WW1 = cnormalize(U(:,1:r)');
else
    WW1 = cnormalize(U(:,1:max(modelselection(diag(S),kappa),2))');
    if(DEBUG==1)
        disp(['Estimated rank for the data matrix is ' num2str(size(WW1,1))])
    end
end

if(r>0)
    group=lsa(WW1,n,k,rp,0,spectralalg);
else
    group=lsa(WW1,n,k,rp,kappa2,spectralalg);
end
if(DEBUG==1)
    figure;plot(group,'o')
end
