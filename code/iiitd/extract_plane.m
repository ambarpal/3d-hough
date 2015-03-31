load('09_26_x1.mat')
%axis([-0.04 0.04 -0.04 0.04 -0.04 0.04 -1 1]);
xlim([min(xx(:)) max(xx(:))]);
ylim([min(yy(:)) max(yy(:))]);
zlim([min(zz(:)) max(zz(:))]);

for n = 1:3
    grp = [];
    for i = 1:size(x)
        if (grps(i) == n) grp = [grp x(i,:).'];
        end
    end
    grp = grp.';
    xx = grp(:,1);
    yy = grp(:,2);
    zz = grp(:,3);
    create_fit(xx, yy, zz, n);
end