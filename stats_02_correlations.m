%% SLEEP MICROSTATES IN RISP - analysis of MS consistency
% This script use the correlation.
%
% Input:
%       - Data preprocessed via the microstate analysis (script:
%       results_01_microstate_analysis.m)
% 
% Output:
%       - Maps of correlation coefficients:
%           - comparisson with the mean topography of the group
%           - comparisson with the grand grand mean topography 
% 
% AUTHORS:  Dr. Vaclava Piorecka
% CONTACT:  vaclava.piorecka@nudz.cz
% DATE:     2023/01/23 - creating

%% Define the parameters
load('redbluecmap.mat');

idealNumMS = 4;

%% Load template - grand grand mean
templateEEG = pop_loadset('filename','GrandGrandMean.set','filepath',resultsSort);

grand1EEG   = pop_loadset('filename','GrandMean Group 1.set','filepath',resultsSort);
grand2EEG   = pop_loadset('filename','GrandMean Group 2.set','filepath',resultsSort);

%% Load individual templates
% Clear the data space
AllSubjects = [];
ALLEEG = [];

% Loading data
dirgroup = dir(fullfile(resultsTemp,'*.set'));
FileNamesGroup = {dirgroup.name};

% Loading data into groups
for f = 1:numel(FileNamesGroup)
    tmpEEG = pop_loadset('filename',FileNamesGroup{f},'filepath',resultsTemp);
    [ALLEEG, tmpEEG, CURRENTSET] = pop_newset(ALLEEG, tmpEEG, 0,'gui','off'); 	% new dataset
    
    [ALLEEG,~,CURRENTSET] = eeg_store(ALLEEG, tmpEEG, CURRENTSET);              % data store
    AllSubjects = [AllSubjects CURRENTSET];
end

%% Analysis of between-group variability
TickLabs = {'MS1';'MS2';'MS3';'MS4'};

for f = 1 : numel(ALLEEG)
    correlations = zeros(4);
    for i = 1 : 1 : 4
        for j = 1 : 1 : 4
            correlations(i,j) = corr2(ALLEEG(f).msinfo.MSMaps(4).Maps(i,:),templateEEG.msinfo.MSMaps(4).Maps(j,:));
        end
    end
    
    figure
    imagesc(correlations);
     colormap(redbluecmap)
     colorbar
     caxis([-1 1])
     set(gca, 'XTick', 1:idealNumMS); % center x-axis ticks on bins
     set(gca, 'YTick', 1:idealNumMS);
     set(gca, 'XTickLabel', {TickLabs{1:idealNumMS,1}}); % set x-axis labels
     set(gca, 'YTickLabel', {TickLabs{1:idealNumMS,1}});
     xlabel('Grand grand mean');
     ylabel('Individual templates');
     title(['Correlation with GRANDGRAND MEAN - ',ALLEEG(f).filename(1:8)]);
     
     x = repmat(1:idealNumMS,idealNumMS,1); % generate x-coordinates
     y = x';
     
     t = num2cell(round(correlations,2)); %
     t = cellfun(@num2str, t, 'UniformOutput', false);
     text(x(:), y(:), t, 'HorizontalAlignment', 'Center','FontWeight','bold','Color','w')
     %text(.5,.5,'my text','FontSize',14,'Color','red')
     saveas(gcf,[resultsCorr 'INDIVIDUAL_GRANDGRANDMEAN_CORR_' ALLEEG(f).filename(1:8) '.jpeg']);
end

%% Analysis of inter-group variability, 
allNames    = {ALLEEG(:).group};

name1       = 'Group_1';
tfGroup1    = strcmp(allNames,name1); 

name2       = 'Group_2';
tfGroup2    = strcmp(allNames,name2); 


 for f = 1 : numel(ALLEEG)
    if tfGroup1(1,f) == 1 
        correlations = zeros(4);
        for i = 1 : 1 : 4
            for j = 1 : 1 : 4
                correlations(i,j) = corr2(ALLEEG(f).msinfo.MSMaps(4).Maps(i,:),grand1EEG.msinfo.MSMaps(4).Maps(j,:));
            end
        end
        
        figure
        imagesc(correlations);
        colormap(redbluecmap)
        colorbar
        caxis([-1 1])
        set(gca, 'XTick', 1:idealNumMS); % center x-axis ticks on bins
        set(gca, 'YTick', 1:idealNumMS);
        set(gca, 'XTickLabel', {TickLabs{1:idealNumMS,1}}); % set x-axis labels
        set(gca, 'YTickLabel', {TickLabs{1:idealNumMS,1}});
        xlabel('Grand mean - Control');
        ylabel('Individual templates');
        title(['Correlation with CONTROL GRAND MEAN - ',ALLEEG(f).filename(1:8)]);
        
        x = repmat(1:idealNumMS,idealNumMS,1); % generate x-coordinates
        y = x';
        
        t = num2cell(round(correlations,2)); %
        t = cellfun(@num2str, t, 'UniformOutput', false);
        text(x(:), y(:), t, 'HorizontalAlignment', 'Center','FontWeight','bold','Color','w')
        
        saveas(gcf,[resultsCorr 'GROUP_CONTROL_GRANDMEAN_CORR_' ALLEEG(f).filename(1:8) '.jpeg']);
    elseif tfGroup2(1,f) == 1
        correlations = zeros(4);
        for i = 1 : 1 : 4
            for j = 1 : 1 : 4
                correlations(i,j) = corr2(ALLEEG(f).msinfo.MSMaps(4).Maps(i,:),grand1EEG.msinfo.MSMaps(4).Maps(j,:));
            end
        end
        
        figure
        imagesc(correlations);
        colormap(redbluecmap)
        colorbar
        caxis([-1 1])
        set(gca, 'XTick', 1:idealNumMS); % center x-axis ticks on bins
        set(gca, 'YTick', 1:idealNumMS);
        set(gca, 'XTickLabel', {TickLabs{1:idealNumMS,1}}); % set x-axis labels
        set(gca, 'YTickLabel', {TickLabs{1:idealNumMS,1}});
        xlabel('Grand mean - Control');
        ylabel('Individual templates');
        title(['Correlation with PATIENT GRAND MEAN - ',ALLEEG(f).filename(1:8)]);
        
        x = repmat(1:idealNumMS,idealNumMS,1); % generate x-coordinates
        y = x';
        
        t = num2cell(round(correlations,2)); %
        t = cellfun(@num2str, t, 'UniformOutput', false);
        text(x(:), y(:), t, 'HorizontalAlignment', 'Center','FontWeight','bold','Color','w')
        
        saveas(gcf,[resultsCorr 'GROUP_PATIENT_GRANDMEAN_CORR_' ALLEEG(f).filename(1:8) '.jpeg']);
    end
    
 end
