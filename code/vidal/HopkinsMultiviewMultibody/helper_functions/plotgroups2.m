function plotgroups2(x,groups)
[K,N]=size(x);
xord=zeros(K,0);
Nord=[];
for(i=1:max(groups))
    xord=[xord x(:,find(groups==i))];
    Nord=[Nord length(find(groups==i))];
end
plotgroups(xord,Nord);