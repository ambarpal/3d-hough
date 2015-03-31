low=0.3679;
N=[110 100 20];
simMat=[ones(N(1)) low*ones(N(1),N(2)); low*ones(N(2),N(1)) ones(N(2))];
simMat=[simMat low*ones(size(simMat,1),N(3)); low*ones(N(3),size(simMat,2)) ones(N(3))];
%simMat=simMat+0.1*randn(size(simMat));
%simMat=1-simMat;
idx=randperm(size(simMat,1));
simMat=simMat(idx,idx);
[group]=spectralclusternormalcut_recursive(3,simMat)
group(idx)=group;
plot(group,'o')