
% Cleear the space
clear all; close all; clc;

% Define the paths to toolboxes
addpath('Z:\PRIOR\Toolboxes\eeglab_current\eeglab2019_0');
addpath('Z:\PRIOR\Toolboxes\fieldtrip-master');
addpath(genpath(pwd));

cfg_CUT_microstateNREM3;

savePath                = [resultsPath '\corcoef\'] ; 
resultsPath             = resultsSort; 


nameControls    = 'GrandMean Group 1.set';
namePatients    = 'GrandMean Group 2.set';
nameMean        = 'GrandGrandMean.set';

FitPars = struct('nClasses',4,'lambda',1,'b',20,'PeakFit',true, 'BControl',true,'Rectify',false,'Normalize',false);

%% Show and plot Controls
tmpEEG_CON = pop_loadset('filename',nameControls,'filepath',resultsPath);
pop_ShowIndMSMaps(tmpEEG_CON,FitPars.nClasses);
saveas(gcf,[savePath 'GrandMean_Controls.png'])

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

%% Compute the corelation
% Controls vs. Patients
load('redbluecmap.mat');
resultsCORR_COPA = zeros(FitPars.nClasses);

for i = 1 : 1 : FitPars.nClasses
    for j = 1 : 1 : FitPars.nClasses
        resTy = corrcoef(tmpEEG_CON.msinfo.MSMaps(FitPars.nClasses).Maps(i,:), tmpEEG_PAT.msinfo.MSMaps(FitPars.nClasses).Maps(j,:));
        resultsCORR_COPA(i,j) = resTy(1,2);
    end
end

figure
imagesc(resultsCORR_COPA);
title('Correlation Controls vs. Patients')
colormap(redbluecmap)
set(gca,'XTick',1:1:FitPars.nClasses,'XTickLabel',{'Controls MS1'; 'Controls MS2'; 'Controls MS3'; 'Controls MS4'})
set(gca,'YTick',1:1:FitPars.nClasses,'YTickLabel',{'Patients MS1'; 'Patients MS2'; 'Patients MS3'; 'Patients MS4'})

x = repmat(1:FitPars.nClasses,FitPars.nClasses,1); % generate x-coordinates
y = x';

t = num2cell(round(resultsCORR_COPA,2)); % 
t = cellfun(@num2str, t, 'UniformOutput', false); 
text(x(:), y(:), t, 'HorizontalAlignment', 'Center','FontWeight','bold','Color','k')

% colorbar
caxis([-1 1])
saveas(gcf,[savePath 'CORR_ControlsVSPatients.png'])

% Controls vs. GRAND MEAN
load('redbluecmap.mat');
resultsCORR_COMEA = zeros(FitPars.nClasses);

for i = 1 : 1 : FitPars.nClasses
    for j = 1 : 1 : FitPars.nClasses
        resTy = corrcoef(tmpEEG_CON.msinfo.MSMaps(FitPars.nClasses).Maps(i,:), tmpEEG_MEA.msinfo.MSMaps(FitPars.nClasses).Maps(j,:));
        resultsCORR_COMEA(i,j) = resTy(1,2);
    end
end

figure
imagesc(resultsCORR_COMEA);
title('Correlation Controls vs. GRAND MEAN')
colormap(redbluecmap)
set(gca,'XTick',1:1:FitPars.nClasses,'XTickLabel',{'Controls MS1'; 'Controls MS2'; 'Controls MS3'; 'Controls MS4'})
set(gca,'YTick',1:1:FitPars.nClasses,'YTickLabel',{'GRAND MEAN MS1'; 'GRAND MEAN MS2'; 'GRAND MEAN MS3'; 'GRAND MEAN MS4'})

x = repmat(1:FitPars.nClasses,FitPars.nClasses,1); % generate x-coordinates
y = x';

t = num2cell(round(resultsCORR_COMEA,2)); % 
t = cellfun(@num2str, t, 'UniformOutput', false); 
text(x(:), y(:), t, 'HorizontalAlignment', 'Center','FontWeight','bold','Color','k')

% colorbar
caxis([-1 1])
saveas(gcf,[savePath 'CORR_ControlsVSMean.png'])

% Patients vs. GRAND MEAN
load('redbluecmap.mat');
resultsCORR_PAMEA = zeros(FitPars.nClasses);

for i = 1 : 1 : FitPars.nClasses
    for j = 1 : 1 : FitPars.nClasses
        resTy = corrcoef(tmpEEG_PAT.msinfo.MSMaps(FitPars.nClasses).Maps(i,:), tmpEEG_MEA.msinfo.MSMaps(FitPars.nClasses).Maps(j,:));
        resultsCORR_PAMEA(i,j) = resTy(1,2);
    end
end

figure
imagesc(resultsCORR_PAMEA);
title('Correlation Patients vs. GRAND MEAN')
colormap(redbluecmap)
set(gca,'XTick',1:1:FitPars.nClasses,'XTickLabel',{'Patients MS1'; 'Patients MS2'; 'Patients MS3'; 'Patients MS4'})
set(gca,'YTick',1:1:FitPars.nClasses,'YTickLabel',{'GRAND MEAN MS1'; 'GRAND MEAN MS2'; 'GRAND MEAN MS3'; 'GRAND MEAN MS4'})

x = repmat(1:FitPars.nClasses,FitPars.nClasses,1); % generate x-coordinates
y = x';

t = num2cell(round(resultsCORR_PAMEA,2)); % 
t = cellfun(@num2str, t, 'UniformOutput', false); 
text(x(:), y(:), t, 'HorizontalAlignment', 'Center','FontWeight','bold','Color','k')

% colorbar
caxis([-1 1])
saveas(gcf,[savePath 'CORR_PatientsVSMean.png'])

% NI2002 vs. GRAND MEAN
load('redbluecmap.mat');

resultsCORR_NI2002MEA = zeros(FitPars.nClasses);

for i = 1 : 1 : FitPars.nClasses
    for j = 1 : 1 : FitPars.nClasses
        resTy = corrcoef(tmpEEG_NI2002.msinfo.MSMaps(FitPars.nClasses).Maps(i,1:19), tmpEEG_MEA.msinfo.MSMaps(FitPars.nClasses).Maps(j,:));
        resultsCORR_NI2002MEA(i,j) = resTy(1,2);
    end
end

figure
imagesc(resultsCORR_NI2002MEA);
title('Correlation Normative template (NI2002) vs. GRAND GRAND MEAN')
colormap(redbluecmap)
set(gca,'XTick',1:1:FitPars.nClasses,'XTickLabel',{'NI2002 MS1'; 'NI2002 MS2'; 'NI2002 MS3'; 'NI2002 MS4'})
set(gca,'YTick',1:1:FitPars.nClasses,'YTickLabel',{'GRAND MEAN MS1'; 'GRAND MEAN MS2'; 'GRAND MEAN MS3'; 'GRAND MEAN MS4'})

x = repmat(1:FitPars.nClasses,FitPars.nClasses,1); % generate x-coordinates
y = x';

t = num2cell(round(resultsCORR_NI2002MEA,2)); % 
t = cellfun(@num2str, t, 'UniformOutput', false); 
text(x(:), y(:), t, 'HorizontalAlignment', 'Center','FontWeight','bold','Color','k')

% colorbar
caxis([-1 1])
saveas(gcf,[savePath 'CORR_NI2002vsMEAN.png'])