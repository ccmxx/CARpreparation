% modified by Changming Chen @2018-09-12
% this is used under spm12
% Modified by Bingsen @2017-9-23 @2018-6-15
% Check
% ls -1 /brain/iCAN/home/xiongbingsen/DST/Data/201*/*DST/mri/anatomy
% ls -1 /brain/iCAN/home/xiongbingsen/DST/Data/201*/*DST/fmri/WM/unnormalized
% Unzip
% gunzip /brain/iCAN/home/xiongbingsen/DST/Data/201*/*DST/mri/anatomy/*.gz
% gunzip /brain/iCAN/home/xiongbingsen/DST/Data/201*/*DST/fmri/RS/unnormalized/*.gz

% Written by Hao (17/07/12)
% QinLab, BNU
% haolpsy@gmail.com

% second resivion:by Changming Chen @2021-11-06
clear
% restoredefaultpath

%% ------------------------------------------------------------------ Setup
preprocess  = 1;
moveexclude = 1;
spmversion=spm('version');
paralist.EntirePipeLine = 'swgcar'; %'swcar'
newdata_dir = 'R:\qinproject\analysis20220409\mripreprocessed';
ServerPath = 'R:\qinproject\analysis20220409';
scripts_dir = 'D:\backup_softwares\softwares_fmri\shaozhenglabscripts\spm_scripts';
tempdir = 'D:\backup_softwares\softwares_fmri\shaozhenglabscripts\spm_scripts\BatchTemplates';
load('R:\qinproject\datamostoriginal\onsets\dst_design_shortblock_correct20211114.mat');
if strfind(spmversion,'SPM12')
    addpath(genpath('D:\backup_softwares\softwares_fmri\shaozhenglabscripts\spm12packageican_ccm'));
    spm_dir     = 'D:\backup_softwares\softwares_fmri\spm12';
end
newsub_id=myproject.design(1:end,1);
paralist.SubjectList=newsub_id;
proj_name   = 'dst';
fmri_name   = {'em'};   % {'RS';'EM';'WM';'MS';'FC'}
tr          = 2;
slice_order = [1:2:33 2:2:32];
t1_filter   = 'I';
func_filter = 'I';
data_type   = 'nii';
bbox=[-90 -126 -72; 90 90 108];
voxelsize=[3 3 3];
fwhmccm=[6 6 6];

paralist.InputFuncImgPrefix = '';
paralist.SPGRSubjectList = '';
paralist.OutputFolder = 'smoothed_spm';
paralist.SPGRFolder = 'anat';

%% ------------------------------------------------------------- Preprocess
% SliceTiming = 'a > ar'; Realign = 'r > c'; Normalise = 'w'; Smooth = 's'.
addpath(spm_dir);
addpath(genpath(scripts_dir));
if preprocess == 1
    if strfind(spmversion,'SPM12')        
        paralist.ServerPath = newdata_dir;
        paralist.TemplatePath =tempdir;
        paralist.funcSessionList=fmri_name;
        paralist.sliceorder=slice_order;
        paralist.TR=tr;
        paralist.DataType =data_type;
        paralist.SPGRFileName = func_filter;
        paralist.voxelsize=voxelsize;
        paralist.SmoothWidth  = fwhmccm;
        paralist.BoundingBoxDim = bbox;
        preprocessfmri(paralist);
    end
end

%% ------------------------------------------------------------------- Done
cd (scripts_dir)
disp ('All Done');