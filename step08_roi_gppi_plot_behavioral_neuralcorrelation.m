% load neural data
clear;
format long g;
grandir='R:\qinproject\analysis20220409\gppianalysis\results\seevoxel\roi33voxel\groupresults\roi33LAmyg';
roistr='leftamyg_rightMTG_58_-44_5_roi.mat_individual_PPIscore';
matfilefullname=fullfile(grandir,[roistr,'.mat']);
load(matfilefullname);
load('R:\qinproject\analysis20220409\glmanalysis\glmgroupresults_29rois\accandrt.mat')

load('R:\qinproject\datamostoriginal\onsets\dst_design_shortblock_correct20211114.mat');

[tempdir,tempfilename,~]=fileparts(matfilefullname);
data=[];
ngroup1=numel(groupresults.statistics.ppi{1});
data(1:ngroup1,1)=groupresults.statistics.ppi{1}';
ngroup2=numel(groupresults.statistics.ppi{3});
data(ngroup1+1:ngroup1+ngroup2,1)=groupresults.statistics.ppi{3}';

data(1:ngroup1,2)=groupresults.statistics.ppi{2}';
data(ngroup1+1:ngroup1+ngroup2,2)=groupresults.statistics.ppi{4}';

data(1:ngroup1,3)=1;
data(ngroup1+1:ngroup1+ngroup2,3)=2;

nsubjects=size(data,1);
for i=1:nsubjects
    cursubname=myproject.design{i,1};
    cursuborder=find(strcmp(myproject.design(:,1),cursubname));
    cursubmat=myproject.design{cursuborder,3}{1,1};
    curmatindex=str2num(cursubmat(4:5));
    indinaccrt=find(behavioraldata.acc(:,1)==curmatindex);

    data(i,4)=behavioraldata.acc(indinaccrt,2);
    data(i,5)=behavioraldata.acc(indinaccrt,3);

    data(i,6)=behavioraldata.rt(indinaccrt,1);
    data(i,7)=behavioraldata.rt(indinaccrt,2);

    data(i,8)=behavioraldata.rt(indinaccrt,3);
    data(i,9)=data(i,1)-data(i,2);  % activation emotion - shape
    data(i,10)=data(i,4)-data(i,5);  % acc emotion - shape
    data(i,11)=data(i,7)-data(i,8);  % rt emotion - shape
end
style = {'-r','-k','-b','-.r','-.k','-.b','-or','-ok','-ob'};
save(fullfile(grandir,[roistr,'_full.mat']),'data');

% check outliers
outliers=zeros(size(data,1),1);
for icol=9:11
    tempz=zscore(data(:,icol));
    outliers=outliers(:,1)+double(abs(tempz)>3);
end
outliers=1-outliers;


% check outliers
outliers=zeros(size(data,1),1);
for icol=9:11
    tempz=zscore(data(:,icol));
    outliers=outliers(:,1)+double(abs(tempz)>3);
end
outliers=1-outliers;


%% for group 1
indgroup1=find(data(:,3)==1 & outliers==1);
indgroup2=find(data(:,3)==2 & outliers==1);
valid=find(outliers>0);
figure;
subplot1=subplot(1,2,1);
group1bold=data(indgroup1,9); % use activation as y, performance as x
group1acc=data(indgroup1,10);
group2bold=data(indgroup2,9);
group2acc=data(indgroup2,10);
lengendnames={'DXM','Placebo'};
hold on;
group1color=[237,176,33]/255;  % group 
group2color=[0,115,189]/255;
% scatter(data1,group1acc,'yellow','filled','x');
scatter1=scatter(group1bold,group1acc,'filled','x','MarkerEdgeColor',group1color,...
              'MarkerFaceColor',group1color,...
              'LineWidth',2,'DisplayName', lengendnames{1});

scatter2=scatter(group2bold,group2acc,'filled','^','MarkerEdgeColor',group2color,...
              'MarkerFaceColor',group2color,...
              'LineWidth',1.5,'DisplayName', lengendnames{2});
hold on;

[g1,S] = polyfit(group1bold, group1acc,1);
x1 = linspace(min(group1bold),max(group1bold), 100);
[f1,delta] = polyval(g1, x1,S);
[b,bint,r,rint,stats]=regress(group1acc,[ones(size(group1bold,1),1),group1bold]);    % y at first, x after
hold on;
if b(1)>0
    text(max(group1bold)-0.3*range(group1bold),max(group1acc)-0.15*range(group1acc),['y=',sprintf('%0.2f',b(2)),'*x+',sprintf('%0.2f',b(1)),...
        '    p=',sprintf('%0.2f',stats(3))],'Color',group1color,'FontSize',16,'FontName','Arial Narrow');
elseif b(1)<0
    text(max(group1bold)-0.3*range(group1bold),max(group1acc)-0.15*range(group1acc),['y=',sprintf('%0.2f',b(2)),'*x',sprintf('%0.2f',b(1)),...
        '    p=',sprintf('%0.2f',stats(3))],'Color',group1color,'FontSize',16,'FontName','Arial Narrow');
end
hold on;

% plot(x1, f1+2*delta,'k--',x1,f1-2*delta,'k--');
% hold on;
plot(x1,f1,'Color',group1color,'LineWidth',2);


% group 2
hold on;

[g1,S] = polyfit(group2bold, group2acc,1);
x1 = linspace(min(group2bold),max(group2bold), 100);
[f1,delta] = polyval(g1, x1,S);
% plot(x1, f1+2*delta,'r--',x1,f1-2*delta,'r--');
% hold on;
plot(x1,f1,'Color',group2color,'LineWidth',2);
hold on
[f1,delta] = polyval(g1, x1,S);
[b,bint,r,rint,stats]=regress(group2acc,[ones(size(group2bold,1),1),group2bold]);    % y at first, x after
hold on;
if b(1)>0
    text(max(group2bold)-0.3*range(group2bold),min(group2acc)+0.15*range(group2acc),['y=',sprintf('%0.2f',b(2)),'*x+',sprintf('%0.2f',b(1)),...
        '    p=',sprintf('%0.2f',stats(3))],'Color',group2color,'FontSize',16,'FontName','Arial Narrow');
elseif b(1)<0
    text(max(group2bold)-0.3*range(group2bold),min(group2acc)+0.15*range(group2acc),['y=',sprintf('%0.2f',b(2)),'*x',sprintf('%0.2f',b(1)),...
        '    p=',sprintf('%0.2f',stats(3))],'Color',group2color,'FontSize',16,'FontName','Arial Narrow');
end
hold on;
set(gca,'FontSize',20);
ylabel('\DeltaACC','FontSize',20);
xlabel('\Delta Connectivity','FontSize',20);
% ctick = get(gca, 'xTick');
% xticks(unique(round(ctick,3)));
ctick = get(gca, 'yTick');
yticks(unique(round(ctick,3)));
xlim([min(data(valid,9))-0.15*range(data(valid,9)),max(data(valid,9))+0.15*range(data(valid,9))]);
ylim([min(data(valid,10))-0.15*range(data(valid,10)),max(data(valid,10))+0.15*range(data(valid,10))]);
% Add legend only for scatter plots
legend1=legend([scatter1, scatter2]);
set(legend1,...
    'Position',[0.421941670908679 0.135199662794526 0.184491975143313 0.08658853926075],...
    'LineWidth',1,...
    'EdgeColor',[0 0 0]);

%% subplot 2
%% for group 1
subplot1=subplot(1,2,2);
group1rt=data(indgroup1,11);
group2rt=data(indgroup2,11);
lengendnames={'DXM','Placebo'};

group1color=[237,176,33]/255;
group2color=[0,115,189]/255;
hold on;
% scatter(data1,group1rt,'yellow','filled','x');
scatter1=scatter(group1bold,group1rt,'filled','x','MarkerEdgeColor',group1color,...
              'MarkerFaceColor',group1color,...
              'LineWidth',2,'DisplayName', lengendnames{1});
scatter2=scatter(group2bold,group2rt,'filled','^','MarkerEdgeColor',group2color,...
              'MarkerFaceColor',group2color,...
              'LineWidth',1.5,'DisplayName', lengendnames{2});

[g1,S] = polyfit(group1bold, group1rt,1);
x1 = linspace(min(group1bold),max(group1bold), 100);
[f1,delta] = polyval(g1, x1,S);
[b,bint,r,rint,stats]=regress(group1rt,[ones(size(group1bold,1),1),group1bold]);    % y at first, x after
hold on;
if b(1)>0
    text(max(group1bold)-0.3*range(group1bold),max(group1rt)-0.15*range(group1rt),['y=',sprintf('%0.2f',b(2)),'*x+',sprintf('%0.2f',b(1)),...
        '    p=',sprintf('%0.2f',stats(3))],'Color',group1color,'FontSize',16,'FontName','Arial Narrow');
elseif b(1)<0
    text(max(group1bold)-0.3*range(group1bold),max(group1rt)-0.15*range(group1rt),['y=',sprintf('%0.2f',b(2)),'*x',sprintf('%0.2f',b(1)),...
        '    p=',sprintf('%0.2f',stats(3))],'Color',group1color,'FontSize',16,'FontName','Arial Narrow');
end
hold on;

% plot(x1, f1+2*delta,'k--',x1,f1-2*delta,'k--');
% hold on;
plot(x1,f1,'Color',group1color,'LineWidth',2);


% group 2
hold on;

[g1,S] = polyfit(group2bold, group2rt,1);
x1 = linspace(min(group2bold),max(group2bold), 100);
[f1,delta] = polyval(g1, x1,S);
% plot(x1, f1+2*delta,'r--',x1,f1-2*delta,'r--');
% hold on;
plot(x1,f1,'Color',group2color,'LineWidth',2);
hold on
[f1,delta] = polyval(g1, x1,S);
[b,bint,r,rint,stats]=regress(group2rt,[ones(size(group2bold,1),1),group2bold]);    % y at first, x after
hold on;
if b(1)>0
    text(max(group2bold)-0.3*range(group2bold),min(group2rt)+0.15*range(group2rt),['y=',sprintf('%0.2f',b(2)),'*x+',sprintf('%0.2f',b(1)),...
        '    p=',sprintf('%0.2f',stats(3))],'Color',group2color,'FontSize',16,'FontName','Arial Narrow');
elseif b(1)<0
    text(max(group2bold)-0.3*range(group2bold),min(group2rt)+0.15*range(group2rt),['y=',sprintf('%0.2f',b(2)),'*x',sprintf('%0.2f',b(1)),...
        '    p=',sprintf('%0.2f',stats(3))],'Color',group2color,'FontSize',16,'FontName','Arial Narrow');
end
set(gca,'FontSize',20);
ylabel('\Delta RT(ms)','FontSize',20);
xlabel('\Delta Connectivity','FontSize',20);
% ctick = get(gca, 'xTick');
% xticks(unique(round(ctick,3)));
ctick = get(gca, 'yTick');
yticks(unique(round(ctick,3)));
xlim([min(data(valid,9))-0.15*range(data(valid,9)),max(data(valid,9))+0.15*range(data(valid,9))]);
ylim([min(data(valid,11))-0.15*range(data(valid,11)),max(data(valid,11))+0.15*range(data(valid,11))]);


annotation(gcf,'textbox',...
    [0.380066774519778 0.930849792744751 0.323337670022225 0.0598052837503803],...
    'String',{roistr},...
    'FontWeight','bold',...
    'FontSize',20,...
    'FitBoxToText','off',...
    'EdgeColor','none','Interpreter', 'none');
