%% ========================================================================

clear 
project = 'fc_PPI';
group = {'controls','PWE'};
task = 'neuroling';
maindir = pwd;
id = strfind(maindir,'/');
addpath(genpath([maindir(1:id(end) - 1),'/libraries/']));

for i = 1:length(group)

    resultsdir = [maindir(1:id(end) - 6),'/Results','/fMRI','/',project,'/',group{i},'/'];
    PC_path = dir([resultsdir,'/','PC_table_*']);
    PC_path = natsortfiles(PC_path);
    WM_path = dir([resultsdir,'/','WM_table_*']);
    WM_path = natsortfiles(WM_path);
    
    for k = 1:length(PC_path)
        
        PC_table = table2cell(readtable([resultsdir,'/',PC_path(k).name]));
        WM_table = table2cell(readtable([resultsdir,'/',WM_path(k).name]));
    
        if k == 1
            PC = cell2mat(PC_table(:,3:end));
            WM = cell2mat(WM_table(:,3:end));
        else
            PC = PC + cell2mat(PC_table(:,3:end));
            WM = WM + cell2mat(WM_table(:,3:end));
        end
    
    end
    PC = PC/length(PC_path);
    WM = WM/length(WM_path);
    
    module_regions = PC_table(:,1);
    connector_matrix = zeros(size(PC,1),size(PC,2));
    
    for j = 1:size(PC,2)
    
        for module = unique(cell2mat(PC_table(:,2)))'
    
            if module == 1
                zPC = zscore(PC(cell2mat(PC_table(:,2)) == module,j));
            else
                zPC = [zPC;zscore(PC(cell2mat(PC_table(:,2)) == module,j))];
            end
    
        end
    
        hubs_idx = find(WM(:,j) > 0);
        connector_idx = hubs_idx(zPC(hubs_idx) > 0);
        provincial_idx = hubs_idx(zPC(hubs_idx) < 0);
        connector_matrix(connector_idx,j) = 1;
        provincial_matrix(provincial_idx,j) = 1;
        clear hubs_idx zPC connector_idx provincial_idx 
    
        if j == size(PC,2)
            connector_hubs_L = sum(connector_matrix(1:2:size(connector_matrix,1),:),1);
            connector_hubs_R = sum(connector_matrix(2:2:size(connector_matrix,1),:),1);
            provincial_hubs_L = sum(connector_matrix(1:2:size(provincial_matrix,1),:),1);
            provincial_hubs_R = sum(connector_matrix(2:2:size(provincial_matrix,1),:),1);
            save([resultsdir,'/','N_chubs_L.mat'],'connector_hubs_L');
            save([resultsdir,'/','N_chubs_R.mat'],'connector_hubs_R');
            save([resultsdir,'/','N_phubs_L.mat'],'connector_hubs_L');
            save([resultsdir,'/','N_phubs_R.mat'],'connector_hubs_R');
        end
    
    end
    
    disp([group{i},' - connector hubs']);
    connector_sum = sum(connector_matrix,2);
    disp(char(module_regions(find(connector_sum >= round(size(PC,2)/2)))));
    disp([group{i},' - provincial hubs']);
    provincial_sum = sum(provincial_matrix,2);
    disp(char(module_regions(find(provincial_sum >= round(size(PC,2)/2)))));
    clear PC PC_table PC_path WM WM_table WM_path k j

end
