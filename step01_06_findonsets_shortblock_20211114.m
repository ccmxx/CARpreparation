% this file find onsets for events in the dst experiment
% can be used both in unix and windows

% changming chen, 2021-08-27

% if isunix
%     onsetdir='/media/R/qinproject/datamostoriginal/onsets';
% elseif ispc
onsetdir='R:\qinproject\datamostoriginal\onsets';
% end
if ~exist(onsetdir,'dir')
    mkdir(onsetdir);
end
cd(onsetdir);
indexsubj=1;
indexrun=2;
indexcondition=3;
indexrunonset=0;
indextrialonset=4;
indextrialoffset=4;
headerline=0;
iseventdesign=0;
blocktrialspecified=6;  % trials per block
istrialdurationequal=1;
magnetisatuationtime=8000; % the interval between trigger offset and onset of the first trial, in ms;
trskipped=4;   % trs skipped after the trigger; attention should be paid here, when preprocessing fmri data, we skipped 4 volumes.
tr=2000;   % in ms
delimiter=',';
fid=fopen('R:\qinproject\datamostoriginal\behaviors\edata\EM\alldata_merged20211115.txt');
fformat='%f %f %s %f %f %f';
a=textscan(fid,fformat,'Delimiter',delimiter,'HeaderLines',headerline);
subjects=unique(a{indexsubj});
runs=unique(a{indexrun});


for i=1:length(subjects)
    for j=1:length(runs)
        trialscscr=find(a{indexsubj}==subjects(i) & a{indexrun}==runs(j));% find trials for current subject and current run
        if indexrunonset==0
            onsetscscr=a{indextrialonset}(trialscscr)-a{indextrialonset}(trialscscr(1))+magnetisatuationtime-trskipped*tr; % changed by Changming, 2018/09/09
        else
            onsetscscr=a{indextrialonset}(trialscscr)-a{indexrunonset}(trialscscr(1))-trskipped*tr;
        end
        % find the onset of each block
        if exist('blocktrialspecified','var')
            namesblock=a{indexcondition}(trialscscr(1:blocktrialspecified:end));
            onsetblock=onsetscscr(1:blocktrialspecified:end);
            namesunique=unique(namesblock);
            names=cell(1);
            onsets=cell(1);
            duratations=cell(1);
            for k=1:length(namesunique)
                if isnumeric(namesblock(1))
                    if namesunique(k)==11
                        names{k}='emotional';
                    elseif namesunique(k)==22
                        names{k}='neutral';
                    end
                    indextemp=find(namesblock==namesunique(k));
                    onsets{k}=onsetblock(indextemp)/tr;
                    durations{k}=repmat(round((onsetscscr(blocktrialspecified)-onsetscscr(1))/(blocktrialspecified-1)/tr*blocktrialspecified),[numel(indextemp),1]);  % changed by Changming, using '(onsetscscr(blocktrialspecified)-onsetscscr(1))/(blocktrialspecified-1)/tr*blocktrialspecified' instead of '(onsetscscr(2)-onsetscscr(1))/tr*blocktrialspecified'
                else
                    if strcmp(namesunique(k),'11')
                        names{k}='emotional';
                    elseif strcmp(namesunique(k),'22')
                        names{k}='neutral';
                    end
                    indextemp=find(strcmp(namesblock,namesunique{k}));
                    onsets{k}=onsetblock(indextemp)/tr;
                    durations{k}=repmat(round((onsetscscr(blocktrialspecified)-onsetscscr(1))/(blocktrialspecified-1)/tr*blocktrialspecified),[numel(indextemp),1]); % changed by Changming, using '(onsetscscr(blocktrialspecified)-onsetscscr(1))/(blocktrialspecified-1)/tr*blocktrialspecified' instead of '(onsetscscr(2)-onsetscscr(1))/tr*blocktrialspecified'
                end
            end
        else
        end
        onsetgenerator=[mfilename('fullpath'),'.m'];
        filename=['sub',num2str(subjects(i)),'_shortrun',num2str(runs(j))];
        save(filename,'onsets','durations','names','onsetgenerator');
    end
end
