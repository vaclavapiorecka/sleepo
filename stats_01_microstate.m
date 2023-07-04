%% SLEEP MICROSTATES IN RISP - statistical evaluation
% This script use statistical methods for evaluation.
%
% Input:
%       - Table with resulting parameters from MS analysis.
% 
% Output:
%       - Statistics tables with p-values 
%
% AUTHORS:  Dr. Vaclava Piorecka
% CONTACT:  vaclava.piorecka@nudz.cz
% DATE:     2023/03/16 - creating

load([resultsPath 'ResultsFromGrandGrandMean.mat']);    % load variable: Results

tfGroup1 = Results.Group == 1; 
tfGroup2 = Results.Group == 2; 

%% Analysis

pTable.Names(1)     = {'MS1'};
pTable.Names(2)     = {'MS2'};
pTable.Names(3)     = {'MS3'};
pTable.Names(4)     = {'MS4'};
pTable.Names(5)     = {'Mean'};
pTable.Names        = pTable.Names';

pTable.Coverage(1) = ranksum(Results.Contribution_1(tfGroup1),Results.Contribution_1(tfGroup2));
pTable.Coverage(2) = ranksum(Results.Contribution_2(tfGroup1),Results.Contribution_2(tfGroup2));
pTable.Coverage(3) = ranksum(Results.Contribution_3(tfGroup1),Results.Contribution_3(tfGroup2));
pTable.Coverage(4) = ranksum(Results.Contribution_4(tfGroup1),Results.Contribution_4(tfGroup2));
pTable.Coverage(5) = NaN;

pTable.Coverage = pTable.Coverage';

pTable.Duration(1) = ranksum(Results.Duration_1(tfGroup1),Results.Duration_1(tfGroup2));
pTable.Duration(2) = ranksum(Results.Duration_2(tfGroup1),Results.Duration_2(tfGroup2));
pTable.Duration(3) = ranksum(Results.Duration_3(tfGroup1),Results.Duration_3(tfGroup2));
pTable.Duration(4) = ranksum(Results.Duration_4(tfGroup1),Results.Duration_4(tfGroup2));
pTable.Duration(5) = ranksum(Results.MeanDuration(tfGroup1),Results.MeanDuration(tfGroup2));

pTable.Duration = pTable.Duration';

pTable.Occurrence(1) = ranksum(Results.Occurrence_1(tfGroup1),Results.Occurrence_1(tfGroup2));
pTable.Occurrence(2) = ranksum(Results.Occurrence_2(tfGroup1),Results.Occurrence_2(tfGroup2));
pTable.Occurrence(3) = ranksum(Results.Occurrence_3(tfGroup1),Results.Occurrence_3(tfGroup2));
pTable.Occurrence(4) = ranksum(Results.Occurrence_4(tfGroup1),Results.Occurrence_4(tfGroup2));
pTable.Occurrence(5) = ranksum(Results.MeanOccurrence(tfGroup1),Results.MeanOccurrence(tfGroup2));

pTable.Occurrence = pTable.Occurrence';


pTable.GFP(1) = ranksum(Results.MeanGFP_1(tfGroup1),Results.MeanGFP_1(tfGroup2));
pTable.GFP(2) = ranksum(Results.MeanGFP_2(tfGroup1),Results.MeanGFP_2(tfGroup2));
pTable.GFP(3) = ranksum(Results.MeanGFP_3(tfGroup1),Results.MeanGFP_3(tfGroup2));
pTable.GFP(4) = ranksum(Results.MeanGFP_4(tfGroup1),Results.MeanGFP_4(tfGroup2));
pTable.GFP(5) = NaN;

pTable.GFP = pTable.GFP';

pTable = struct2table(pTable);

writetable(pTable,[resultsPath 'statistics.xls'])

pTableTransition.OrgTM1(1) = NaN;
pTableTransition.OrgTM1(2) = ranksum(Results.OrgTM_12(tfGroup1),Results.OrgTM_12(tfGroup2));
pTableTransition.OrgTM1(3) = ranksum(Results.OrgTM_13(tfGroup1),Results.OrgTM_13(tfGroup2));
pTableTransition.OrgTM1(4) = ranksum(Results.OrgTM_14(tfGroup1),Results.OrgTM_14(tfGroup2));

pTableTransition.OrgTM1 = pTableTransition.OrgTM1';

pTableTransition.OrgTM2(1) = ranksum(Results.OrgTM_21(tfGroup1),Results.OrgTM_21(tfGroup2));
pTableTransition.OrgTM2(2) = NaN;
pTableTransition.OrgTM2(3) = ranksum(Results.OrgTM_23(tfGroup1),Results.OrgTM_23(tfGroup2));
pTableTransition.OrgTM2(4) = ranksum(Results.OrgTM_24(tfGroup1),Results.OrgTM_24(tfGroup2));

pTableTransition.OrgTM2 = pTableTransition.OrgTM2';

pTableTransition.OrgTM3(1) = ranksum(Results.OrgTM_31(tfGroup1),Results.OrgTM_31(tfGroup2));
pTableTransition.OrgTM3(2) = ranksum(Results.OrgTM_32(tfGroup1),Results.OrgTM_32(tfGroup2));
pTableTransition.OrgTM3(3) = NaN;
pTableTransition.OrgTM3(4) = ranksum(Results.OrgTM_34(tfGroup1),Results.OrgTM_34(tfGroup2));

pTableTransition.OrgTM3 = pTableTransition.OrgTM3';

pTableTransition.OrgTM4(1) = ranksum(Results.OrgTM_41(tfGroup1),Results.OrgTM_41(tfGroup2));
pTableTransition.OrgTM4(2) = ranksum(Results.OrgTM_42(tfGroup1),Results.OrgTM_42(tfGroup2));
pTableTransition.OrgTM4(3) = ranksum(Results.OrgTM_43(tfGroup1),Results.OrgTM_43(tfGroup2));
pTableTransition.OrgTM4(4) = NaN;

pTableTransition.OrgTM4 = pTableTransition.OrgTM4';

pTableTransition = struct2table(pTableTransition);

writetable(pTableTransition,[resultsPath 'statisticTransition.xls'])
