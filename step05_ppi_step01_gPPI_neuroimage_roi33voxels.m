% Configuration file for gPPI.m
% Shaozheng Qin adapted for his poject on January 1, 2014
% Lei Hao adapted for his poject on September 12, 2017
% adapted by Changming Chen, for spm8, 2021-11-14
%=========================================================================%
clear

%% gzip swcar.nii
gzip_swcar = 0; % 1:yes or 0:no

%% Set Path
spm_dir                     = spm('dir');
script_dir                  = 'R:\qinproject\scriptsoverall\codeshaolei\network_ccm\gPPIspm12';
experimentaldesignfile      ='R:\qinproject\datamostoriginal\onsets\dst_design_shortblock_correct20211114.mat';
paralist.glmpath            = 'R:\qinproject\analysis20220409\glmanalysis\glm1stlevelneuroimage';
paralist.ppipath            = 'R:\qinproject\analysis20220409\gppianalysis\results\seevoxel\roi33voxel\1stout';
% paralist.roi_nii_folder     = 'H:\qinproject\scripts\mritemplates\amygdala_subregions';
paralist.roi_nii_folder     = 'R:\qinproject\analysis20220409\gppianalysis\rois\roi33voxels';
paralist.ROI_form           = '.nii';
% rois=dir('*lleffect_right_amygdala_eye4.nii');

paralist.individualizedroi  = 0;
%% Please specify the task to include
% set = { '1', 'task1', 'task2'} -> must exist in all sessions
% set = { '0', 'task1', 'task2'} -> does not need to exist in all sessions
paralist.tasks_to_include = {'1', 'emotional', 'neutral'};

%% Please specify the confound names
paralist.confound_names = {'R1', 'R2', 'R3', 'R4', 'R5', 'R6'};
%% make T contrast
Pcon.Contrasts(1).left     = {'emotional'};
Pcon.Contrasts(1).right    = {'none'};
Pcon.Contrasts(1).STAT     = 'T';
Pcon.Contrasts(1).Weighted = 0;
Pcon.Contrasts(1).name     = 'emotional';

Pcon.Contrasts(2).left     = {'neutral'};
Pcon.Contrasts(2).right    = {'none'};
Pcon.Contrasts(2).STAT     = 'T';
Pcon.Contrasts(2).Weighted = 0;
Pcon.Contrasts(2).name     = 'neutral';

Pcon.Contrasts(3).left     = {'emotional'};
Pcon.Contrasts(3).right    = {'neutral'};
Pcon.Contrasts(3).STAT     = 'T';
Pcon.Contrasts(3).Weighted = 0;
Pcon.Contrasts(3).name     = 'emotionvsneutral';

%% ===================================================================== %%
% Acquire Subject list
% fid = fopen (subjlist); paralist.subject_list = {}; cnt = 1;
% while ~feof (fid)
%     linedata = textscan (fgetl (fid), '%s', 'Delimiter', '\t');
%     paralist.subject_list (cnt, :) = linedata {1}; cnt = cnt+1; %#ok<*SAGROW>
% end
% fclose (fid);
load(experimentaldesignfile);
paralist.subject_list=myproject.design(1:end,1);
% paralist.subject_list=myproject.design(1,1);

roi_list = dir (fullfile (paralist.roi_nii_folder, ['roi33mofc212*', paralist.ROI_form]));
roi_list = struct2cell (roi_list);
roi_list = roi_list (1, 1:end);
roi_list = roi_list';

paralist.roi_file_list = {};
for roi_i = 1:length (roi_list)
%     for roi_i = 1
    paralist.roi_file_list {roi_i,1} = fullfile (paralist.roi_nii_folder, roi_list {roi_i, 1});
end
paralist.roi_name_list = strtok (roi_list, '.');
% addpath (genpath (spm_dir('dir')));
addpath (genpath (script_dir));
scr_gPPI_ccm(paralist,Pcon,script_dir,gzip_swcar);