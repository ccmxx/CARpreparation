grandp='R:\qinproject\analysis20220409\gppianalysis\results\seevoxel\roi33voxel\groupresults\roi33LAmyg';
cd(grandp);
rois=dir('leftamyg_rightMTG_58_-44_5_ro*.mat');
rois={rois.name};
load SPM.mat;
[x1,x2]=size(SPM.xX.X);
ppiamplitude=[];


% a=[SPM.factor.levels];    number of levels in each factor

for i=1:length(rois)
    groupresults.statistics.ppi=cell(1);
    roi_file =rois{i};
    roi_obj = maroi(roi_file);
    for j=1:x2
        imgs=strvcat(SPM.xY.P(SPM.xX.X(:,j)==1));
        y = getdata(roi_obj, imgs);
        %         for m = 1:size(imgs, 1)
        %             ppiamplitude(m) = mean(y(i,:) );
        %         end
        ppiamplitude(i,j) = mean(mean(y'));
        groupresults.statistics.ppi{j}=mean(y');
    end
    groupresults.statistics.ppiconditions=cell(1);
    groupresults.statistics.ppiconditions={'DXM-EM','DXM-SM','Placebo-EM',' Placebo-SM'};
    save([grandp,filesep,rois{i},'_individual_PPIscore.mat'],'groupresults');
end

%  ROI1: Interaction_Group_x_Valence_-10_52_42_roi.mat      lSMFG: left Superior Medial Frontal Gyrus
%  ROI2: Interaction_Group_x_Valence_-26_14_-2_roi.mat      lEN: left Extra-Nuclear
%  ROI3: Interaction_Group_x_Valence_-40_44_36_roi.mat      lSFG: left suoperal Frtonal Gyrus
%  ROI4: Interaction_Group_x_Valence_38_40_12_roi.mat       rIFG: right Inferior Frontal Gyrus
%  ROI5: Interaction_Group_x_Valence_46_-66_24_roi.mat      rMTG: right Middle Temporal Gyrus
%  ROI6: Interaction_Group_x_Valence_4_-38_30_roi.mat      PCC: bilateral PCC

% SPM.xY.P    the condition vector

maxvalue=max(ppiamplitude(:));
[x,y]=find(ppiamplitude'==maxvalue);
[~,index]=sortrows(ppiamplitude',y*(-1));
a=[0:2*pi/length(rois):2*pi];
figure;
lenindex=length(index);
for i=1:lenindex
    colorvalue=[1-(lenindex-i+1)/lenindex 0 (lenindex-i+1)/lenindex];
    b=ppiamplitude(:,index(i));b=[b;b(1)]';f1=polar(a,b);set(f1,'LineWidth',3,'Color',colorvalue,'Marker','*','MarkerFaceColor',colorvalue,'MarkerEdgeColor',colorvalue);   % DXM-EM
hold on;
end
legend(groupresults.statistics.ppiconditions(index));
SPM.xY.P
