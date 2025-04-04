% this file find onsets for events in the dst experiment
% can be used both in unix and windows

% changming chen, 2021-08-27
% changming chen, 2021-11-14

clear;
% if isunix
%     onsetdir='/media/R/qinproject/datamostoriginal/onsets';
% elseif ispc
behdir='I:\qinproject\dst\rawdatasortfrombackup\onsets';
% end
cd(onsetdir);
onsetfiles=dir('sub*run1.mat');
for i=1:length(onsetfiles)
    clear names;
    clear durations;
    clear onsets;
    load(onsetfiles(i).name);
    for j=1:length(names)
        if isstr(names{j}) & strcmp(names{j},'11') %#ok<*DISSTR>
            names{j}='emotional';
        elseif isstr(names{j}) & strcmp(names{j},'22')
            names{j}='neutral';
        elseif isnumeric(names{j}) & names{j}==11
            names{j}='emotional';
        elseif   isnumeric(names{j}) & names{j}==22
            names{j}='neutral';
        end
        save(onsetfiles(i).name,'onsets','durations','names');
    end
end
