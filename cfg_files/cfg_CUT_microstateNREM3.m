%% SLEEP MICROSTATES IN RISP
% Configuration file that specifies the forlder to data and results saving.
% Define the basice parameters for the microstate analysis. 
% Also define the main focus on sleep stage.
% 
% AUTHORS:  Dr. Vaclava Piorecka
% CONTACT:  vaclava.piorecka@nudz.cz
% DATE:     2023\01\23 - creatinf of configuration file


% Define important paths (for data loading and saving)
dataControls = 'D:\PRIOR\Projects\SLEEPO\results\data_cut\controls\';
dataPatients = 'D:\PRIOR\Projects\SLEEPO\results\data_cut\patients\';

resultsPath             = 'D:\PRIOR\Projects\SLEEPO\results\data_cut\NREM3\BROADBAND\'; 
resultsPreproControls   = 'D:\PRIOR\Projects\SLEEPO\results\data_cut\NREM3\BROADBAND\preprocessed\controls\'; 
resultsPreproPatients   = 'D:\PRIOR\Projects\SLEEPO\results\data_cut\NREM3\BROADBAND\preprocessed\patients\';
resultsTemp             = 'D:\PRIOR\Projects\SLEEPO\results\data_cut\NREM3\BROADBAND\templates\'; 
resultsSort             = 'D:\PRIOR\Projects\SLEEPO\results\data_cut\NREM3\BROADBAND\sorted\'; 
resultsCorr             = 'D:\PRIOR\Projects\SLEEPO\results\data_cut\NREM3\BROADBAND\correlations\'; 
resultsGDI              = 'D:\PRIOR\Projects\SLEEPO\results\data_cut\NREM3\BROADBAND\gdi\'; 

if ~exist(resultsPath, 'dir')
    mkdir(resultsPath)
end

if ~exist(resultsPreproControls, 'dir')
    mkdir(resultsPreproControls)
end

if ~exist(resultsPreproPatients, 'dir')
    mkdir(resultsPreproPatients)
end

if ~exist(resultsTemp, 'dir')
    mkdir(resultsTemp)
end

if ~exist(resultsSort, 'dir')
    mkdir(resultsSort)
end

if ~exist(resultsCorr, 'dir')
    mkdir(resultsCorr)
end

if ~exist(resultsGDI, 'dir')
    mkdir(resultsGDI)
end

% Parameters for analysis
LowCutFilter  =  1;
HighCutFilter = 40;

% Sleep phase
tagSleep = {'S3'};


