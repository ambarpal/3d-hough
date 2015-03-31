function grps = GPCA(X)
%Function to test routine for GPCA PDA
% randn('state',2)
% rand('state',1)

%k=4;    %dimension of subspaces
%K=5;    %dimension of ambient space
%N=100;  %number of points in each group
n=3;    %number of groups
%addnoise=true; %add random gaussian noise?

%prepare dataset
% X=[];
% for(in=1:n)
%     basis=orth(randn(K,k));
%     X=[X basis*rand(k,N)];
% end

%add noise if asked for
%if(addnoise)
%    X=X+0.01*randn(size(X));
%end

%Ntruth=N*ones(1,n); %ground truth

%call GPCA
grps=gpca_pda_spectralcluster(X,n);

% %compute misclassification rate
% missrate=missclass(group,Ntruth,n)/sum(Ntruth);
% 
% disp(['Missclassification error: ' num2str(missrate*100) '%'])
