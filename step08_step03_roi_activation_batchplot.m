sourcedir='R:\qinproject\analysis20220409\ppiNIvariousvoxels\group\hippocampus_whole_16voxels_mask';
cd(sourcedir);
experimentdesign   = 'R:\qinproject\datamostoriginal\onsets\dst_design_shortblock_correct20211114.mat';
load(experimentdesign);

tempindex=strcmp(myproject.design(:,6),'dxm');
output.groupindex=2-double(tempindex);
rois={'hippocampus_whole_interaction_-32_36_25_roi.mat_individual_PPIscore.mat'};
for iroi=1:numel(rois)
    files=dir(fullfile(sourcedir,rois{iroi}));
    facecolors={[0.93,0.69,0.13],[0.00,0.45,0.74] };
    groupcol=3;
    rtdatacols=[1:2];
    nfontsize=16;

    grouplabels={'DXM','placebo'};
    condlabels={'emotion matching','shape matching'};


    addpath('R:\qinproject\manuscripts\Manuscripts_ccm\neuroimage\interimdecision\scripts');
    for i=1:numel(files)
        figure;
        currentfile=fullfile(sourcedir,files(i).name);
        roiname=files(i).name;
        roiname=roiname(1:end-23);
        step08_swarmplot_ppi_rois_2by2groupbar(currentfile,grouplabels,condlabels,rtdatacols,groupcol,facecolors,nfontsize,roiname);
    end

end