% this script checks headmovement
% changming chen,2021-11-16
clear;
grandpath='R:\qinproject\analysis20220409';
load(fullfile('R:\qinproject\datamostoriginal','onsets','dst_design_shortblock_correct20211114.mat'));
movementmax=cell(1);
subject_list =myproject.design(:,1);
headmovements=[];
for i=1:length(subject_list)
    cd(fullfile(grandpath,'mripreprocessed',subject_list{i},'fmri','em','smoothed_spm'));
    a=load('rp_I.txt');
    movementmax{i,1}=subject_list{i};
    movementmax(i,2:7)=num2cell(max(a),[1,6]);
    headmovements(i,1:6)=max(a);
    if any(max(a)>=2)
        display(strcat(subject_list{i},' has extrem headmovement'));
        figure;
        plot(a);
    end
end
figure;
plot(headmovements);
