% load('R:\qinproject\manuscripts\Manuscripts_ccm\neuroimage\interimdecision\supplementarydata\roiactivation_bnst00.mat');
load('R:\qinproject\manuscripts\Manuscripts_ccm\neuroimage\interimdecision\supplementarydata\roiactivation_bnstbothsides00.mat','roiactivation');
a=roiactivation.a;
titlestring='BOLD activation in BNST';
% for i=1:1

validgroup=[];
figure;

facecolors={[0.93,0.69,0.13],[0.00,0.45,0.74]};
data=cell(1);
for j=1:2   % to put dxm before placebo
    rt=a(:,j);
    validgroup(:,1)=a(:,3)==1;
    validgroup(:,2)=a(:,3)==2;
    meanrt(1,j)=nanmean(rt(validgroup(:,1)>0));  % 1 for dxm
    meanrt(2,j)=nanmean(rt(validgroup(:,2)>0));  % 2 for placebo
    stdrt(1,j)=std(rt(validgroup(:,1)>0))/sqrt(sum(validgroup(:,1)>0));
    stdrt(2,j)=std(rt(validgroup(:,2)>0))/sqrt(sum(validgroup(:,2)>0));
    %         scatter(x1,linspace(j-0.2,j+0.2,sum(validgroup(:,j)>0)),rt(validgroup(:,j)>0),'LineWidth',1,'Marker','x','MarkerFaceColor','black','MarkerEdgeColor','black');
    %         hold on;
    data{1,j}=rt(validgroup(:,1)>0);   % row 1: dxm, row2:placebo
    data{2,j}=rt(validgroup(:,2)>0);   % row 1: dxm, row2:placebo
end
bar1=bar(meanrt','BarWidth',0.8);
set(bar1(1),'FaceColor',[0.93,0.69,0.13]);
set(bar1(2),'FaceColor',[0.00,0.45,0.74]);


hold on;

ngroups=2;
nbars=2;
groupwidth =min(0.8,nbars/(nbars+1.5));

for k=1:nbars
    x=(1:ngroups)-groupwidth/2+(2*k-1)*groupwidth/(2*nbars);
    for m=1:2
        s=swarmchart(ones(1,numel(data{k,m}))*x(m),data{k,m},10,'k','filled');
        % swarmchart is available from matlab2022b
        s.XJitterWidth = 0.2;
        errorbar(x(m),meanrt(m,k),stdrt(m,k),'.','color','k','LineWidth',2);
        hold on;
    end
end
hold off;

xlim([0.5,2.5]);
xticklabels({'emotion matching','shape matching'});
ylim([-0.3,0.3]);
ylabel('percentage of change');
set(gca,'FontSize',12,'FontWeight','bold');
box off
title({titlestring});
legend({'DXM','Placebo'},'EdgeColor',[1.00,1.00,1.00]);
% end


