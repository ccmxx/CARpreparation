% this script checks if participant name in the behavioral record matches
% that in the MRI data
% can be used both in unix and windows
% attention: the group label in previous dst_experimentaldesign.mat seems wrong


% changming chen, 2021-08-27
clear;
% if isunix
%     behdir='/media/R/qinproject/datamostoriginal/Participants_information';
% elseif ispc
behdir='R:\qinproject\datamostoriginal\Participants_information';
% end
cd(behdir);
[~,txt,raw]=xlsread('DST_Experiment_all66participants_grouping_ccm.xlsx','MRIEXP','A2:E76');
load dst_experimentaldesign_20210827.mat;
for xx=1:length(myproject.design(:,1))
    subname=myproject.design{xx,1};
    a=regexp(subname,'_','split');
    b=a{end};
    indx=find(strcmp(raw(:,4),b));
    onsetorder1=raw{indx,1};
    onsetorder1=onsetorder1(2:end);
    onsetorder2=myproject.design{xx,3};
    if isempty(strfind(onsetorder2,onsetorder1))
        xx
    end
end



[~,txt,raw]=xlsread('DST_Experiment_all66participants_grouping_ccm.xlsx','MRIEXP','A2:E76');
load dst_experimentaldesign_20210827.mat;
for xx=1:length(myproject.design(:,1))
    subname=myproject.design{xx,1};
    a=regexp(subname,'_','split');
    b=a{end};
    indx=find(strcmp(raw(:,4),b));
    group1=raw{indx,3};
    if strcmp(group1,'placebo')
        group1='placebo';
    else
        group1='dxm';
    end
    group2=myproject.design{xx,6};
    if ~strcmp(group1,group2)
        warndlg('Group label does not match!');
        xx
    end    
end