%function plotgroups(X,N,dimensions,K)
%
%   Plots the points (contained in the matrix X) with a different color for
%   each group. The dimension is assumed to be equal to size(X,1).
%   N is a vector containing the number of points for each group
%   Marker used:
%               | color   |     |
%       --------+---------+-----+
%       Group 1 | blue    |  x  |
%       Group 2 | red     |  +  |  
%       Group 3 | green   |  *  |
%       Group 4 | cyan    |  s  |
%       Group 5 | magenta |  p  |
%       Group 6 | yellow  |  d  |
%       Group 7 | black   |  h  |
%
%   The vector dimensions contains the coordinates to use. If [] or
%   omitted, try to use all the coordinates.
%   If provided, K must represent the indeces of the neighbours for each
%   point. If [] or omitted, no neighbours.

function plotgroups(X,N,dimensions,K)
styles=char('xb','+r','*g','sc','pm','dy','hk');
if(nargin<2)
    N=size(X,2);
end
ngroups=length(N);
if(nargin<3)
    dimensions=[];
end
if(isempty(dimensions))
    dim=size(X,1);
    dimensions=1:dim;
else
    dim=length(dimensions);
end
Nindex(1)=0;
newplot;
for(i=1:ngroups)
    Nindex(i+1)=Nindex(i)+N(i);
    switch(dim)
        case 1
            plot(Nindex(i)+1:Nindex(i+1),X(dimensions(1),Nindex(i)+1:Nindex(i+1)),styles(i,:))
        case 2
            plot(X(dimensions(1),Nindex(i)+1:Nindex(i+1)),X(dimensions(2),Nindex(i)+1:Nindex(i+1)),styles(i,:))
            if(nargin>=4)
                hold on
                for(k=1:N(i))
                    linex=[];
                    liney=[];
                    for(l=1:size(K,1))
                        linex=[linex X(dimensions(1),Nindex(i)+k) X(dimensions(1),K(l,Nindex(i)+k))];
                        liney=[liney X(dimensions(2),Nindex(i)+k) X(dimensions(2),K(l,Nindex(i)+k))];
                    end
                    plot(linex,liney,[styles(i,2) '-']);
                end
            end

        case 3
            plot3(X(dimensions(1),Nindex(i)+1:Nindex(i+1)),X(dimensions(2),Nindex(i)+1:Nindex(i+1)),X(dimensions(3),Nindex(i)+1:Nindex(i+1)),styles(i,:))
            if(nargin>=4 && ~isempty(K))
                hold on
                for(k=1:N(i))
                    linex=[];
                    liney=[];
                    linez=[];
                    for(l=1:size(K,1))
                        linex=[linex X(dimensions(1),Nindex(i)+k) X(dimensions(1),K(l,Nindex(i)+k))];
                        liney=[liney X(dimensions(2),Nindex(i)+k) X(dimensions(2),K(l,Nindex(i)+k))];
                        linez=[linez X(dimensions(3),Nindex(i)+k) X(dimensions(3),K(l,Nindex(i)+k))];
                    end
                    plot3(linex,liney,linez,[styles(i,2) '-']);
                end
            end
        otherwise
            if(size(X,1)>3)
                plot3(X(dimensions(1),Nindex(i)+1:Nindex(i+1)),X(dimensions(2),Nindex(i)+1:Nindex(i+1)),X(dimensions(3),Nindex(i)+1:Nindex(i+1)),styles(i,:))
            end
    end
    hold on
end
switch(dim)
    case 0
        disp('Zero-dimensional data??')
    case 1
        xlabel('points')
    case 2
        plot(0,0,'ok')
    otherwise
        if(dim>3)
            disp('Sorry, I cannot display more than 3 dimension :(')
        end
        plot3(0,0,0,'ok')
        axis square
        axis equal
end
grid on
hold off