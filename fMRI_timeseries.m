%% ========================================================================
% exctracting timeseries(ts) based on 3dmaskdump AFNI command from fMRI of controls and PWE 
% initiation of directories

clear 
project = 'fc_PPI';
group = 'controls';

maindir = pwd;
id = strfind(maindir,'/');
datadir = [maindir(1:id(end) - 6),'/Data','/fMRI','/',project,'/',group,'/neuroling','/derivatives','/fmriprep'];
maskdir = [maindir(1:id(end) - 6),'/Data','/fMRI','/',project,'/mask','/AICHA','/language_regions'];
afni_loc = '/Users/victor/abin';

folder = dir([datadir,'/','sub*']); 
folder = folder([folder(:).isdir]);
masks = dir([maskdir,'/','*.nii']);

% running the process
for crun = 1:28 %length(folder)
    
    try
     
      fmri_image = dir([datadir,'/',folder(crun).name,'/func/','*smooth_bold.nii']);
      output_folder = [maindir(1:id(end) - 6) '/Data','/fMRI','/',project,'/',group,'/neuroling',...
                                '/derivatives','/cPPI','/',folder(crun).name];
                                  
    if isfolder(output_folder) == 0    
       mkdir(output_folder);
    end
    
    cd(afni_loc);
    
    for roi = 1:length(masks)
        cmd = sprintf('3dmaskdump -noijk -mask %s %s > %s', [maskdir filesep masks(roi).name],...
                                   [datadir filesep folder(crun).name filesep 'func' filesep fmri_image.name],...
                                   [output_folder filesep 'ts.txt']);
        system(cmd);
        ts = importdata([output_folder filesep 'ts.txt']);
        
        if roi == 1
            roi_ts = mean(ts,1)';
        else
            roi_ts = [roi_ts mean(ts,1)'];
        end
        
    end
    
    % for each participant, saving ts across all rois
    if isfile([output_folder,'/','roi_ts.txt']) == 0
        
        roi_names = regexprep({masks(:).name},'.nii','')';
        writetable(array2table(roi_ts,'VariableNames',roi_names),...
                   [output_folder,'/','roi_ts.txt']);
               
        if isfile([output_folder,'/','ts.txt']) == 1
           delete([output_folder,'/','ts.txt']);
        end
        
    else
        
        roi_ts = importdata([output_folder,'/','roi_ts.txt']);
        roi_ts = roi_ts.data;
        
         if isfile([output_folder,'/','ts.txt']) == 1
            delete([output_folder,'/','ts.txt']);
         end
        
    end
    
    % writing a cell structure for cPPI
    timecourse_cell{crun,1} = roi_ts; 
    cd(maindir);
    
    catch 
        disp(['Error with ',folder(crun).name]);
    end
    
    clear roi_ts ts roi output_folder cmd fmri_image crun
end

timecourse_cell =  timecourse_cell(~ cellfun('isempty',timecourse_cell));
save([maindir(1:id(end) - 6) '/Data','/fMRI','/',project,'/',group,'/neuroling',...
                             '/derivatives','/cPPI','/timecourse_cell.mat'],'timecourse_cell');
