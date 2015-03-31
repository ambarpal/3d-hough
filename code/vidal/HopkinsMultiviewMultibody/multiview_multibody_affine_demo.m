function multiview_multibody_affine_demo(path,sequencename)
% Lauch the included algorithms (GPCA with spectral clustering,
% LSA, RANSAC) on one sequence of the Hopkins 155 database
% 
% Inputs:
%   path            relative path from the current directory to
%                   the Hopkins 155 database
%   sequencename    name of the sequence
%
% Example
%   multiview_multibody_affine_demo('../Hopkins155','1R2RCR')

%move in the project directory
fullpath=fullfile(path,sequencename);
if(~exist(fullpath,'dir'))
    error(['Project directory ''' sequencename '''doesn''t exist'])
end

cdold=cd;
cd(fullpath)

%load ground - truth
eval(['load ' sequencename '_truth.mat']);

%generate the data for the tests
generate_test_data

fprintf('GPCA with spectral clustering');
ts=cputime;
group = multiview_multibody_affine_spectral(yord,ngroups);
t=(cputime-ts)/size(group,1);

missrate=missclass(group,N,ngroups)/sum(N);
fprintf('\tMissclassification: %f%% Time elapsed: %fs\n\n',missrate*100,t);


fprintf('RANSAC');
ts=cputime;
[b,group] = multiview_multibody_affine_ransac(yord,ngroups,0.00002);
t=(cputime-ts)/size(group,1);

missrate=missclass(group,N,ngroups)/sum(N);
fprintf('\tMissclassification: %f%% Time elapsed: %fs\n\n',missrate*100,t);

fprintf('LSA');
ts=cputime;
group = multiview_multibody_affine_lsa(yord,ngroups,4*ngroups);
t=(cputime-ts)/size(group,1);

missrate=missclass(group,N,ngroups)/sum(N);

%display results
fprintf('\tMissclassification: %f%% Time elapsed: %fs\n\n',missrate*100,t);
        
cd(cdold)
