%% ========================================================================
% Graph-theory analysis 
%% ========================================================================
% set folders and group to analyse
clear 
project = 'fc_PPI';
group = 'PWE';
task = 'neuroling';

maindir = pwd;
id = strfind(maindir,'/');
addpath(genpath([maindir(1:id(end) - 1),'/libraries/']));
datadir = [maindir(1:id(end) - 6),'/Data','/fMRI','/',project,'/',group,'/',task,'/derivatives','/cPPI'];
resultdir = [maindir(1:id(end) - 6),'/Results','/fMRI','/',project,'/',group];
maskdir = [maindir(1:id(end) - 6),'/Data','/fMRI','/',project,'/mask','/AICHA','/language_regions'];

% obtaining a set of regions used for FC
masks = dir([maskdir,'/','*.nii']);
masks = {masks(:).name};
masks = regexprep(masks,'.nii','')';
subject = dir([datadir,'/','sub-*']);
regions_id = 1:length(masks);

% loadning communities based on Louvain method
Ci = struct2cell(load([resultdir,'/','Ci_thr.mat']));
Ci = cell2mat(Ci);

%% ========================================================================
% load a cPPI structure for all participants

cPPI_path = dir([datadir,'/','cPPI_*_thr.mat']);
cPPI_path = natsortfiles(cPPI_path);
GT_table(1,1) = {'participant'};GT_table(1,2) = {'Eglob'};GT_table(1,3) = {'Eloc'};GT_table(1,4) = {'IS'};

for i = 1:length(cPPI_path)
    load([datadir,'/',cPPI_path(i).name]);
    
    for pat = 1:size(ppi_cor_thr,3)
        
        ppi_pat = ppi_cor_thr(:,:,pat);
       % ppi_pat(ppi_pat > 0) = 1;
        GT_table{pat+1,1} = subject(pat).name;
                        
        % global efficiency
       %  Eglob = GT_metrics(ppi_pat,regions_id);
        Eglob = efficiency_wei(ppi_pat);
        GT_table(pat+1,2) = {round(Eglob,3)};

        % local efficiency
        Eloc = 0;
        for n = unique(Ci)'
            % E_com = GT_metrics(ppi_pat,regions_id(Ci == n));
            E_com = efficiency_wei(ppi_pat(regions_id(Ci == n),regions_id(Ci == n)));
            Eloc = Eloc + E_com;
            clear E_com
        end
        
        IS = Eglob - Eloc/length(unique(Ci));
        GT_table(pat+1,3) = {round(Eloc/length(unique(Ci)),3)};
        GT_table(pat+1,4) = {round(IS,3)};
        
        if pat == 1
            
            [PC,WM,~,~] = participation_coef(ppi_pat,Ci);
            PC_all = [Ci PC];
            WM_all = [Ci WM];
            
         else
             
            [PC,WM,~,~] = participation_coef(ppi_pat,Ci);
            PC_all = [PC_all PC];
            WM_all = [WM_all WM];

        end
    end
    
    PC_all = [masks num2cell(PC_all)];
    WM_all = [masks num2cell(WM_all)];
    
    writetable(cell2table(PC_all,'VariableNames',['region','module',{subject.name}]),...
                [resultdir,'/PC_table_',cell2mat(regexp(cPPI_path(i).name,'\d+','match')),'.csv']);
            
    writetable(cell2table(WM_all,'VariableNames',['region','module',{subject.name}]),...
                [resultdir,'/WM_table_',cell2mat(regexp(cPPI_path(i).name,'\d+','match')),'.csv']);
    
    writetable(cell2table(GT_table(2:end,:),'VariableNames',GT_table(1,:)),...
                [resultdir,'/GT_table_',cell2mat(regexp(cPPI_path(i).name,'\d+','match')),'.csv']);
end
