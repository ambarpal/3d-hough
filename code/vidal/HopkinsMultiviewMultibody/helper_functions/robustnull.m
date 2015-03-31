function [x,inliers] = robustnull(A,maxiter)

if nargin < 2
    maxiter = 20;
end

[m,n] = size(A);
A = rnormalize(A);
% Initial estimate of the nullspace
[U,S,V] = svd(A,0);
x = V(:,end);

tune = 1.345;
h = 0;
s = 1e-4;
% Residuals
iter = 0;
err  = 1e20;

while (iter < maxiter & err > 1e-3)
    resid = A*x;
    r = resid/(tune*s*sqrt(1-h));
    inliers = find(abs(r) < 3);
    err = mean(abs(r(inliers)));
    w = 1 ./ max(1, abs(r));
    wA = (w*ones(1,n)).*A;
    [U,S,V] = svd(wA,0);
    x = V(:,end);
    iter = iter + 1;
    %plot(abs(r)), title(num2str(iter)), xlabel(num2str(err)), pause
end