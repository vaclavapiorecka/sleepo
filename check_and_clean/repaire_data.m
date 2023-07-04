%%
clc; clear; close all;

dataPath = '\\srv-fs.ad.nudz.cz\BV_DATA\PRIOR\Projects\SLEEPO\data\patients\';
fileName = 'SR5-3635-pp1a.250.i16.mat';
% fileName = 'SR5-3325-pp1a.250.i16.mat';
savePath = '\\srv-fs.ad.nudz.cz\BV_DATA\PRIOR\Projects\SLEEPO\results\data_repaired\patients\';

% dataPath = '\\srv-fs.ad.nudz.cz\BV_DATA\PRIOR\Projects\SLEEPO\data\controls\';
% fileName = 'SR2-3284-pp1a.250.i16.mat';
% fileName = 'SR2-4655-pp1a.250.i16.mat';
% savePath = '\\srv-fs.ad.nudz.cz\BV_DATA\PRIOR\Projects\SLEEPO\results\data_repaired\controls\';

% Load the data - variable dataFieldtrip
load([dataPath fileName]);

% Load the electrode file
dataFieldtrip.elec = ft_read_sens('standard_1020.elc', 'senstype', 'eeg');  % for EEG electrodes
    
%% Repairing

% Define the neighbours
cfg         	= [];
cfg.channel     = {'Fp1' 'AFz'}; %'F8'; %{'T6' 'F4'}; %'Fp1';
cfg.method      = 'template';
cfg.template    = 'elec1020_neighb.mat';
neighbours  = ft_prepare_neighbours(cfg, dataFieldtrip);


% Interpolation
cfg = [];
cfg.badchannel     = {'Fp1' 'AFz'}; %{'F8'}; %{'T6' 'F4'}; %{'Fp1'};
cfg.method         = 'spline';
cfg.neighbours     = neighbours;
cfg.senstype       = 'eeg';
dataFieldtrip = ft_channelrepair(cfg,dataFieldtrip);

save(strcat(savePath,fileName),'dataFieldtrip')