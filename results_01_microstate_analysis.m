%% SLEEP MICROSTATES IN RISP
% Whole analysis of microstate for defined frequency band and sleep stage.
%
% Input:
%       - configuration for the microstate analysis (must be defined before
%       runnig of this script)
%       - configuration for the paths, frequency bands and sleep stage
%       identification (must be defined before runnig of this script)
% 
% Output:
%       - MS templates
%       - sorted MS templates
%       - results of microstate analysis (parameters)
% 
% AUTHORS:  Dr. Vaclava Piorecka
% CONTACT:  vaclava.piorecka@nudz.cz
% DATE:     2023/01/23 - creating

%% Basic preprocessing of data
% Preprocessing of Control Group
fileNamesKO  = dir(fullfile(dataControls,'*.mat'));
numOfFilesKO = numel(fileNamesKO); 

for nof = 1 : 1 : numOfFilesKO
    load([dataControls,fileNamesKO(nof).name]);         % Load variable - dataFieldtrip
    
 
    % Fieldtrip preprocessing
    % rereferences data: average reference
    % filters data: demean filter and band-pass filtering
    cfg             = [];                               
    cfg.reref       = 'yes';                            % activation of re-referencing
    cfg.channel     = {'Fp1', 'Fp2', 'F3', 'F4','C3', 'C4', 'P3', 'P4', 'O1', 'O2', 'F7', 'F8', 'T3', 'T4', 'T5', 'T6', 'Fz', 'Cz', 'Pz'};   % choosen electrodes
    cfg.refchannel  = {'Fp1', 'Fp2', 'F3', 'F4','C3', 'C4', 'P3', 'P4', 'O1', 'O2', 'F7', 'F8', 'T3', 'T4', 'T5', 'T6', 'Fz', 'Cz', 'Pz'};   % chanell for reference
    cfg.refmethod   = 'avg';
    cfg.bpfilter    = 'yes';
    cfg.bpfreq      = [LowCutFilter HighCutFilter];
    cfg.bpfilttype  = 'firws';                
    cfg.demean      = 'yes';
    cfg.detrend     = 'yes';

    data            = ft_preprocessing(cfg, dataFieldtrip);
    data.event      = dataFieldtrip.event;
    
    % Clear the hdr info, necessary for sequent analysis (If it exist -
    % problem with Fieldtrip in ft_redefinetrial.)
    if isfield(data, 'hdr')
        data = rmfield(data, 'hdr');
    end
    
    positionTagN3   = find(strcmp({data.event.type}, tagSleep));
    sampleN3        = [data.event(positionTagN3).sample]';

    cfg             = [];
    cfg.trl         = [sampleN3 - 15*data.fsample, sampleN3 + 15*data.fsample, ones(size(sampleN3,1),1) * (-data.fsample), ones(size(sampleN3,1),1)];
    trialsData      = ft_redefinetrial(cfg, data);
    
    clear data;
    
    data = fieldtrip2eeglab(trialsData.hdr,cat(3,trialsData.trial{:}));
    
    save(strcat(resultsPreproControls,fileNamesKO(nof).name),'data')
    clear data dataFieldtrip trialsData;
end

% Preprocessing of Patients Group
fileNamesPA  = dir(fullfile(dataPatients,'*.mat'));
numOfFilesPA = numel(fileNamesPA); 

for nof = 1 : 1 : numOfFilesPA
    load([dataPatients,fileNamesPA(nof).name]);         % Load variable - dataFieldtrip
    
 
    % Fieldtrip preprocessing
    % rereferences data: average reference
    % filters data: demean filter and band-pass filtering
    cfg             = [];                               
    cfg.reref       = 'yes';                            % activation of re-referencing
    cfg.channel     = {'Fp1', 'Fp2', 'F3', 'F4','C3', 'C4', 'P3', 'P4', 'O1', 'O2', 'F7', 'F8', 'T3', 'T4', 'T5', 'T6', 'Fz', 'Cz', 'Pz'};   % choosen electrodes
    cfg.refchannel  = {'Fp1', 'Fp2', 'F3', 'F4','C3', 'C4', 'P3', 'P4', 'O1', 'O2', 'F7', 'F8', 'T3', 'T4', 'T5', 'T6', 'Fz', 'Cz', 'Pz'};   % chanell for reference
    cfg.refmethod   = 'avg';
    cfg.bpfilter    = 'yes';
    cfg.bpfreq      = [LowCutFilter HighCutFilter];
    cfg.bpfilttype  = 'firws';                
    cfg.demean      = 'yes';
    cfg.detrend     = 'yes';
    
    data            = ft_preprocessing(cfg, dataFieldtrip);
    data.event      = dataFieldtrip.event;
    
    % Clear the hdr info, necessary for sequent analysis (If it exist -
    % problem with Fieldtrip in ft_redefinetrial.)
    if isfield(data, 'hdr')
        data = rmfield(data, 'hdr');
    end
    
    positionTagN3   = find(strcmp({data.event.type}, tagSleep));
    sampleN3        = [data.event(positionTagN3).sample]';

    cfg             = [];
    cfg.trl         = [sampleN3 - 15*data.fsample, sampleN3 + 15*data.fsample, ones(size(sampleN3,1),1) * (-data.fsample), ones(size(sampleN3,1),1)];
    trialsData      = ft_redefinetrial(cfg, data);

    clear data;
    
    data = fieldtrip2eeglab(trialsData.hdr,cat(3,trialsData.trial{:}));

    save(strcat(resultsPreproPatients,fileNamesPA(nof).name),'data')
    clear data dataFieldtrip trialsData;
end

%% Microstate analysis 

% Here, we collect the EEG data (one folder per group)
nGroups = 2;
GroupDirArray{1} = resultsPreproControls;
GroupDirArray{2} = resultsPreproPatients;


% Read the data
% eeglabpath = fileparts(which('eeglab.m'));
 DipFitPath = 'D:\PRIOR\Toolboxes\eeglab_current\eeglab2019_0\plugins\dipfit4.3';


eeglab

AllSubjects = [];

for Group = 1:nGroups
    GroupDir = GroupDirArray{Group};
    
    GroupIndex{Group} = []; %#ok<SAGROW>
    
    DirGroup = dir(fullfile(GroupDir,'*.mat'));
    
    FileNamesGroup = {DirGroup.name};

    % Read the data from the group 
    for f = 1:numel(FileNamesGroup)
        load([GroupDir,FileNamesGroup{f}]);
        tmpEEG = data;              % Basic file read
        setname = strrep(FileNamesGroup{f},'.mat',''); % Set a useful name of the dataset
        [ALLEEG, tmpEEG, CURRENTSET] = pop_newset(ALLEEG, tmpEEG, 0,'setname',FileNamesGroup{f},'gui','off'); % And make this a new set
        tmpEEG=pop_chanedit(tmpEEG, 'lookup',fullfile(DipFitPath,'standard_BEM/elec/','standard_1020.elc')); % Add the channel positions
            
        tmpEEG.group = sprintf('Group_%i',Group); % Set the group (will appear in the statistics output)
        [ALLEEG,EEG,CURRENTSET] = eeg_store(ALLEEG, tmpEEG, CURRENTSET); % Store the thing
        GroupIndex{Group} = [GroupIndex{Group} CURRENTSET]; % And keep track of the group
        AllSubjects = [AllSubjects CURRENTSET]; %#ok<AGROW>
    end
    
end

eeglab redraw
   
%% Cluster the stuff

% Loop across all subjects to identify the individual clusters
for i = 1:numel(AllSubjects ) 
    EEG = eeg_retrieve(ALLEEG,AllSubjects(i)); % the EEG we want to work with
    fprintf(1,'Clustering dataset %s (%i/%i)\n',EEG.setname,i,numel(AllSubjects )); % Some info for the impatient user
    EEG = pop_FindMSTemplates(EEG, ClustPars); % This is the actual clustering within subjects
    [ALLEEG, EEG, CURRENTSET] = eeg_store(ALLEEG, EEG, AllSubjects (i)); % Done, we just need to store this
end

eeglab redraw

%% Dataset saving - templates
for f = 1:numel(ALLEEG)
    EEG     = eeg_retrieve(ALLEEG,f);
    fname   = EEG.setname;
    pop_saveset(EEG, 'filename',fname,'filepath',resultsTemp);
end

%% Now we combine the microstate maps across subjects and sort the mean

% First, we load a set of normative maps to orient us later
templatepath = fullfile(fileparts(which('eegplugin_Microstates.m')),'Templates');

EEG = pop_loadset('filename','Normative microstate template maps Neuroimage 2002.set','filepath',templatepath);
[ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off'); % And make this a new set

% And we have a look at it
NormativeTemplateIndex = CURRENTSET;
pop_ShowIndMSMaps(ALLEEG(NormativeTemplateIndex), 4); 
drawnow;


% Now we go into averaging within each group
for Group = 1:nGroups
    % The mean of group X
    EEG = pop_CombMSTemplates(ALLEEG, GroupIndex{Group}, 0, 0, sprintf('GrandMean Group %i',Group));
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, numel(ALLEEG)+1,'gui','off'); % Make a new set
    [ALLEEG,EEG, CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET); % and store it
    GrandMeanIndex(Group) = CURRENTSET; % And keep track of it
end

% Now we want the grand-grand mean, based on the group means, if there is
% more than one group
if nGroups > 1
    EEG = pop_CombMSTemplates(ALLEEG, GrandMeanIndex, 1, 0, 'GrandGrandMean');
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, numel(ALLEEG)+1,'gui','off'); % Make a new set
    GrandGrandMeanIndex = CURRENTSET; % and keep track of it
else
    GrandGrandMeanIndex = GrandMeanIndex(1);
end

% We automatically sort the grandgrandmean based on a template from the literature
[ALLEEG,EEG] = pop_SortMSTemplates(ALLEEG, GrandGrandMeanIndex, 1, NormativeTemplateIndex);
[ALLEEG, EEG, CURRENTSET] = eeg_store(ALLEEG, EEG, GrandGrandMeanIndex);

% This should now be as good as possible, but we should look at it
pop_ShowIndMSMaps(EEG, 4, GrandGrandMeanIndex, ALLEEG); % Here, we go interactive to allow the user to put the classes in the canonical order

eeglab redraw


%% And we sort things out over means and subjects
% Now, that we have mean maps, we use them to sort the individual templates
% First, the sequence of the two group means has be adjusted based on the
% grand grand mean
if nGroups > 1
    ALLEEG = pop_SortMSTemplates(ALLEEG, GrandMeanIndex, 1, GrandGrandMeanIndex);
    [ALLEEG,EEG, CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET); % and store it
end

% Then, we sort the individuals based on their group means
for Group = 1:nGroups
    ALLEEG = pop_SortMSTemplates(ALLEEG, GroupIndex{Group}, 0, GrandMeanIndex(Group)); % Group 1
    [ALLEEG,EEG, CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET); % and store it
end

eeglab redraw

%% We eventually save things

for f = 1:numel(ALLEEG)
    EEG = eeg_retrieve(ALLEEG,f);
    fname = EEG.setname;
    pop_saveset( EEG, 'filename',fname,'filepath',resultsSort);
end

%% Visualize some stuff to see if the fitting parameters appear reasonable

% Just a look at the first EEG
EEG = eeg_retrieve(ALLEEG,1); 
pop_ShowIndMSDyn([],EEG,0,FitPars);
pop_ShowIndMSMaps(EEG,FitPars.nClasses);

%% Here comes the stats part

% Using the individual templates
pop_QuantMSTemplates(ALLEEG, AllSubjects, 0, FitPars, []                   , fullfile(resultsPath,'ResultsFromIndividualTemplates'));

% And using the grand grand mean template
pop_QuantMSTemplates(ALLEEG, AllSubjects, 1, FitPars, GrandGrandMeanIndex, fullfile(resultsPath,'ResultsFromGrandGrandMeanTemplate'));

% And finally, based on the normative maps from 2002
pop_QuantMSTemplates(ALLEEG, AllSubjects, 1, FitPars, NormativeTemplateIndex, fullfile(resultsPath,'ResultsFromNormativeTemplate2002'));