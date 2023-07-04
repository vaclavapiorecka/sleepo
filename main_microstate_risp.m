%% SLEEP MICROSTATES IN RISP - MAIN FILE
% This script run the wole analysis.
%
% 
% AUTHORS:  Dr. Vaclava Piorecka
% CONTACT:  vaclava.piorecka@nudz.cz
% DATE:     2023/01/23 - creating

%% Workspace cleaning
clc; clear; close all;

%% Defaults options for Fieldtrip, EEGLAB
addpath('D:\PRIOR\Toolboxes\fieldtrip-master');
addpath('D:\PRIOR\Toolboxes\eeglab_current\eeglab2019_0');
addpath('D:\PRIOR\Projects\SLEEPO\code\cfg_files');
addpath('D:\Vlasta\GIT\fieldtrip\external\eeglab');
addpath('D:\PRIOR\Toolboxes\eeglab_current\eeglab2019_0\functions\popfunc')
addpath('D:\PRIOR\Toolboxes\eeglab_current\eeglab2019_0\functions\adminfunc')
addpath('D:\PRIOR\Toolboxes\Microstates1.2')
addpath('D:\PRIOR\Toolboxes\eeglab_current\eeglab2019_0\plugins\dipfit4.3')

cfg_microstateDefault;

% -----------------------------------------------------------
cfg_CUT_microstateNREM3;
results_01_microstate_analysis;
stats_02_correlations;
stats_03_global_map_dissimilarity;
results_02_figures_and_correlations; 
results_03_autocorrelations_of_topomaps

stats_01_microstate;

