% this script changes the label of groups
% all raw data is backup in G://qinproject
% changming chen, 2021-08-27
% changming chen, 2021-11-16
% if isunix
%     onsetdir='/media/R/qinproject/datamostoriginal/onsets';
% elseif ispc
behdir='I:\qinproject\dst\rawdatasortfrombackup\onsets';
% end
cd(behdir);
load('dst_design_shortblock_correct20211114.mat');
for i=1:size(myproject.design)
    if strcmp(myproject.design{i,6},'Control')
        myproject.design{i,6}='placebo';
    elseif strcmp(myproject.design{i,6},'Experimental')
        myproject.design{i,6}='dxm';
    end
end
save('dst_design_shortblock_correct20211114.mat','myproject')