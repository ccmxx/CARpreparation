% Example data setup
% Data format: rows are subjects, columns are conditions
% Within-subject variable: emotion (2 levels)
% Between-subject variable: treatment (2 levels)

% Sample data (replace with actual data)
% Data matrix (subjects x conditions)
% data = [
%     5.2, 5.8; % Subject 1, emotion1 and emotion2
%     6.1, 6.5; % Subject 2, emotion1 and emotion2
%     7.0, 7.3; % Subject 3, emotion1 and emotion2
%     4.8, 5.0; % Subject 4, emotion1 and emotion2
%     % ... more subjects
% ];

clear;
grandir='R:\qinproject\analysis20220409\glmanalysis\glmgroupresults_29rois';
cd(grandir);
allrois=dir('hippocampusright_05correct_percentageofchange.mat');
nrois=numel(allrois);
allstats=struct;
for iroi=1:nrois
    filename=fullfile(grandir,allrois(iroi).name);
    load(filename);
    data=[];
    treatment=[];

    data=roiactivation.results(:,1:2);
    treatment=roiactivation.results(:,3);
    task=[1,2];

    % Reshape data for anovan
    nSubjects = size(data, 1);
    groups=unique(treatment);
    ngroup=numel(groups);
    ntask = size(data, 2);
    x1=[];
    x2=[];
    x3=[];
    y=[];
    for i=1:ngroup
        for j=1:ntask
            y=[y;data(treatment==groups(i),j)];
            x1=[x1;repmat(i,sum(treatment==groups(i),1),1)];
            x2=[x2;repmat(j,sum(treatment==groups(i),1),1)];
            x3=[x3;[1:sum(treatment==groups(i))]'];
        end
    end
    x=[x1,x2,x3];
    nestedmatrix=zeros(3);
    nestedmatrix(3,1)=1;
    randomvariable=3; % subject is random variable
    allvariables={'group','task','subid'};
    alphavalue=0.05;
    ssstylevalue=3;
    modelstr='full';
    [p,tables,stats,~]=anovan(y,x,'model',modelstr,'sstype',ssstylevalue,'alpha',alphavalue,'varnames',allvariables,'display','off','random',randomvariable,'nested',nestedmatrix);

    valideffects=find(stats.terms(:,end)~=1);
    [size1,size2]=size(tables);
    tables{1,size2+1}='\eta^{2} *';
    tables{1,size2+2}='\eta^{2}_{p} **';
    tables{1,size2+2}='df(x,y)';

    for i=1:numel(valideffects)
        indexcur=valideffects(i)+1;
        sumsqcur=tables{indexcur,2};
        sumsqagainst=tables{indexcur,10}*tables{indexcur,11};
        tables{indexcur,size2+1}=sumsqcur/tables{end,2};   %  eta sqaure
        tables{indexcur,size2+2}=sumsqcur/(sumsqcur+sumsqagainst);
        dfup=tables{indexcur,3};
        dfun=round(tables{indexcur,11});
        tables{indexcur,size2+3}=[num2str(dfup),',',num2str(dfun)];
        error{indexcur-1}=[tables{indexcur,10},dfup,dfun];
    end
    tables(:,8:size2)=[];
    tables(:,4)=[];
    tables(size1-1,:)=[];
    invalideffects=find(stats.terms(:,end)==1);
    for i=1:length(invalideffects)
        indexcur=invalideffects(i)+1;
        tables{indexcur,5}=[];
        tables{indexcur,6}=[];
    end

    allstats.tables(iroi,1)=tables{2,5}; % main effect of task,F,P, ETA SQUARE
    allstats.effectname{1}='1-3:main effect of gruop,F,P, ETA SQUARE,4-6:main effect of task,F,P, ETA SQUARE;,4-6:interaction,F,P, ETA SQUARE';
    allstats.tables(iroi,2)=tables{2,6}; % main effect of task p
    allstats.tables(iroi,3)=tables{2,7}; % main effect of task eta
    allstats.tables(iroi,4)=tables{3,5}; % main effect of emotion F
    allstats.tables(iroi,5)=tables{3,6}; % main effect of emotion p
    allstats.tables(iroi,6)=tables{3,7}; % main effect of emotion eta
    allstats.tables(iroi,7)=tables{5,5}; % main effect of emotion F
    allstats.tables(iroi,8)=tables{5,6}; % main effect of emotion p
    allstats.tables(iroi,9)=tables{5,7}; % main effect of emotion eta
    allstats.rois{iroi,1}=allrois(iroi).name;
    allstats.scriptname=mfilename('fullpath');
    save(fullfile(grandir,allrois(iroi).name),'allstats','roiactivation');
end
