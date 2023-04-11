%% ========================================================================

clear 
project = 'fc_PPI';
group = {'controls','PWE'};
task = 'neuroling';
maindir = pwd;
id = strfind(maindir,'/');
addpath(genpath([maindir(1:id(end) - 1),'/libraries/']));

% obtaining a set of regions used for FC
maskdir = [maindir(1:id(end) - 6),'/Data','/fMRI','/',project,'/mask','/AICHA','/language_regions'];
masks = dir([maskdir,'/','*.nii']);
masks = {masks(:).name};
masks = regexprep(masks,'.nii','')';

%% ========================================================================
% thresholding connectivity matrices
for i = 1:length(group)

    datadir = [maindir(1:id(end) - 6),'/Data','/fMRI','/',project,'/',group{i},'/',task,'/derivatives','/cPPI'];
    cPPI_path = dir([datadir,'/','cPPI_*_orig.mat']);
    load([datadir,'/',cPPI_path.name]);
    clear ppi_ts_brain ppi_ts_ppi ppi_ts_psy 

    for thr = 1:1:99
        for pat = 1:size(ppi_cor,3)
            
            ppi = ppi_cor(:,:,pat);
            ppi = ppi - diag(diag(ppi));
            ppi(isnan(ppi)) = 0;
            idx = ~ logical(eye(size(ppi)));
            ppi(idx) = atanh(ppi(idx));
            ppi(ppi < 0) = 0;
            
            values = reshape(ppi,size(ppi,1)^2,1);
            values(values < prctile(values,(100 - thr))) = 0;
            ppi_thr = reshape(values,size(ppi,1),size(ppi,2));
            ppi_cor_thr(:,:,pat) = ppi_thr;
            clear ppi_thr
     
        end
        % save([datadir,'/','cPPI_output_orig','_',num2str(thr),'_thr'],'ppi_cor_thr');
        if thr == 1
            ppi_cor_group = mean(ppi_cor_thr,3);
        else
            ppi_cor_group = ppi_cor_group + mean(ppi_cor_thr,3);
        end

    end

end
