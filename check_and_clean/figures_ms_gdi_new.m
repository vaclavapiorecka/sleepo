% Cleear the space
clear all; close all; clc;

% Define the paths to toolboxes
addpath('Z:\PRIOR\Toolboxes\eeglab_current\eeglab2019_0');
addpath('Z:\PRIOR\Toolboxes\fieldtrip-master');
addpath(genpath(pwd));

cfg_CUT_microstateNREM3;

savePath                = [resultsPath '\gdi2\'] ; 
resultsPath             = resultsSort; 

nameControls    = 'GrandMean Group 1.set';
namePatients    = 'GrandMean Group 2.set';
nameMean        = 'GrandGrandMean.set';

FitPars = struct('nClasses',4,'lambda',1,'b',20,'PeakFit',true, 'BControl',true,'Rectify',false,'Normalize',false);

%% Show and plot Controls
tmpEEG_CON = pop_loadset('filename',nameControls,'filepath',resultsPath);
pop_ShowIndMSMaps(tmpEEG_CON,FitPars.nClasses);
saveas(gcf,[savePath 'GrandMean_Controls.jpg'])

%% Show and plot Patients
tmpEEG_PAT = pop_loadset('filename',namePatients,'filepath',resultsPath);
pop_ShowIndMSMaps(tmpEEG_PAT,FitPars.nClasses);
saveas(gcf,[savePath 'GrandMean_Patients.png'])

%% Show and plot GRAND GRAND MEAN
tmpEEG_MEA = pop_loadset('filename',nameMean,'filepath',resultsPath);
pop_ShowIndMSMaps(tmpEEG_MEA,FitPars.nClasses);
saveas(gcf,[savePath 'GrandMean_ownDataset.png'])

%% Load public mean template
tmpEEG_NI2002 = pop_loadset('filename','Norms NI2002.set','filepath',resultsPath);
pop_ShowIndMSMaps(tmpEEG_NI2002,FitPars.nClasses);
saveas(gcf,[savePath 'GrandMean_Template.png'])

% sort the topomaps so the electrodes corresponds
namesVis    = {tmpEEG_NI2002.chanlocs(:).labels};
namesOrg    = {tmpEEG_MEA.chanlocs(:).labels};
reorderData = cellfun(@(c) find(strcmp(c, namesVis)), namesOrg, 'UniformOutput', false);
reorderData = cell2mat(reorderData(1:19));


sortEEG_NI2002 = zeros(4,19);
for i = 1 : 1 : 4
    sensVoltage          = tmpEEG_NI2002.msinfo.MSMaps(4).Maps(i,:)';
    sortEEG_NI2002(i,:)  = sensVoltage(reorderData);
end



%% Compute the global dissimilarity index
% Controls vs. Patients
load('redbluecmap.mat');
resultsGDI_COPA = gdi(tmpEEG_CON, tmpEEG_PAT, 4);

figure
imagesc(resultsGDI_COPA);
title('GDI Controls vs. Patients')
colormap(redbluecmap)
set(gca,'XTick',1:1:FitPars.nClasses,'XTickLabel',{'MS A'; 'MS B'; 'MS C'; 'MS D'})
set(gca,'YTick',1:1:FitPars.nClasses,'YTickLabel',{'MS A'; 'MS B'; 'MS C'; 'MS D'})
ylabel('RISP patients')
xlabel('Control group')

x = repmat(1:FitPars.nClasses,FitPars.nClasses,1); % generate x-coordinates
y = x';

t = num2cell(round(resultsGDI_COPA,2)); % 
t = cellfun(@num2str, t, 'UniformOutput', false); 
text(x(:), y(:), t, 'HorizontalAlignment', 'Center','FontWeight','bold','Color','k')

colorbar
caxis([-1 1])
saveas(gcf,[savePath 'GDI_ControlsVSPatients.jpeg'])

% Controls vs. GRAND MEAN
load('redbluecmap.mat');
resultsGDI_COMEA = gdi(tmpEEG_CON, tmpEEG_MEA, 4);

figure
imagesc(resultsGDI_COMEA);
title('GDI Controls vs. GRAND MEAN')
colormap(redbluecmap)
set(gca,'XTick',1:1:FitPars.nClasses,'XTickLabel',{'MS A'; 'MS B'; 'MS C'; 'MS D'})
set(gca,'YTick',1:1:FitPars.nClasses,'YTickLabel',{'MS A'; 'MS B'; 'MS C'; 'MS D'})
ylabel('Grand grand mean')
xlabel('Control group')

x = repmat(1:FitPars.nClasses,FitPars.nClasses,1); % generate x-coordinates
y = x';

t = num2cell(round(resultsGDI_COMEA,2)); % 
t = cellfun(@num2str, t, 'UniformOutput', false); 
text(x(:), y(:), t, 'HorizontalAlignment', 'Center','FontWeight','bold','Color','k')

colorbar
caxis([-1 1])
saveas(gcf,[savePath 'GDI_ControlsVSMean.jpeg'])

% Patients vs. GRAND MEAN
load('redbluecmap.mat');
resultsGDI_PAMEA = gdi(tmpEEG_PAT, tmpEEG_MEA, 4);

figure
imagesc(resultsGDI_PAMEA);
title('GDI Patients vs. GRAND MEAN')
colormap(redbluecmap)
set(gca,'XTick',1:1:FitPars.nClasses,'XTickLabel',{'MS A'; 'MS B'; 'MS C'; 'MS D'})
set(gca,'YTick',1:1:FitPars.nClasses,'YTickLabel',{'MS A'; 'MS B'; 'MS C'; 'MS D'})
ylabel('Grand grand mean')
xlabel('RISP patients')

x = repmat(1:FitPars.nClasses,FitPars.nClasses,1); % generate x-coordinates
y = x';

t = num2cell(round(resultsGDI_PAMEA,2)); % 
t = cellfun(@num2str, t, 'UniformOutput', false); 
text(x(:), y(:), t, 'HorizontalAlignment', 'Center','FontWeight','bold','Color','k')

colorbar
caxis([-1 1])
saveas(gcf,[savePath 'GDI_PatientsVSMean.jpeg'])

% NI2002 vs. GRAND MEAN
load('redbluecmap.mat');


resultsGDI_NI2002MEA = gdi(sortEEG_NI2002, tmpEEG_MEA, 4);

figure
imagesc(resultsGDI_NI2002MEA);
title('GDI Normative template (NI2002) vs. GRAND GRAND MEAN')
colormap(redbluecmap)
set(gca,'XTick',1:1:FitPars.nClasses,'XTickLabel',{'MS A'; 'MS B'; 'MS C'; 'MS D'})
set(gca,'YTick',1:1:FitPars.nClasses,'YTickLabel',{'MS A'; 'MS B'; 'MS C'; 'MS D'})
ylabel('Grand grand mean')
xlabel('Normative template (NI2002)')

x = repmat(1:FitPars.nClasses,FitPars.nClasses,1); % generate x-coordinates
y = x';

t = num2cell(round(resultsGDI_NI2002MEA,2)); % 
t = cellfun(@num2str, t, 'UniformOutput', false); 
text(x(:), y(:), t, 'HorizontalAlignment', 'Center','FontWeight','bold','Color','k')

colorbar
caxis([-1 1])
saveas(gcf,[savePath 'GDI_NI2002vsMEAN.jpeg'])