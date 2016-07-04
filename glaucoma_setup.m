
root = pwd ;

addpath(genpath(fullfile(root,'configuration_files')));
addpath(genpath(fullfile(root,'experiments'))) ;
addpath(genpath(fullfile(root,'features'))) ;
addpath(genpath(fullfile(root,'learning'))) ;
addpath(genpath(fullfile(root,'scripts'))) ;
addpath(genpath(fullfile(root,'util'))) ;
addpath(genpath(fullfile(root,'vesselSegmentation'))) ;

addpath(genpath(fullfile(root,'Util','eval'))) ;
addpath(genpath(fullfile(root,'Util','figures'))) ;
addpath(genpath(fullfile(root,'Util','img'))) ;
addpath(genpath(fullfile(root,'Util','math'))) ;
addpath(genpath(fullfile(root,'Util','open'))) ;
addpath(genpath(fullfile(root,'Util','save'))) ;
addpath(fullfile(root,'Util','external','vlfeat','toolbox')) ;
addpath(genpath(fullfile(root,'Util','external','markSchmidt'))) ;
vl_setup;

clear
clc