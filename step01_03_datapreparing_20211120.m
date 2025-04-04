% this script transform dicom files to nii, by dcm2nii,
% it could be used both in unix and windows
% it follows H:\qinproject\scripts\code20210827\the script step01_01_extract_rawdata_detination.m

% by Changming Chen, first on 2021-08-26
% Chongqing Normal University
% @right reserved%
% processed in spm12;  
% adpated ccm on 20211114
clear;
if isunix
    sourceparentdir='/media/qinproject/analysis20220409/mrirawdata';
    targetparentdir='/media/qinproject/dst/analysis20220409/mripreprocessedsetorigin';
    dcm2niiroot='/media/R/qinproject/scripts/scriptsoverall/mricron_lx/';
elseif ispc
    sourceparentdir='R:\qinproject\analysis20220409\mrirawdata';
    targetparentdir='R:\qinproject\analysis20220409\mripreprocessedsetorigin';
    dcm2niiroot='D:\spmtraining\packages\mricron';
end
if ~exist(targetparentdir,'dir')
    mkdir(targetparentdir);
end
cd(sourceparentdir);


a=questdlg('Which way do you like to specify your participant information?','Specify Participants Absolute Paths','from a Cell in Workspace','Load cell from a saved .Mat file','Manual Select the Folders','Manual Select the Folders');
switch a
    case 'from a Cell in Workspace'
        answer = inputdlg('Please Input the varialbe name','input variable name',2,{'a'},'on');
        eval(['SubjectList=',answer{1}]);
    case 'Load cell from a saved .Mat file'
        answer=spm_select;
        eval(['SubjectList=importdata(''',answer,''')']);
    case 'Manual Select the Folders'
        answer=spm_select(Inf,'dir','Please select the Participants Directories',{''},pwd,'.*',100);
        [size1,~]=size(answer);
        for i=1:size1
            SubjectList{i}=strtrim(answer(i,:));
        end
end
%
% %-Session list
% funcSessionList =cell(1);
% a=questdlg('Which way do you like to specify your Functional (including resting) Session information?','Specify Functional Session Folders: should not contain their absolute path','from a Cell in Workspace','Load cell from a saved .Mat file','Manual Select the Folders','Manual Specify the Folders');
% switch a
%     case 'from a Cell in Workspace'
%         answer = inputdlg('Please Input the varialbe name','input variable name for Sessions',2,{'a'},'on');
%         eval(['funcSessionList=',answer{1}]);
%     case 'Load cell from a saved .Mat file'
%         answer=spm_select(Inf,'mat','Please select the mat file storing the functional session',{''},pwd,'.*',1);
%         eval(['funcSessionList=importdata(''',answer,''')']);
%     case 'Manual Select the Folders'
%         answer=spm_select(Inf,'dir','Please select the functional folders from a representative participant',{''},pwd,'.*',100);
%         [size1,~]=size(answer);
%         for i=1:size1
%             [~,foldername]=fileparts(answer(i,:));
%             funcSessionList{i}=foldername;
%         end
% end


runnames={'anat','resting','em'};
tarnames={'mri/anat','fmri/resting/unnormalized','fmri/em/unnormalized'};
startingskipped=[0 10 4];  % this is to define the TRs skipped at the beginning of each run, for MRI (anatomy) data it should be NaN, and functional data should be 0 or more;
rtskept=[192 170 150];   % this is to define how many TRs should be kept for each run, for MRI (anatomy) data it should be NaN, and functional data should be 0 or more;
% attention: the number of elements in startingskipped, rtskept,tarnames,runnames should be equal, and correspondent.
erromatrix=cell(1);
nerr=0;
for i=1:length(SubjectList)
    temppar=SubjectList{i}(1:end);
    if strcmp(temppar(end),filesep)
        [curpath,curpart]=fileparts(temppar(1:end-1));
    else
        [curpath,curpart]=fileparts(temppar(1:end));
    end
    for jj=1:numel(runnames)
        sourcedir=fullfile(curpath,curpart,runnames{jj});
        cd(sourcedir);
        try
            delete('*.hdr');
            delete('*.img');
            delete('*.nii');
            delete('*.nii.gz');
        catch
        end
        outdir=fullfile(targetparentdir,curpart,tarnames{jj});
        if exist(outdir,'dir')
            rmdir(outdir,'s');
            mkdir(outdir);
        else
            mkdir(outdir);
        end
        tempallimas=dir('*.IMA');
        
        if startingskipped(jj)~=0 && numel(tempallimas)==startingskipped(jj)+rtskept(jj)
            for tempi=1:startingskipped(jj)
                delete(tempallimas(tempi).name);
            end
        end
        tempallimas=dir('*.IMA');
        if numel(tempallimas)==rtskept(jj)
            if isunix
                unix([dcm2niiroot,'dcm2nii -a y -g N -4 y -n y -o ',outdir,' ','*.IMA']);
            elseif ispc
                cd(dcm2niiroot);
                system(['dcm2nii -a y -g N -4 y -n y -o ',outdir,' ',sourcedir]);
                % -k 4: skip initial 4 volumes, but it doesn't work in dcm2nii
                % -a y: anomymize(y), not anonymize(N)
                % -n:y output as nii file, N
            end
            cd(outdir);
            if jj==1
                file=dir('c*.nii');
                file=file(1).name;
            elseif jj~=1
                file=dir('*.nii');
                file=file(1).name;
            end
            movefile(file,'I.nii');
        else
            warndlg(['The number of IMA files is not right in ',sourcedir]);
            return;
        end
    end
end
display('==================');
display('====== DONE! ======');
display('==================');