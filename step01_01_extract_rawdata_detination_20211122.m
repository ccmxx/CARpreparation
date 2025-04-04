% this script extract dcm files from .tar file, using winrar in windows, 
% or extract dcm files by 'tar -xf' in unix
% it is followed by H:\qinproject\scripts\code20210827\step01_02_findimages_eachsession.m


% by Changming Chen, first on 2021-08-26
% Chongqing Normal University
% @right reserved%
% if isunix
%     sourcedir='/media/R/qinproject/datamostoriginal/fmri';
%     targetdir='R:/qinproject/datamostoriginal/mrirawdata';
% elseif ispc

winrarpath='C:\Program Files\WinRAR';   % please specify your path for winrar,
% please note that there should be no blanks in in the path,
% if you have installed WinRar under C:\Program Files\WinRar, you
% can copy the WinRaR folder into a path with no blank like C:
sourcedir='R:\qinproject\datamostoriginal\fmri';
targetdir='R:\qinproject\analysis20220409\mrirawdata';
% end

cd(sourcedir);
allfiles=dir('20*tar.gz');
allfiles={allfiles.name};
if ~exist(targetdir,'dir')
    mkdir(targetdir);
end
cd(winrarpath);
for i=1:length(allfiles)
    %     if isunix
    %         unix(['tar -xf ',allfiles{i},' --directory ',targetdir]);
    %     elseif ispc
    system(['WinRAR x ',fullfile(sourcedir,allfiles{i}),' ',targetdir]);   % C:\WinRAR\WinRaR chm document
    %     end

end
cd(targetdir);