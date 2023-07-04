% Cleear the space
clear all; close all; clc;

% Define the patsh to toolboxes
addpath('D:\PRIOR\Toolboxes\eeglab_current\eeglab2019_0');

%% Paths
resultsPreproControls   = 'D:\PRIOR\Projects\SLEEPO\results\data_cut\NREM3\BROADBAND\preprocessed\controls\'; 
resultsPreproPatients   = 'D:\PRIOR\Projects\SLEEPO\results\data_cut\NREM3\BROADBAND\preprocessed\patients\';
resultsPath             = 'D:\PRIOR\Projects\SLEEPO\results\data_cut\NREM3\BROADBAND\'; 


% Here, we collect the EEG data (one folder per group)
nGroups = 2;
GroupDirArray{1} = resultsPreproControls;
GroupDirArray{2} = resultsPreproPatients;



% Read the data
eeglabpath = fileparts(which('eeglab.m'));
DipFitPath = fullfile(eeglabpath,'plugins','dipfit4.3');

eeglab

AllSubjects = [];

for Group = 1:nGroups
    GroupDir = GroupDirArray{Group};
    
    GroupIndex{Group} = []; %#ok<SAGROW>
    
    DirGroup = dir(fullfile(GroupDir,'*.mat'));
    
    FileNamesGroup = {DirGroup.name};
    
    if Group==1
        numOfData1 = numel(FileNamesGroup);
    else
        numOfData2 = numel(FileNamesGroup);
    end
     
end

freeColumn  = zeros(numOfData1+numOfData2,1);
freeColCel  = cell(numOfData1+numOfData2,1);
    totalTime   = table(freeColCel, freeColumn, freeColumn);
    totalTime.Properties.VariableNames = {'nameFile'; 'totalTime'; 'GroupN'};
    
for Group = 1:nGroups
    GroupDir = GroupDirArray{Group};
    
    GroupIndex{Group} = []; 
    
    DirGroup = dir(fullfile(GroupDir,'*.mat'));
    
    FileNamesGroup = {DirGroup.name};
    
    
    
    
    % Read the data from the group 
    for f = 1:numel(FileNamesGroup)
        load([GroupDir,FileNamesGroup{f}]);
        tmpEEG = data;              % Basic file read
        setname = strrep(FileNamesGroup{f},'.mat',''); % Set a useful name of the dataset
        [ALLEEG, tmpEEG, CURRENTSET] = pop_newset(ALLEEG, tmpEEG, 0,'setname',FileNamesGroup{f},'gui','off'); % And make this a new set
        tmpEEG=pop_chanedit(tmpEEG, 'lookup',fullfile(DipFitPath,'standard_BEM\elec\','standard_1020.elc')); % Add the channel positions
            
        tmpEEG.group = sprintf('Group_%i',Group); % Set the group (will appear in the statistics output)
        [ALLEEG,EEG,CURRENTSET] = eeg_store(ALLEEG, tmpEEG, CURRENTSET); % Store the thing
        GroupIndex{Group} = [GroupIndex{Group} CURRENTSET]; % And keep track of the group
        AllSubjects = [AllSubjects CURRENTSET]; %#ok<AGROW>
        
        if Group==1
            totalTime.totalTime(f)    = EEG.pnts*EEG.trials/EEG.srate;
            totalTime.GroupN(f)       = Group;
            totalTime.nameFile(f,:)   = {FileNamesGroup{f}};
        else
            totalTime.totalTime(numOfData1+f)    = EEG.pnts*EEG.trials/EEG.srate;
            totalTime.GroupN(numOfData1+f)       = Group;
            totalTime.nameFile(numOfData1+f,:)   = {FileNamesGroup{f}};
        end

    end
    
end
writetable(totalTime,[resultsPath 'TimeDescription.xlsx'])
