function [gdiMatrix] = gdi(EEG1,EEG2,msnumber)
%GDI This function compute the global dissimilarity index
%   Detailed explanation goes here
%
% REFERENCES: 
%   [1] Lehmann, D., Skrandies, W., 1980. Reference-free identification of components of checkerboard-evoked multichannel potential fields. Electroencephalogr. Clin. Neurophysiol. 48, 609–621.
%   [2] Brandeis, D., Naylor, H., Halliday, R., Callaway, E., Yano, L., 1992. Scopolamine effects on visual information processing, attention, and event-related potential map latencies. Psychophysiology 29, 315–336.
%   [3] Brodbeck V, Kuhn A, von Wegner F, Morzelewski A, Tagliazucchi E, Borisov S, Michel CM, Laufs H. EEG microstates of wakefulness and NREM sleep. Neuroimage. 2012 Sep;62(3):2129-39. doi: 10.1016/j.neuroimage.2012.05.060. Epub 2012 May 30. PMID: 22658975.
% 
%     numOfElecs = EEG1.nbchan;
    
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
        

    gdiMatrix = zeros(msnumber);

%     matrix1 = (matrix1 - mean(matrix1)) ./ std(matrix1);
%     matrix2 = (matrix2 - mean(matrix2)) ./ std(matrix2);
    
    for i = 1 : 1 : msnumber
        for j = 1 : 1 : msnumber
            up      = sum(matrix1(i,:).*matrix2(j,:));
            down    = sqrt(sum(matrix1(i,:).^2)) * sqrt(sum(matrix2(j,:).^2));
            gdiMatrix(i,j) = up/down;
        end
    end
    
end

