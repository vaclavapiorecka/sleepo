function [gmdMatrix, RMatrix] = gmd(EEG1,EEG2,msnumber)
%GMD This function compute the global map dissimilarity
%
% REFERENCES: 
%   [1] Lehmann, D., Skrandies, W., 1980. Reference-free identification of components of checkerboard-evoked multichannel potential fields. Electroencephalogr. Clin. Neurophysiol. 48, 609–621.
%   [2] Brandeis, D., Naylor, H., Halliday, R., Callaway, E., Yano, L.,
%   1992. Scopolamine effects on visual information processing, attention, and event-related potential map latencies. Psychophysiology 29, 315–336.
%   [3] Brodbeck V, Kuhn A, von Wegner F, Morzelewski A, Tagliazucchi E, Borisov S, Michel CM, Laufs H. EEG microstates of wakefulness and NREM sleep. Neuroimage. 2012 Sep;62(3):2129-39. doi: 10.1016/j.neuroimage.2012.05.060. Epub 2012 May 30. PMID: 22658975.
% 

    
    if isfield(EEG1,'msinfo') &&  isfield(EEG2,'msinfo')
        matrix1 = EEG1.msinfo.MSMaps(msnumber).Maps;
        matrix2 = EEG2.msinfo.MSMaps(msnumber).Maps;
    elseif isfield(EEG1,'msinfo')
        matrix1 = EEG1.msinfo.MSMaps(msnumber).Maps;
        matrix2 = EEG2;
    elseif isfield(EEG2,'msinfo')
        matrix1 = EEG1;
        matrix2 = EEG2.msinfo.MSMaps(msnumber).Maps;
    else 
        matrix1 = EEG1;
        matrix2 = EEG2;
    end
        
    numOfElecs = size(matrix1,2);
    
    gmdMatrix = zeros(msnumber);
    RMatrix = zeros(msnumber);
    for i = 1 : 1 : msnumber
        for j = 1 : 1 : msnumber
            diff1   = matrix1(i,:) - mean(matrix1(i,:));
            diff2   = matrix2(j,:) - mean(matrix2(j,:));
            
            gmdPart = (diff1./(sqrt(1/numOfElecs * sum(diff1.^2))) - diff2./(sqrt(1/numOfElecs * sum(diff2.^2)))).^2;
            gmd     = sqrt(1/numOfElecs * sum(gmdPart));
            
            gmdMatrix(i,j) = gmd;
            RMatrix(i,j)   = 1 - gmd^2/2;
        end
    end
end

