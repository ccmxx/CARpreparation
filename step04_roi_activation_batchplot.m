clear;
experimentdesign   = 'R:\qinproject\datamostoriginal\onsets\dst_design_shortblock_correct20211114.mat';
load(experimentdesign);

tempindex=strcmp(myproject.design(:,6),'dxm');
output.groupindex=2-double(tempindex);
rois={'hippocampusleft_05correct_percentageofchange.mat',...
    'hippocampusright_05correct_percentageofchange.mat'};
resultsdir='R:\qinproject\analysis20220409\glmanalysis\glmgroupresults_29rois';
for iroi=1:numel(rois)
    files=dir(fullfile(resultsdir,rois{iroi}));
    facecolors={[0.93,0.69,0.13],[0.00,0.45,0.74] };
    groupcol=3;
    rtdatacols=[1:2];
    nfontsize=16;

    grouplabels={'DXM','placebo'};
    condlabels={'emotion matching','shape matching'};


    addpath('R:\qinproject\manuscripts\Manuscripts_ccm\neuroimage\interimdecision\scripts');
    for i=1:numel(files)
        figure;
        currentfile=fullfile(resultsdir,files(i).name);
        roiname=files(i).name;
        roiname=roiname(1:end-23);
        step04_swarmplot_activation_rois_2by2groupbar(currentfile,grouplabels,condlabels,rtdatacols,groupcol,facecolors,nfontsize,roiname);
    end

end