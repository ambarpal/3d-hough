function y = normc(x)
%NORMC Normalize columns of matrices.
%
%  <a href="matlab:doc normc">normc</a>(X) takes a single matrix or cell array of matrices and returns
%  the matrices with columns normalized to a length of one.
%
%  Here the columns of a random matrix are randomized.
%
%    x = <a href="matlab:doc rands">rands</a>(4,8);
%    y = <a href="matlab:doc normc">normc</a>(x)
%
%  See also NORMR.
 
% Mark Beale, 1-31-92
% Copyright 1992-2010 The MathWorks, Inc.
% $Revision: 1.1.10.4 $  $Date: 2011/02/28 01:27:13 $
 
if nargin < 1,error(message('nnet:Args:NotEnough')); end
wasMatrix = ~iscell(x);
x = nntype.data('format',x,'Data');
 
y = cell(size(x));
for i=1:numel(x)
  xi = x{i};
  rows = size(xi,1);
  n = 1 ./ sqrt(sum(xi.*xi,1));
  yi = xi .* n(ones(1,rows),:);
  yi(~isfinite(yi)) = 1;
  y{i} = yi;
end
 
if wasMatrix, y = y{1}; end