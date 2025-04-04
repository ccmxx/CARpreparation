% this script finds dicom files for each session of the DST experiment, 
% it could be sued both in unix and windows
% it follows H:\qinproject\scripts\code20210827\the script step01_01_extract_rawdata_detination.m

% by Changming Chen, first on 2021-08-26
% Chongqing Normal University
% @right reserved%
clear;
currentdir=mfilename('fullpath');
[currentdir,fname,~]=fileparts(currentdir);
% if isunix
%     granddir='/media/I/qinproject/dst/rawdatasortfrombackup/mrirawdata';
% elseif ispc
    granddir='R:\qinproject\analysis20220409\mrirawdata';
% end
maxnumsessions=[1 1 1];
cd(granddir);
allsubs=dir('20*');
allsubs={allsubs.name};
for indsub=1:length(allsubs)
    curdir=allsubs{indsub};
    cd([granddir,filesep,curdir]);
    filenames=dir('*.IMA');
    filenames={filenames.name}';
    res=cellfun(@(x)strrep(x, '.', '_'), filenames, 'UniformOutput', false);
    fin = cellfun(@(x)regexp(x, '_', 'split'), res, 'UniformOutput', false);
    results=cell(1);
    numofimages=[];
    for i=1:length(filenames)
        for j=1:size(fin{1},2)
            results{i,j}=fin{i,1}{1,j};
        end
    end
    cats=cell(1);
    %% find the index for session/run
    sindex=0;
    for i=1:size(fin{1},2)
        cats=unique(results(:,i));
        if numel(cats)~=1
            sessionindex=i;
            break;
        end
    end
    %% find the number of images in each run, and put them into different folders;
    numsessions=numel(cats);
    for i=1:numsessions
        indexcursession=find(strcmp(results(:,sessionindex),cats{i}));
        numiamges=[154 180 192];
        xx=[0 0 0];
        folders={'em','resting','anat'};
        for jj=1:numel(xx)
            %emotion matching
            if numel(indexcursession)==numiamges(jj)
                if exist(folders{jj},'dir')
                    xx(jj)=xx(jj)+1;
                    tfolder=[folders{jj},num2str(xx(jj))];
                    if xx(jj)+1>maxnumsessions(jj)
                        sprintf([allsubs{indsub},'     ',num2str(xx(jj)+1)]);
                    end
                else
                    tfolder=folders{jj};
                end
                mkdir(tfolder);
                cellfun(@(x)movefile(x, tfolder), filenames(indexcursession));
            end
        end
    end
    delete('*.IMA');delete('*.SR');
    cd(granddir);
end
cd(currentdir);