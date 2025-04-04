sourcedir='R:\qinproject\analysis20220409\gppianalysis\results\seevoxel\ppigroupanalysis\amygdala_SF_bilateral';
cd(sourcedir);
experimentdesign   = 'R:\qinproject\datamostoriginal\onsets\dst_design_shortblock_correct20211114.mat';
load(experimentdesign);

tempindex=strcmp(myproject.design(:,6),'dxm');
output.groupindex=2-double(tempindex);
rois=dir(fullfile(sourcedir,'interaction*individual_PPIscore.mat'));
rois={rois.name};
for iroi=1:numel(rois)
    files=dir(fullfile(sourcedir,rois{iroi}));
    facecolors={[0.93,0.69,0.13],[0.00,0.45,0.74] };
    groupcol=3;
    rtdatacols=[1:2];
    nfontsize=16;

    grouplabels={'DXM','placebo'};
    condlabels={'Emotion Matching','Emotion Matching'};


    addpath('R:\qinproject\manuscripts\Manuscripts_ccm\neuroimage\interimdecision\scripts');
    for i=1:numel(files)
        figure;
        currentfile=fullfile(sourcedir,files(i).name);
        roiname=files(i).name;
        roiname=roiname(1:end-23);
        step08_swarmplot_ppi_rois_2by2groupbar(currentfile,grouplabels,condlabels,rtdatacols,groupcol,facecolors,nfontsize,roiname);
    end

end