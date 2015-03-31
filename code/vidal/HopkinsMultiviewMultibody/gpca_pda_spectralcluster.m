function [group,c,Dpn,Ln] = gpca_pda_spectralcluster(x,n,k,method,robust)
% [group] = gpca_pda_spectralcluster(x,n,k,scalepow)
%
% POLYNOMIAL DIFFERENTIATION ALGORITHM (PDA) WITH SPECTRAL CLUSTERING
% Given a set of N data points x (K by N) lying on a collection of
% n hyperplanes, it determines the normal vectors b (K by N) to 
% each one of the hyperplanes and the segmentation of the data.
% The algorithm 
% 1) fits a polynomial p to the data
% 2) Segment the data using the normals of the polynomial on each point and
%    applying spectral clustering on an
%    affinity matrix.
%
% Inputs:
%   x       data points to segment
%   n       number of subspaces
%   k       number of eigenvectors to use for spectral clustering (default, k=n)
%   method  select what measure to use between normals to compute the
%           affinity matrix
%       'Cos'           cosine
%       'Cos^2'         squared cosine (default)
%       'Exp_-sin^2'    exp of squared sine
%
if nargin < 5
    robust = 0;
end

if (nargin<4)
    method='Cos^2';
end

if(nargin<3)
    k=n;
end

[K,N] = size(x);
Mn = nchoosek(n+K-1,n);

% Apply linear transformation to data for better numerical stability
%[Ux,Sx,Vx] = svd(x,0); % x is mapped to U'x
Ux=eye(K);
x = Ux'*x;
    
% Obtain coefficients of polynomial, by solving the linear equation from
% the data points fitting the polynomial using SVD
[Ln,powers] = veronese(x,n);
Ln = conj(Ln');

if robust ==1 
    c = robustnull(Ln);
else
    [U,S,V] = svd(Ln,0);
    c = V(:,Mn);
end


%compute only one normal at each point to the subspace containing the point,
%assuming the codim is one.
% Dpn=derivative(c,powers,x);
[Dpn,normDpn] = cnormalize(derivative(c,powers,x));

%compute the similarity matrix
switch method
    case 'Cos'
        affMat=(abs(Dpn'*Dpn));
    case 'Cos^2'
        affMat=(abs(Dpn'*Dpn)).^2;
    case 'Exp_-sin^2'
        affMat=exp((abs(Dpn'*Dpn)).^2-1); % i.e., exp(-sin^2)
end



%segment using spectral clustering
[diagMat,LMat,X,Y,group,errorsum]=spectralcluster(affMat,k,n);
group=group';
