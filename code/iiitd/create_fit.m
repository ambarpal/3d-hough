function [fitresult, gof] = create_fit(xx, yy, zz, grp)

[xData, yData, zData] = prepareSurfaceData( xx, yy, zz );

ft = fittype( 'poly11' );
opts = fitoptions( ft );
opts.Lower = [-Inf -Inf -Inf];
opts.Upper = [Inf Inf Inf];

hold on;
% figure( 'Name', 'fit1' );
[fitresult, gof] = fit( [xData, yData], zData, ft, opts );
h = plot( fitresult, [xData, yData], zData);
if grp == 1
    colormap(hot);
    h = plot( fitresult, [xData, yData], zData, 'Color', 'r');
elseif grp == 2
    colormap(cool);
    h = plot( fitresult, [xData, yData], zData, 'Color', 'g');
else
    colormap(gray);
    h = plot( fitresult, [xData, yData], zData, 'Color', 'b');
end

legend( h, 'fit1', 'zz vs. xx, yy', 'Location', 'NorthEast' );

xlabel( 'xx' );
ylabel( 'yy' );
zlabel( 'zz' );
grid on