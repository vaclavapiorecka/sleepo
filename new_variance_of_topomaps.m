clc; clear all; close all;

addpath('D:\PRIOR\Toolboxes\eeglab_current\eeglab2019_0');

resultsSort = 'D:\PRIOR\Projects\SLEEPO\results\data_cut\NREM3\BROADBAND\sorted\';  



grand1EEG   = pop_loadset('filename','Norms NI2002.set','filepath',resultsSort);

for i = 1:1:4
    varMap(i) = var(grand1EEG.msinfo.MSMaps(4).Maps(i,:));
    maxMap(i) = max(grand1EEG.msinfo.MSMaps(4).Maps(i,:));
    minMap(i) = min(grand1EEG.msinfo.MSMaps(4).Maps(i,:));
end

diffM=maxMap-minMap;