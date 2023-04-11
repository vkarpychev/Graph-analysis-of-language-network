%% ========================================================================
% ROI-to-ROI approach
%% ========================================================================

% set folders and group to analyse
clear 
project = 'fc_PPI';
task = 'neuroling';

maindir = pwd;
id = strfind(maindir,'/');
addpath(genpath([maindir(1:id(end) - 1),'/libraries/']));
datadir = [maindir(1:id(end) - 6),'/Data','/fMRI','/',project];
maskdir = [maindir(1:id(end) - 6),'/Data','/fMRI','/',project,'/mask','/AICHA','/regions'];

% obtaining a set of regions used for FC
masks = dir([maskdir,'/','*.nii']);
masks = {masks(:).name};
masks = regexprep(masks,'.nii','')';

% loading correlational matrices
cPPI_path_controls = dir([datadir,'/controls/',task,'/derivatives','/cPPI/','cPPI_*_orig.mat']);
load([datadir,'/controls/',task,'/derivatives','/cPPI/',cPPI_path_controls.name]);
cPPI_controls = ppi_cor;
cPPI_path_pwe = dir([datadir,'/PWE/',task,'/derivatives','/cPPI/','cPPI_*_orig.mat']);
load([datadir,'/PWE/',task,'/derivatives','/cPPI/',cPPI_path_controls.name]);
cPPI_pwe = ppi_cor;

clear ppi* sess
%% ========================================================================
% defining language-related networks

networks = {'sent_core';'sent_mem';'sent_visu'};
sent_core_L = {'S_Precentral-4-L';'G_Frontal_Sup-2-L';'S_Inf_Frontal-2-L';'G_Frontal_Inf_Tri-1-L';...
             'G_Frontal_Inf_Orb-1-L';'G_Insula-anterior-2-L';'G_Insula-anterior-3-L';'G_Temporal_Sup-4-L';...
             'G_Temporal_Mid-3-L';'G_Temporal_Mid-4-L';'S_Sup_Temporal-1-L';'S_Sup_Temporal-2-L';'S_Sup_Temporal-3-L';...
             'S_Sup_Temporal-4-L';'G_SupraMarginal-7-L';'G_Angular-2-L';'G_Supp_Motor_Area-2-L';'G_Supp_Motor_Area-3-L'};
score_L_id = find(contains(masks,sent_core_L));
sent_core_R = {'S_Precentral-4-R';'G_Frontal_Sup-2-R';'S_Inf_Frontal-2-R';'G_Frontal_Inf_Tri-1-R';...
             'G_Frontal_Inf_Orb-1-R';'G_Insula-anterior-2-R';'G_Insula-anterior-3-R';'G_Temporal_Sup-4-R';...
             'G_Temporal_Mid-3-R';'G_Temporal_Mid-4-R';'S_Sup_Temporal-1-R';'S_Sup_Temporal-2-R';'S_Sup_Temporal-3-R';...
             'S_Sup_Temporal-4-R';'G_SupraMarginal-7-R';'G_Angular-2-R';'G_Supp_Motor_Area-2-R';'G_Supp_Motor_Area-3-R'};
score_R_id = find(contains(masks,sent_core_R));
regions_id = [score_L_id;score_R_id];
regions = [sent_core_L;sent_core_R];

%% obtaining arrays for comparisons

language_regions = sort(regions_id);
P1 = zeros(size(language_regions,1),size(language_regions,1));
T1 = zeros(size(language_regions,1),size(language_regions,1));
P2 = zeros(size(language_regions,1),size(setdiff(1:length(cPPI_controls),language_regions),2));
T2 = zeros(size(language_regions,1),size(setdiff(1:length(cPPI_controls),language_regions),2));
source_node = language_regions;

while isempty(source_node) == 0
 
    for target_node = 1:length(cPPI_controls)
        
        array_controls = squeeze(cPPI_controls(source_node(1),target_node,:));
        array_controls = atanh(array_controls);
        array_pwe = squeeze(cPPI_pwe(source_node(1),target_node,:));
        array_pwe = atanh(array_pwe);
        [~,p,~,stats] = ttest2(array_controls,array_pwe);
        
        if ismember(target_node,language_regions) == 1
            
            if find(source_node(1) == language_regions) * find(target_node == language_regions) < find(source_node(1) == language_regions)^2
            
                P1(source_node(1) == language_regions,target_node == language_regions) = p;
                T1(source_node(1) == language_regions,target_node == language_regions) = stats.tstat;
                
            end
            
        else
            
            P2(source_node(1) == language_regions,target_node == setdiff(1:length(cPPI_controls),language_regions)) = p;
            T2(source_node(1) == language_regions,target_node == setdiff(1:length(cPPI_controls),language_regions)) = stats.tstat;
            
        end
        
    end
    source_node(1) = [];                  
end
 
language_masks = masks(language_regions);
[row1,col1] = find((0.05/length(P1(P1 ~= 0)) >= P1 & P1 > 0) == 1);
disp([char(language_masks(row1))  char(language_masks(col1))]);

non_language_masks = masks(setdiff(1:length(cPPI_controls),language_regions));
[row2,col2] = find((0.05/sum(~ isnan(P2),'all') >= P2 & P2 > 0) == 1);
disp([char(language_masks(row2))  char(non_language_masks(col2))]);

