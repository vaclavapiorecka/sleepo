%% SLEEP MICROSTATES IN RISP - analysis of MS consistency
% This script use the global map dissimilarity index.
%
% Input:
%       - Data preprocessed via the microstate analysis (script:
%       results_01_microstate_analysis.m)
% 
% Output:
%       - Maps of global map dissimilarity indexes:
%           - comparisson with the mean topography of the group
%           - comparisson with the grand grand mean topography 
% 
% AUTHORS:  Dr. Vaclava Piorecka
% CONTACT:  vaclava.piorecka@nudz.cz
% DATE:     2022/11/08 - creating
%           2023/03/09 - clearing and updating 

%% Define the parameters
savePath                = resultsPath; 
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


%% Compute the corelation
% Controls vs. Patients
load('redbluecmap.mat');    % MATLAB redbluecmap

resultsCORR_COPA = zeros(FitPars.nClasses);

for i = 1 : 1 : FitPars.nClasses
    for j = 1 : 1 : FitPars.nClasses
        resultsCORR_COPA(i,j) = corr2(tmpEEG_CON.msinfo.MSMaps(FitPars.nClasses).Maps(i,:), tmpEEG_PAT.msinfo.MSMaps(FitPars.nClasses).Maps(j,:));
    end
end

figure
imagesc(resultsCORR_COPA);
title('Correlation Controls vs. Patients')
colormap(redbluecmap)
set(gca,'XTick',1:1:FitPars.nClasses,'XTickLabel',{'MS A'; 'MS B'; 'MS C'; 'MS D'})
set(gca,'YTick',1:1:FitPars.nClasses,'YTickLabel',{'MS A'; 'MS B'; 'MS C'; 'MS D'})
ylabel('RISP patients')
xlabel('Control group')

x = repmat(1:FitPars.nClasses,FitPars.nClasses,1); % generate x-coordinates
y = x';

t = num2cell(round(resultsCORR_COPA,2)); % 
t = cellfun(@num2str, t, 'UniformOutput', false); 
text(x(:), y(:), t, 'HorizontalAlignment', 'Center','FontWeight','bold','Color','k')

colorbar
caxis([-1 1])
saveas(gcf,[savePath 'CORR_ControlsVSPatients.jpeg'])

% Controls vs. GRAND MEAN
load('redbluecmap.mat');
resultsCORR_COMEA = zeros(FitPars.nClasses);

for i = 1 : 1 : FitPars.nClasses
    for j = 1 : 1 : FitPars.nClasses
        resultsCORR_COMEA(i,j) = corr2(tmpEEG_CON.msinfo.MSMaps(FitPars.nClasses).Maps(i,:), tmpEEG_MEA.msinfo.MSMaps(FitPars.nClasses).Maps(j,:));
    end
end

figure
imagesc(resultsCORR_COMEA);
title('Correlation Controls vs. GRAND MEAN')
colormap(redbluecmap)
set(gca,'XTick',1:1:FitPars.nClasses,'XTickLabel',{'MS A'; 'MS B'; 'MS C'; 'MS D'})
set(gca,'YTick',1:1:FitPars.nClasses,'YTickLabel',{'MS A'; 'MS B'; 'MS C'; 'MS D'})
ylabel('Grand grand mean')
xlabel('Control group')

x = repmat(1:FitPars.nClasses,FitPars.nClasses,1); % generate x-coordinates
y = x';

t = num2cell(round(resultsCORR_COMEA,2)); % 
t = cellfun(@num2str, t, 'UniformOutput', false); 
text(x(:), y(:), t, 'HorizontalAlignment', 'Center','FontWeight','bold','Color','k')

colorbar
caxis([-1 1])
saveas(gcf,[savePath 'CORR_ControlsVSMean.jpeg'])

% Patients vs. GRAND MEAN
load('redbluecmap.mat');
resultsCORR_PAMEA = zeros(FitPars.nClasses);

for i = 1 : 1 : FitPars.nClasses
    for j = 1 : 1 : FitPars.nClasses
        resultsCORR_PAMEA(i,j) = corr2(tmpEEG_PAT.msinfo.MSMaps(FitPars.nClasses).Maps(i,:), tmpEEG_MEA.msinfo.MSMaps(FitPars.nClasses).Maps(j,:));
    end
end

figure
imagesc(resultsCORR_PAMEA);
title('Correlation Patients vs. GRAND MEAN')
colormap(redbluecmap)
set(gca,'XTick',1:1:FitPars.nClasses,'XTickLabel',{'MS A'; 'MS B'; 'MS C'; 'MS D'})
set(gca,'YTick',1:1:FitPars.nClasses,'YTickLabel',{'MS A'; 'MS B'; 'MS C'; 'MS D'})
ylabel('Grand grand mean')
xlabel('RISP patients')

x = repmat(1:FitPars.nClasses,FitPars.nClasses,1); % generate x-coordinates
y = x';

t = num2cell(round(resultsCORR_PAMEA,2)); % 
t = cellfun(@num2str, t, 'UniformOutput', false); 
text(x(:), y(:), t, 'HorizontalAlignment', 'Center','FontWeight','bold','Color','k')

colorbar
caxis([-1 1])
saveas(gcf,[savePath 'CORR_PatientsVSMean.jpeg'])

%% NI2002 vs. GRAND MEAN
load('redbluecmap.mat');

resultsCORR_NI2002MEA = zeros(FitPars.nClasses);

for i = 1 : 1 : FitPars.nClasses
    for j = 1 : 1 : FitPars.nClasses
        resultsCORR_NI2002MEA(i,j) = corr2(sortEEG_NI2002(i,:), tmpEEG_MEA.msinfo.MSMaps(FitPars.nClasses).Maps(j,:));
    end
end

figure
imagesc(resultsCORR_NI2002MEA);
title('Correlation Normative template (NI2002) vs. GRAND GRAND MEAN')
colormap(redbluecmap)
set(gca,'XTick',1:1:FitPars.nClasses,'XTickLabel',{'MS A'; 'MS B'; 'MS C'; 'MS D'})
set(gca,'YTick',1:1:FitPars.nClasses,'YTickLabel',{'MS A'; 'MS B'; 'MS C'; 'MS D'})
ylabel('Grand grand mean')
xlabel('Normative template')

x = repmat(1:FitPars.nClasses,FitPars.nClasses,1); % generate x-coordinates
y = x';

t = num2cell(round(resultsCORR_NI2002MEA,2)); % 
t = cellfun(@num2str, t, 'UniformOutput', false); 
text(x(:), y(:), t, 'HorizontalAlignment', 'Center','FontWeight','bold','Color','k')

colorbar
caxis([-1 1])
saveas(gcf,[savePath 'CORR_NI2002vsMEAN.jpeg'])

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
