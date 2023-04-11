%% ========================================================================
% set folders and group to analyse

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
regions_id = 1:length(masks);

%% ========================================================================
% Community Louvain detection/modularity

for i = 1:length(group)

    datadir = [maindir(1:id(end) - 6),'/Data','/fMRI','/',project,'/',group{i},'/',task,'/derivatives','/cPPI'];
    resultdir = [maindir(1:id(end) - 6),'/Results','/fMRI','/',project,'/',group{i}];
    subject = dir([datadir,'/','sub-*']);
    cPPI_path = dir([datadir,'/','cPPI_*_orig.mat']);
    load([datadir,'/',cPPI_path.name]);

    for thr = 5:5:20

        for pat = 1:size(ppi_cor,3)

            ppi_pat = ppi_cor(:,:,pat);
            ppi_pat = ppi_pat - diag(diag(ppi_pat));
            ppi_pat(isnan(ppi_pat)) = 0;
            idx = ~ logical(eye(size(ppi_pat)));
            ppi_pat(idx) = atanh(ppi_pat(idx));
            ppi_pat(ppi_pat < 0) = 0;
    
            values = reshape(ppi_pat,size(ppi_pat,1)^2,1);
            values(values < prctile(values,(100 - thr))) = 0;
            ppi_thr = reshape(values,size(ppi_pat,1),size(ppi_pat,2));
            [Ci{pat,find(thr == 5:5:20)},~] = modularity_individual_Louvain(ppi_thr,1.0);
            
            if thr == 20
               [Ci_pat{find(pat == 1:size(ppi_cor,3)),1},Q_pat(pat,1)] = modularity_group_Louvain(Ci(pat,:));
            end

        end

    [Ci_group{find(thr == 5:5:20),1},~] = modularity_group_Louvain(Ci(:,find(thr == 5:5:20)));

    end

    [Ci_thr,Q_thr] = modularity_group_Louvain(Ci_group);
    save([resultdir,'/','Q_thr.mat'],'Q_thr');
    save([resultdir,'/','Ci_thr.mat'],'Ci_thr');
    save([resultdir,'/','Q_pat.mat'],'Q_pat');
    save([resultdir,'/','Ci_pat.mat'],'Ci_pat');

end

%% ========================================================================
% Significance of the difference in the modularity (Q), variance of information (VIn)
% and mutual information (MIn) between groups (controls and PWE)

for i = 1:length(group)

    resultdir = [maindir(1:id(end) - 6),'/Results','/fMRI','/',project,'/',group{i}];
    load([resultdir,'/','Ci_pat.mat'])
    load([resultdir,'/','Ci_thr.mat'])
    load([resultdir,'/','Q_pat.mat'])
    load([resultdir,'/','Q_thr.mat'])
    if i == 1

        Ci_ind_controls = Ci_pat';
        Ci_group_controls = Ci_thr;
        Q_ind_controls = Q_pat;
        Q_group_controls = Q_thr;
    else
        Ci_ind_PWE = Ci_pat'; 
        Ci_group_PWE = Ci_thr;
        Q_ind_PWE = Q_pat;
        Q_group_PWE = Q_thr;
    end 

end
clear Ci_pat Ci_thr Q_pat Q_thr

Ci_ind = horzcat(Ci_ind_controls, Ci_ind_PWE);
col = size(Ci_ind,2);

% random permutation 
nperm = 1000;
for j = 1:nperm

    shuffle = randsample(1:col,col,false);
    Ci_ind_perm = Ci_ind(:,shuffle);
    g1_ind_perm = Ci_ind_perm(:,1:size(Ci_ind_controls,2));
    g2_ind_perm = Ci_ind_perm(:,1 + size(Ci_ind_controls,2):end);

    [Ci_ind_perm_1{j,1},Q_ind_perm_1(j,1)] = modularity_group_Louvain(g1_ind_perm);
    [Ci_ind_perm_2{j,1},Q_ind_perm_2(j,1)] = modularity_group_Louvain(g2_ind_perm);
    [VIn_perm(j,1), MIn_perm(j,1)] = partition_distance(Ci_ind_perm_1{j,1}, Ci_ind_perm_2{j,1});

    for idx1 = unique(Ci_ind_perm_1{j,1})'
    
        for idx2 = unique(Ci_ind_perm_2{j,1})'
        
            n1 = intersect(find(Ci_ind_perm_1{j,1} == idx1),find(Ci_ind_perm_2{j,1} == idx2));
            n2 = unique([find(Ci_ind_perm_1{j,1} == idx1);find(Ci_ind_perm_2{j,1} == idx2)]);
            nodes_overlap{j,1}(idx1,idx2) = length(intersect(n1,n2))/length(n2);

        end

    end

end

% significance of Q
Q_perm = sort(abs(Q_ind_perm_1 - Q_ind_perm_2));
Q = abs(Q_group_controls - Q_group_PWE);
p_Q = find(Q_perm >= Q);
p_Q = length(p_Q)/nperm;

% significance of VIn
[VIn, MIn] = partition_distance(Ci_group_controls,Ci_group_PWE);
VIn_perm = sort(abs(VIn_perm));
p_VIn = find(VIn_perm >= VIn);
p_VIn = length(p_VIn)/nperm;

% significance of MIn
MIn_perm = sort(abs(MIn_perm));
p_MIn = find(MIn_perm >= MIn);
p_MIn = length(p_MIn)/nperm;
