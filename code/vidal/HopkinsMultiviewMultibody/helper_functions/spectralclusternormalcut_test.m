low=0;
N=[110 100];
simMat=[ones(N(1)) low*ones(N(1),N(2)); low*ones(N(2),N(1)) ones(N(2))];
idx=randperm(size(simMat,1));
simMat=simMat(idx,idx);

%simMat=simMat'*simMat;
[group]=spectralclusternormalcut(simMat)
group(idx)=group;
plot(group,'o')