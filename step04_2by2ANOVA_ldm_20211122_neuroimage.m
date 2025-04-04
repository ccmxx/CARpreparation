clear;

mfilenamebb=mfilename('fullpath');
% if ispc
grandpath='R:\qinproject\analysis20220409';
% elseif isunix
%     grandpath='/media/R/qinproject/analysis20220409';
% end

outputdir=fullfile(grandpath,filesep,'glmgroupanalysisneuroimage');
if exist(outputdir,'dir')
    rmdir(outputdir,'s');
    mkdir(outputdir);
else
    mkdir(outputdir);
end
cd(outputdir);
load('R:\qinproject\datamostoriginal\onsets\dst_design_shortblock_correct20211114.mat');
experiments=find(strcmp(myproject.design(:,6),'dxm'));
controls=find(strcmp(myproject.design(:,6),'placebo'));
matlabbatch=cell(1);
spm_jobman('initcfg');

matlabbatch{1}.spm.stats.factorial_design.dir = {outputdir};
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).name = 'Group';
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).levels = 2;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).variance = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).name = 'Valence';
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).levels = 2;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).dept = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).variance = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).ancova = 0;

experimentparts=myproject.design(experiments,1);
allexpA1=cell(1);
for i=1:length(experimentparts)
    allexpA1{i,1}=fullfile('R:\qinproject\analysis20220409\glm1stlevelneuroimage',experimentparts{i,1},'con_0001.nii,1');
end
matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(1).levels = [1
    1];
matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(1).scans = allexpA1;

allexpA2=cell(1);
for i=1:length(experimentparts)
    allexpA2{i,1}=fullfile('R:\qinproject\analysis20220409\glm1stlevelneuroimage',experimentparts{i,1},'con_0002.nii,1');
end
matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(2).levels = [1
    2];
matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(2).scans = allexpA2;

controlparts=myproject.design(controls,1);
allexpB1=cell(1);
for i=1:length(controlparts)
    allexpB1{i,1}=fullfile('R:\qinproject\analysis20220409\glm1stlevelneuroimage',controlparts{i,1},'con_0001.nii,1');
end
matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(3).levels = [2
    1];
matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(3).scans = allexpB1;


allexpB2=cell(1);
for i=1:length(controlparts)
    allexpB2{i,1}=fullfile('R:\qinproject\analysis20220409\glm1stlevelneuroimage',controlparts{i,1},'con_0002.nii,1');
end
matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(4).levels = [2
    2];
matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(4).scans = allexpB2;

matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep;
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tname = 'Select SPM.mat';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).value = 'e';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).sname = 'Factorial design specification: SPM.mat File';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).src_output = substruct('.','spmmat');
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep;
matlabbatch{3}.spm.stats.con.spmmat(1).tname = 'Select SPM.mat';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).value = 'e';
matlabbatch{3}.spm.stats.con.spmmat(1).sname = 'Model estimation: SPM.mat File';
matlabbatch{3}.spm.stats.con.spmmat(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{3}.spm.stats.con.spmmat(1).src_output = substruct('.','spmmat');
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'effectofgroupdxmvsplacebo';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 1 -1 -1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'effectofgroupplacebovsdxm';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [-1 -1 1 1];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'effectoftaskemtionvsshape';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [1 -1 1 -1];
matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'effectoftaskshapevsemotion';
matlabbatch{3}.spm.stats.con.consess{4}.tcon.weights = [-1 1 -1 1];
matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{5}.fcon.name = 'alleffect';
matlabbatch{3}.spm.stats.con.consess{5}.fcon.weights = [1 0 0 0
    0 1 0 0
    0 0 1 0
    0 0 0 1];
matlabbatch{3}.spm.stats.con.delete = 0;
copyfile([mfilename('fullpath'),'.m'],outputdir);
save('matlabbatch','matlabbatch');
spm_jobman('run',matlabbatch);
