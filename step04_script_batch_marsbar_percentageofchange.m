function output=step04_script_batch_marsbar_percentageofchange(varargin)
    % attention: when use writetable, please don't add full path of spm and
    % subfolders
    % but spm must be added, only add the main folder

outputdir = 'R:\qinproject\analysis20220409\glmanalysis\glmgroupresults_29rois';
outputname ='step04_percentageofchange_29rois.mat';
roi_nii_folder     = 'R:\qinproject\datamostoriginal\rois\roisneuroimage';
roi_files    = dir(fullfile(roi_nii_folder,'amygdala_right_roi.mat'));
experimentdesign   = 'R:\qinproject\datamostoriginal\onsets\dst_design_shortblock_correct20211114.mat';
load(experimentdesign);
[subs,~]           = findsubs(experimentdesign);
firstleveldir      = 'R:\qinproject\analysis20220409\glmanalysis\glm1stlevelneuroimage';
dirmarsbar  = 'D:\softwares\softwares_fmri\marsbar-0.44';
addpath(genpath(dirmarsbar));

output=struct;
output.groups=myproject.design(:,6);
tempindex=strcmp(myproject.design(:,6),'dxm');
output.groupindex=2-double(tempindex);
output.rois=roi_files;
output.roidir=roi_nii_folder;
output.percentageofchange=cell(1);
output.scriptfile=[mfilename('fullpath'),'.m'];
output.percentageofchange=cell(1);
for i=1:numel(roi_files)
    clear T;
    curoutput=struct;
    roi_file=fullfile(roi_nii_folder,roi_files(i).name);
    curoutput=extractpercentageofchange(subs,roi_file,firstleveldir);
    output.percentageofchange{i}=curoutput;

    roiactivation=struct;
    roiactivation.results=curoutput.pct_ev;
    roiactivation.subjects=curoutput.subjects;
    roiactivation.results(:,3)=output.groupindex;
    roiactivation.designfile=experimentdesign;
    roiactivation.script=mfilename("fullpath");
    roiactivation.e_names{i,1}=curoutput.e_names;
    roiactivation.spm_name{i,1}=curoutput.spm_name;

    subid=[1:66]';
    emotion=curoutput.pct_ev(:,1);
    shape=curoutput.pct_ev(:,2);
    group=output.groupindex;
    T=table(subid,emotion,shape,group);
    outputroiname=roi_files(i).name;


    writetable(T,fullfile(outputdir,strcat(outputroiname(1:end-8),'_percentageofchange.csv')),'Delimiter',',');

 
    save(fullfile(outputdir,strcat(outputroiname(1:end-8),'_percentageofchange.mat')),'roiactivation');
end
save(fullfile(outputdir,outputname),"output");
rmpath(dirmarsbar);
end

function [output]=extractpercentageofchange(subs,roi_file,firstleveldir)
output=struct;
output.subjects=subs;
output.pct_ev=[];
for i=1:numel(subs)
    spm_name    = fullfile(firstleveldir,subs{i},'SPM.mat');
    D           = mardo(spm_name);  % read in the SPM file;
    R           = maroi(roi_file); % read in the roi file;
    % Fetch data into marsbar data object
    Y           = get_marsy(R, D,'mean');  % get_marsy: get data in ROIs from images, there are several sumfunctions: 'mean','median',''eigen1', et al;
    xCon        = get_contrasts(D);  % Get contrasts from original design
    E           = estimate(D, Y);  % Estimate design on ROI data
    E           = set_contrasts(E, xCon); % Put contrasts from original design back into design object
    b           = betas(E);  % get design betas


    % 4.11 How do I extract percent signal change from my design using batch?
    % Get definitions of all events in model
    [e_specs, e_names] = event_specs(E);
    n_events           = size(e_specs, 2);
    dur                = 0;
    % Return percent signal esimate for all events in design
    for e_s = 1:n_events
        pct_ev(e_s) = event_signal(E, e_specs(:,e_s), dur);
    end
    output.pct_ev(i,:)=pct_ev;
    output.e_names{i,1}=e_names;
    output.b{i,1}=b;    
    output.spm_name{i,1}=spm_name;
end
end

function [subs,subinfos]=findsubs(experimentdesign)
% this function find generate the variable of subinfos according to experimentdesign
[~,~,tempc]=fileparts(experimentdesign);
subinfos=cell(1);
if strcmp(tempc,'.xlsx') | strcmp(tempc,'.xls')
    [~,raw]=xlsread(experimentdesign);
    raw=raw(2:end,:);
    [subs,~]=unique(raw(:,1));
elseif strcmp(tempc,'.mat')
    tempinput=load(experimentdesign);
    rawccmc=fieldnames(tempinput);
    eval(['rawccm=tempinput.',rawccmc{1}]);
    if iscell(rawccm)
        [subs,~]=unique(rawccm(:,1));
        for tempi=1:numel(subs)
            subinfos{tempi,1}{1}=subs{tempi}; % subinfos{tempi,1}{1} is a string
        end
    elseif isstruct(rawccm) & isfield(rawccm,'design')
        [subs,~]=unique(rawccm.design(:,1));
    else
        warndlg(['the variable should be of cell type in ',experimentdesign]);
        return;
    end
end
end