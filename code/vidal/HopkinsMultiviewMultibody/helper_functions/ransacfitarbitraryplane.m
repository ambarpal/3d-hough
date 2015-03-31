function [B,inliers,Borth]=ransacfitarbitraryplane(x,d,t)

[K,N]=size(x);

if(d>=K)
    error('Dimension requested for the plane equal or greater than the dimension of the data')
end

if(N<d)
    error('Number of points less than the dimension of the hyperplane')
end

s = 3;  % Minimum No of points needed to fit a plane.

fittingfn = @(x) fitplanebase(x,d);
distfn    = @planeptdist;
degenfn   = @(x) isdegenerate(x,d);

[P, inliers] = ransac(x, fittingfn, distfn, degenfn, d, t);

% Perform least squares fit to the inlying points
[U,S,V]=svd(x(:,inliers));
B=U(:,1:d);
Borth=U(:,d+1:end);

%%
%function to extract a plane given exactly d points
%The model is the matrix that gives the component of the point orthogonal
%to the plane
%The configuration of the points in x is assumed to be non-degenerate
function P=fitplanebase(x,d);

y=gramsmithorth(x);
P=eye(size(x,1))-y*y';


%%
%function to detect degenerate cases
function r=isdegenerate(x,d)

r=rank(x)<d;

%%
%function to compute the distance between the points and the plane
function [inliers,M]=planeptdist(P,x,t)
dist2=sum((P*x).^2);
inliers=find(dist2<t);
M=P;
