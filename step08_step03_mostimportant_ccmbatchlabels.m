
function step08_step03_mostimportant_ccmbatchlabels(varargin)
clear;
effectclass='F';
xlsfile='R:\qinproject\analysis20220409\gppianalysis\results\seevoxel\ppigroupanalysis\amygdala_LB_bilateral05\main_effect_group_BLA_DXMvsPlacebo.xls';
[p1,p2,p3]=fileparts(xlsfile);

[aa,bb,cc]=xlsread(xlsfile);
load('R:\qinproject\analysis20220409\scripts\xjviewDB.mat');
newxls=cell(1);
nclusters=size(aa,1);
for icluster=1:nclusters
    cxyz=aa(icluster,12:14);
    [tmp_coor, cellstructure] = cuixuFindStructure(cxyz, DB);
    %     for ii=[5 3 2 6 1 4]
    %         if strfind('undefined', cellstructure{ii})
    %             continue;
    %         else
    %             newxls{icluster,1}=trimStructureStr(cellstructure{ii});
    %             return;
    %         end
    %     end
    newxls{icluster,1}=trimStructureStr(cellstructure{3});
    if abs(cxyz(1))<10
        newxls{icluster,2}='R/L';
    elseif cxyz(1)<-10
        newxls{icluster,2}='L';
    elseif cxyz(1)>10
        newxls{icluster,2}='R';
    end

    newxls{icluster,3}=aa(icluster,3);
    newxls{icluster,4}=aa(icluster,5);
    if strcmp(effectclass,'T')
        newxls{icluster,6}=aa(icluster,9);
    elseif strcmp(effectclass,'F')
        newxls{icluster,6}=aa(icluster,9);
    end

    newxls{icluster,7}=aa(icluster,12);
    newxls{icluster,8}=aa(icluster,13);
    newxls{icluster,9}=aa(icluster,14);
end
xlswrite(fullfile(p1,[p2,'_table.xls']),newxls);
cd(p1);
end


function [onelinestructure, cellarraystructure] = cuixuFindStructure(mni, DB)
% function [onelinestructure, cellarraystructure] = cuixuFindStructure(mni, DB)
%
% this function converts MNI coordinate to a description of brain structure
% in aal
%
%   mni: the coordinates (MNI) of some points, in mm.  It is Nx3 matrix
%   where each row is the coordinate for one point
%   LDB: the database.  This variable is available if you load
%   TDdatabase.mat
%
%   onelinestructure: description of the position, one line for each point
%   cellarraystructure: description of the position, a cell array for each point
%
%   Example:
%   cuixuFindStructure([72 -34 -2; 50 22 0], DB)
%
% Xu Cui
% 2007-11-20
%

N = size(mni, 1);
if N>1
    mni=mni';
end
N = size(mni, 1);

% round the coordinates
mni = round(mni/2) * 2;

T = [...
    2     0     0   -92
    0     2     0  -128
    0     0     2   -74
    0     0     0     1];

index = mni2cor(mni, T);

cellarraystructure = cell(N, length(DB));
onelinestructure = cell(N, 1);

for ii=1:N
    for jj=1:length(DB)
        graylevel = DB{jj}.mnilist(index(ii, 1), index(ii, 2),index(ii, 3));
        if graylevel == 0
            thelabel = 'undefined';
        else
            if jj==length(DB); tmp = ' (aal)'; else tmp = ''; end
            thelabel = [DB{jj}.anatomy{graylevel} tmp];
        end
        cellarraystructure{ii, jj} = thelabel;
        onelinestructure{ii} = [ onelinestructure{ii} ' // ' thelabel ];
    end
end
end


function coordinate = mni2cor(mni, T)
% function coordinate = mni2cor(mni, T)
% convert mni coordinate to matrix coordinate
%
% mni: a Nx3 matrix of mni coordinate
% T: (optional) transform matrix
% coordinate is the returned coordinate in matrix
%
% caution: if T is not specified, we use:
% T = ...
%     [-4     0     0    84;...
%      0     4     0  -116;...
%      0     0     4   -56;...
%      0     0     0     1];
%
% xu cui
% 2004-8-18
%

if isempty(mni)
    coordinate = [];
    return;
end

if nargin == 1
    T = ...
        [-4     0     0    84;...
        0     4     0  -116;...
        0     0     4   -56;...
        0     0     0     1];
end

coordinate = [mni(:,1) mni(:,2) mni(:,3) ones(size(mni,1),1)]*(inv(T))';
coordinate(:,4) = [];
coordinate = round(coordinate);
return;
end


function out = trimStructureStr(str)
pos = findstr('(', str);
if ~isempty(pos)
    str(pos-1:end)=[];
end
out = str;
end