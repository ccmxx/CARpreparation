function step04_swarmplot_activation_rois_2by2groupbar(matfilefullname,grouplabels,condlabels,rtdatacols,groupcol,facecolors,nfontsize,roiname)
clear results meanrt stdrt ngroup groups rt validgroup icon igroup;
load(matfilefullname);
% results=groupresults.statistics.ppi;
results=roiactivation.results;

% 
% nfontsize=16;
% rtdatacols=[1:2,4,5];
% groupcol=3;
ncon=numel(rtdatacols);
% facecolors={[0.93,0.69,0.13],[0.00,0.45,0.74],[0,0,0],[0 0.5 0.5]}; % Specify a three-element vector of values between 0 and 1., must be equal to number of groups

validgroup=[];
rt=results(:,rtdatacols);   % emotion: first colum, shape:second colum,3: group

groups=unique(results(:,groupcol));
ngroup=numel(groups);
for igroup=1:ngroup
    %     validgroup(:,1)=results(:,3)==1 & rt<990 & rt>0;
    validgroup(:,igroup)=results(:,groupcol)==groups(igroup);   % dxm or placebo
    % end
end

meanrt=[];
stdrt=[];

for icon=1:ncon
    for igroup=1:ngroup
        meanrt(icon,igroup)=nanmean(rt(validgroup(:,igroup)>0,icon));  % for emotion-dxm，condition作为行，group作为列
        stdrt(icon,igroup)=std(rt(validgroup(:,igroup)>0,icon))/sqrt(sum(validgroup(:,igroup)>0,1));
    end
end

%     facecolors={[0.93,0.69,0.13],[0.00,0.45,0.74]};

b=bar(meanrt);  % 有多少行，就在x轴上留多少刻度，比如 meanrt=randn(4,2);将会在x上有4个刻度，每个刻度上两根柱子
rng('default')

absolutebarwidth= getabosultebarwidth(b,meanrt);
for igroup=1:size(meanrt,2)  % the columns are groups
    set(b(igroup),'FaceColor',facecolors{igroup},'BarWidth',0.8);

    hold on;
    xendpoints=b(igroup).XEndPoints;
    cydata=get(b(igroup),'YData');
    % errorbar1=errorbar(xendpoints,cydata,stdrt(:,k),'LineWidth',2,'LineStyle','none','color',1-facecolors{k});
    errorbar1=errorbar(xendpoints,cydata,stdrt(:,igroup),'LineWidth',2,'LineStyle','none','color','g');

    hold on;
    data=cell(1);
    for icon=1:ncon
        data{icon}=rt(validgroup(:,igroup)>0,icon);
    end

    %  ncon=size(data,2);
    for icon=1:ncon
        hold on;
        s=swarmchart(ones(1,numel(data{icon}))*xendpoints(icon),data{icon},10,'k','filled');
        % swarmchart is available from matlab2022b
        s.XJitterWidth = absolutebarwidth*0.4;
    end
end
% end

xlim([0.5,ncon+0.5]);
ylim([min(rt(:))-range(rt(:))*0.2,max(rt(:))+range(rt(:))*0.2]);
try
    roiname=strrep(roiname,'_',' ');
end
set(gca,'XTick',[1:ncon],'XTickLabel',condlabels,'FontWeight','bold','FontSize',16);
title(['BOLD activation in ',roiname],'FontSize',16);
ylabel('% change','Position',[0.6/ncon,min(ylim)+range(ylim)*0.85]);
box off;
hold on;
legend(grouplabels,'Box','off','FontSize',nfontsize-3,'Location','northeast','Orientation','vertical');
hold on;

end



function absbarwidth=getabosultebarwidth(b,data)
% Generate some data
% Get the bar width
barWidth = b.BarWidth;
% Get the x-axis limits
xLimits = xlim;

% Number of bars
numBars = length(data);

% Calculate the spacing between bars
xSpacing = diff(xLimits) / (numBars + 1);

% Calculate the absolute width of each bar
absbarwidth = barWidth * xSpacing;
end

% for i=1:4   % 1:sleep, 2 pss, 3 anxiety state,4 anxiety trait
%
%     validgroup=[];
%
%     x1=subplot(2,2,i);
%     rt=a(:,i+1);
%     validgroup(:,1)=a(:,1)==1 & rt<990 & rt>0;
%     validgroup(:,2)=a(:,1)==2 & rt<990 & rt>0;
%
%     meanrt(1)=nanmean(rt(validgroup(:,1)>0));  % 1 for dxm
%     meanrt(2)=nanmean(rt(validgroup(:,2)>0));  % 2 for placebo
%
%     stdrt(1)=std(rt(validgroup(:,1)>0))/sqrt(sum(validgroup(:,1)>0));
%     stdrt(2)=std(rt(validgroup(:,2)>0))/sqrt(sum(validgroup(:,2)>0));
%
%     for j=1:2   % to put dxm before placebo
%         bar1=bar(x1,j,meanrt(j),'BarWidth',0.5);
%         hold on;
%         errorbar(x1,j,meanrt(j),stdrt(j), 'LineStyle','-','Color','b','LineWidth',2);
%         hold on;
%         scatter(x1,linspace(j-0.2,j+0.2,sum(validgroup(:,j)>0)),rt(validgroup(:,j)>0),'LineWidth',1,'Marker','x','MarkerFaceColor','black','MarkerEdgeColor','black');
%         hold on;
%     end
%    xlim([0.5,2.5]);
%    ylim([0,max(a(:,i+1))*1.1]);
%     box off;
%     hold on;
% end
