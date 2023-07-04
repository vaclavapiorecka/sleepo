clc; clear all; close all;

addpath('D:\PRIOR\Toolboxes\eeglab_current\eeglab2019_0');

resultsPath = 'D:\PRIOR\Projects\SLEEPO\results\data_cut\NREM3\BROADBAND\sorted\';  
savePath    = 'D:\PRIOR\Projects\SLEEPO\results\data_cut\NREM3\BROADBAND\';

FitPars = struct('nClasses',4,'lambda',1,'b',20,'PeakFit',true, 'BControl',true,'Rectify',false,'Normalize',false);

nameControls    = 'GrandMean Group 1.set';
namePatients    = 'GrandMean Group 2.set';

%% Load grand mean topologies of Control group
tmpEEG_CON = pop_loadset('filename',nameControls,'filepath',resultsPath);

%% Load grand mean topologies of Patients group
tmpEEG_PAT = pop_loadset('filename',namePatients,'filepath',resultsPath);

%% Load public mean template
tmpEEG_NI2002 = pop_loadset('filename','Norms NI2002.set','filepath',resultsPath);

% sort the topomaps so the electrodes corresponds
namesVis    = {tmpEEG_NI2002.chanlocs(:).labels};
namesOrg    = {tmpEEG_CON.chanlocs(:).labels};
reorderData = cellfun(@(c) find(strcmp(c, namesVis)), namesOrg, 'UniformOutput', false);
reorderData = cell2mat(reorderData(1:19));


sortEEG_NI2002 = zeros(4,19);
for i = 1 : 1 : 4
    sensVoltage          = tmpEEG_NI2002.msinfo.MSMaps(4).Maps(i,:)';
    sortEEG_NI2002(i,:)  = sensVoltage(reorderData);
end

%% Compute the global dissimilarity index
load('redbluecmap.mat');

% Controls 
resultsGDI_CO = gdi(tmpEEG_CON, sortEEG_NI2002, 4);

figure
imagesc(resultsGDI_CO);
title('GDI Controls vs. KOENIG')
colormap(redbluecmap)
set(gca,'XTick',1:1:FitPars.nClasses,'XTickLabel',{'MS A'; 'MS B'; 'MS C'; 'MS D'})
set(gca,'YTick',1:1:FitPars.nClasses,'YTickLabel',{'MS A'; 'MS B'; 'MS C'; 'MS D'})
ylabel('Control group')
xlabel('Koenig template')

x = repmat(1:FitPars.nClasses,FitPars.nClasses,1); % generate x-coordinates
y = x';

t = num2cell(round(resultsGDI_CO,2)); % 
t = cellfun(@num2str, t, 'UniformOutput', false); 
text(x(:), y(:), t, 'HorizontalAlignment', 'Center','FontWeight','bold','Color','k')

colorbar
caxis([-1 1])
saveas(gcf,[savePath 'GDI_NI2002_vs_Controls.jpeg'])

% Patients 
resultsGDI_PA = gdi(tmpEEG_PAT, sortEEG_NI2002, 4);

figure
imagesc(resultsGDI_PA);
title('GDI Patients vs. KOENIG')
colormap(redbluecmap)
set(gca,'XTick',1:1:FitPars.nClasses,'XTickLabel',{'MS A'; 'MS B'; 'MS C'; 'MS D'})
set(gca,'YTick',1:1:FitPars.nClasses,'YTickLabel',{'MS A'; 'MS B'; 'MS C'; 'MS D'})
ylabel('Patients group')
xlabel('Koenig template')

x = repmat(1:FitPars.nClasses,FitPars.nClasses,1); % generate x-coordinates
y = x';

t = num2cell(round(resultsGDI_PA,2)); % 
t = cellfun(@num2str, t, 'UniformOutput', false); 
text(x(:), y(:), t, 'HorizontalAlignment', 'Center','FontWeight','bold','Color','k')

colorbar
caxis([-1 1])
saveas(gcf,[savePath 'GDI_NI2002_vs_Patients.jpeg'])