%% SLEEP MICROSTATES IN RISP - analysis of MS consistency
% This script use the global map dissimilarity index.
%
% Input:
%       - Data preprocessed via the microstate analysis (script:
%       results_01_microstate_analysis.m)
% 
% Output:
%       - Maps of global map dissimilarity indexes:
%           - correlation in case of control group
%           - correlation in case of RISP patients group
%           - correlation in case of Koenig et al. 2002 template
% 
% AUTHORS:  Dr. Vaclava Piorecka
% CONTACT:  vaclava.piorecka@nudz.cz
% DATE:     2023/03/16 - creating
%           

%% Define the parameters
savePath                = resultsPath; 
resultsPath             = resultsSort; 

nameControls    = 'GrandMean Group 1.set';
namePatients    = 'GrandMean Group 2.set';
nameMean        = 'GrandGrandMean.set';

FitPars = struct('nClasses',4,'lambda',1,'b',20,'PeakFit',true, 'BControl',true,'Rectify',false,'Normalize',false);

%% Load grand mean topologies of Control group
tmpEEG_CON = pop_loadset('filename',nameControls,'filepath',resultsPath);

%% Load grand mean topologies of Patients group
tmpEEG_PAT = pop_loadset('filename',namePatients,'filepath',resultsPath);

%% Load grand grand mean topologies of whole dataset
tmpEEG_MEA = pop_loadset('filename',nameMean,'filepath',resultsPath);

%% Load public mean template
tmpEEG_NI2002 = pop_loadset('filename','Norms NI2002.set','filepath',resultsPath);


%% Compute the global dissimilarity index
load('redbluecmap.mat');

% Controls 
resultsGDI_CO = gdi(tmpEEG_CON, tmpEEG_CON, 4);

figure
imagesc(resultsGDI_CO);
title('GDI Controls')
colormap(redbluecmap)
set(gca,'XTick',1:1:FitPars.nClasses,'XTickLabel',{'MS A'; 'MS B'; 'MS C'; 'MS D'})
set(gca,'YTick',1:1:FitPars.nClasses,'YTickLabel',{'MS A'; 'MS B'; 'MS C'; 'MS D'})
ylabel('Control group')
xlabel('Control group')

x = repmat(1:FitPars.nClasses,FitPars.nClasses,1); % generate x-coordinates
y = x';

t = num2cell(round(resultsGDI_CO,2)); % 
t = cellfun(@num2str, t, 'UniformOutput', false); 
text(x(:), y(:), t, 'HorizontalAlignment', 'Center','FontWeight','bold','Color','k')

colorbar
caxis([-1 1])
saveas(gcf,[savePath 'GDI_AUTO_Controls.jpeg'])

% GRAND GRAND MEAN
resultsGDI_MEA = gdi(tmpEEG_MEA, tmpEEG_MEA, 4);

figure
imagesc(resultsGDI_MEA);
title('GDI GRAND GRAND MEAN')
colormap(redbluecmap)
set(gca,'XTick',1:1:FitPars.nClasses,'XTickLabel',{'MS A'; 'MS B'; 'MS C'; 'MS D'})
set(gca,'YTick',1:1:FitPars.nClasses,'YTickLabel',{'MS A'; 'MS B'; 'MS C'; 'MS D'})
ylabel('Grand grand mean')
xlabel('Grand grand mean')

x = repmat(1:FitPars.nClasses,FitPars.nClasses,1); % generate x-coordinates
y = x';

t = num2cell(round(resultsGDI_MEA,2)); % 
t = cellfun(@num2str, t, 'UniformOutput', false); 
text(x(:), y(:), t, 'HorizontalAlignment', 'Center','FontWeight','bold','Color','k')

colorbar
caxis([-1 1])
saveas(gcf,[savePath 'GDI_AUTO_GrandGrandMean.jpeg'])

% Patients
resultsGDI_PA = gdi(tmpEEG_PAT, tmpEEG_PAT, 4);

figure
imagesc(resultsGDI_PA);
title('GDI Patients ')
colormap(redbluecmap)
set(gca,'XTick',1:1:FitPars.nClasses,'XTickLabel',{'MS A'; 'MS B'; 'MS C'; 'MS D'})
set(gca,'YTick',1:1:FitPars.nClasses,'YTickLabel',{'MS A'; 'MS B'; 'MS C'; 'MS D'})
ylabel('RISP patients')
xlabel('RISP patients')

x = repmat(1:FitPars.nClasses,FitPars.nClasses,1); % generate x-coordinates
y = x';

t = num2cell(round(resultsGDI_PA,2)); % 
t = cellfun(@num2str, t, 'UniformOutput', false); 
text(x(:), y(:), t, 'HorizontalAlignment', 'Center','FontWeight','bold','Color','k')

colorbar
caxis([-1 1])
saveas(gcf,[savePath 'GDI_AUTO_Patients.jpeg'])

% NI2002 BY KOENIG ET AL. 2002
resultsGDI_NI2002 = gdi(tmpEEG_NI2002, tmpEEG_NI2002, 4);

figure
imagesc(resultsGDI_NI2002);
title('GDI Normative template (NI2002)')
colormap(redbluecmap)
set(gca,'XTick',1:1:FitPars.nClasses,'XTickLabel',{'MS A'; 'MS B'; 'MS C'; 'MS D'})
set(gca,'YTick',1:1:FitPars.nClasses,'YTickLabel',{'MS A'; 'MS B'; 'MS C'; 'MS D'})
ylabel('Normative template (NI2002)')
xlabel('Normative template (NI2002)')

x = repmat(1:FitPars.nClasses,FitPars.nClasses,1); % generate x-coordinates
y = x';

t = num2cell(round(resultsGDI_NI2002,2)); % 
t = cellfun(@num2str, t, 'UniformOutput', false); 
text(x(:), y(:), t, 'HorizontalAlignment', 'Center','FontWeight','bold','Color','k')

colorbar
caxis([-1 1])
saveas(gcf,[savePath 'GDI_AUTO_NI2002.jpeg'])