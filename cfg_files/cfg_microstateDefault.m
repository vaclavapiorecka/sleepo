%% SLEEP MICROSTATES IN RISP
% Define the basic parameters for the microstate analysis. 
% 
% AUTHORS:  Dr. Vaclava Piorecka
% CONTACT:  vaclava.piorecka@nudz.cz
% DATE:     2023/01/23 - creatinf of configuration file

% These are the paramters for the fitting based on GFP peaks only
FitPars = struct('nClasses',4,'lambda',1,'b',20,'PeakFit',true, 'BControl',true,'Rectify',false,'Normalize',false);

% Define the parameters for clustering
ClustPars = struct('MinClasses',4,'MaxClasses',6,'GFPPeaks',true,'IgnorePolarity',true,'MaxMaps',inf,'Restarts',20', 'UseAAHC',false,'Normalize',false);
