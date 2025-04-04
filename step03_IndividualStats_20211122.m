% adapted for experiments with multiple sessions, by Changming CHen @20180910
% Modified by Bingsen @2017-9-23 @2018-5-12 @2018-6-15
% Check IndividualStats.m
% Modified by Changming Chen @2021-08-27 for spm8
% Written by Lei Hao
% haolpsy@gmail.com
% 2017/07/11
% revised by Changming Chen, 
% 2021/11/15
clear
% restoredefaultpath;
% %% ----------------------------------------------------------------- Set up
grandpath='R:\qinproject\analysis20220409';
myproject                        = fullfile('R:\qinproject\rawdatasortfrombackup\onsets\dst_design_longblock_correct20211114.mat'); % a structure which contains all information about the project. by Changming, 20180910
load(myproject);   % adpated by Changming, 20180910
myproject.onsetspath             = 'R:\qinproject\rawdatasortfrombackup\onsets';
myproject.headmovementfilter     ='^rp*';   % attention: ^ should not be forgetten
myproject.spm_dir                = 'D:\backup_softwares\softwares_fmri\spm12';
myproject.data_type              ='nii';  % the data type of processed images, could be either nii or img
myproject.server_path            = fullfile(grandpath,'mripreprocessed');   % the absolute path which contains all the processed participants;
myproject.stats_path             = fullfile(grandpath,'glmresults');
myproject.preprocessed_folder    = 'smoothed_spm';     % the local folder name where processed images are stored.
myproject.preppipeline           = 'swgcar';    % the pipeline used in preprossing
myproject.include_mvmnt          = 1;
myproject.repaired_stats         = 'ArtRepair';
myproject.volrepaired_folder     = 'volrepair_spm';
myproject.scriptpath             = 'D:\backup_softwares\softwares_fmri\shaozhenglabscripts\spm_scripts';
myproject.template_path          = fullfile(myproject.scriptpath,'BatchTemplates'); %Shaozheng added
addpath(myproject.scriptpath);
myproject.exp_sesslist           = 'em';
myproject.include_artrepair      = 0;
myproject.hpf                    = 256;
myproject.TR                     = 2;
myproject.unit                   = 'scans';
myproject.globalscaling          = 'Scaling';
myproject.mthresh                = 0.5;
myproject.subjectlist            = myproject.design(:,1);
myproject.stats_folder           = ['em',filesep,'stats_spm',filesep,'swcar'];
myproject.parent_folder          = '';
myproject.volrepaired_folder     = 'volrepair_spm';
myproject.repaired_stats         = 'stats_spm_VolRepair';
myproject.subjects               = myproject.design(1:end,1);   %  Check below
individualstats_ccm(myproject);
%% All Done
disp ('All Done');