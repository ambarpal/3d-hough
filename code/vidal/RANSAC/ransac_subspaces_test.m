%Function to test routine for RANSAC
randn('state',2)
rand('state',1)

k=4;    %dimension of subspaces
K=5;    %dimension of ambient space
N=100;  %number of points in each group
n=2;    %number of groups
thresh=0.01;    %threshold for inliers
addnoise=false; %add random gaussian noise?

%prepare dataset
X=[];
for(in=1:n)
    basis=orth(randn(K,k));
    X=[X basis*rand(k,N)];
end

%add noise if asked for
if(addnoise)
    X=X+0.01*randn(size(X));
end

Ntruth=N*ones(1,n); %ground truth

%call RANSAC for subspace segmentation
group=ransac_subspaces(X,k,n,0.01);

%compute misclassification rate
missrate=missclass(group,Ntruth,n)/sum(Ntruth);

disp(['Missclassification error: ' num2str(missrate*100) '%'])
