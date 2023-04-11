%% ========================================================================
% List of open inputs
% fMRI model specification: Directory - cfg_files

clear
maindir = pwd;
datadir = [pwd,'/PWE/neuroling/derivatives/fmriprep/'];
folder = dir([datadir,'sub*']);
folder = folder([folder(:).isdir]);
addpath(genpath('/Users/victor/Documents/spm12/'));
savepath

inputs = cell(5,length(folder));

for crun = 1:length(folder)
    
    pathdata = dir([datadir,folder(crun).name,'/func/']);
    pathdata = pathdata(~ startsWith({pathdata.name},('.')));
   
    id = strfind(datadir,'/');
    inputs{1, crun} = cellstr([datadir(1:id(end) - 10),'/spm/',folder(crun).name,'/func/']);
    inputs{2, crun} = dir([pathdata(3).folder,'/','*smooth_bold.nii']);
    inputs{2, crun} = cellstr([inputs{2, crun}.folder,'/',inputs{2, crun}.name]);
    
    pathevent = dir([datadir(1:id(end) - 21),folder(crun).name,'/func/','*events.tsv']);
    event = tdfread([pathevent.folder,'/',pathevent.name]);
    
    onset_sent = double(event.onset);
    onset_sent(ismember(cellstr(event.trial_type),'syll')) = [];
    inputs{3, crun} = onset_sent;
    onset_syll = double(event.onset);
    onset_syll(ismember(cellstr(event.trial_type),'sent')) = [];
    inputs{4, crun} = onset_syll;
    
    inputs{5, crun} = cellstr([datadir(1:id(end) - 10),'/spm/',folder(crun).name,'/func/','SPM.mat']);
    
    matlabbatch = fMRI_activation_job(inputs, crun);
    spm_jobman('run', matlabbatch);
    
    close all
    clear event hReg id matlabbatch onset_sent onset_syll pathdata pathevent SPM TabDat xSPM
    
    cd(maindir)
    
end