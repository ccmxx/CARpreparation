function step03_individualstats_spm12_glmanalysis_neuroimage(varargin)
source='R:\qinproject\analysis20220409\mripreprocessed';
glm1stlevelrereestimate='R:\qinproject\DCManalysis_neuroiamge\scripts\glmfirstlevel_template.mat';
targetdir='R:\qinproject\analysis20220409\glm1stlevelneuroimage';
onsetdir='R:\qinproject\datamostoriginal\onsets';
designfile='R:\qinproject\datamostoriginal\onsets\dst_design_shortblock_correct20211114.mat';
DataTypefmri='nii';
datatyperp='.txt';
PrevPrefixfmri='swgcarI';  % must be complete
PrevPrefixrp='rp_I.txt';
tr=2;
units='scans';
load(designfile);
for i=1:size(myproject.design,1)
    cursub=fullfile(targetdir,myproject.design{i,1});
    if isfolder(cursub)
        rmdir(cursub,'s');
        mkdir(cursub);
    else
        mkdir(cursub);
    end
    FileDir=fullfile(source,myproject.design{i,1},'fmri\em\smoothed_spm');
    [InputImgFile, SelectErr] = ccm_selectfiles(FileDir, PrevPrefixfmri, DataTypefmri);
    rpfile=fullfile(FileDir,PrevPrefixrp);
    matlabbatch=cell(1);
    load(glm1stlevelrereestimate);
    matlabbatch{1}.spm.stats.fmri_spec.dir = {cursub};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = units;
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = tr;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
    %%
    matlabbatch{1}.spm.stats.fmri_spec.sess.scans = InputImgFile;
    %%
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {fullfile(onsetdir,myproject.design{i,3}{1,1})};
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {rpfile};
    matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 256;
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.5;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'emotion';
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 0];
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'shape';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [0 1];
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';    
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'emotionvsshape';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [1 -1];
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'shapevsemotion';
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.weights = [-1 1];
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{5}.fcon.name = 'eoi';
    matlabbatch{3}.spm.stats.con.consess{5}.fcon.weights = eye(2);
    matlabbatch{3}.spm.stats.con.consess{5}.fcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.delete = 0;
    save(fullfile(cursub,'matlabbatchfile.mat'),'matlabbatch');
    spm_jobman('run',matlabbatch);
    copyfile([mfilename('fullpath'),'.m'],cursub);
end
end

function [InputImgFile, SelectErr] = ccm_selectfiles(FileDir, PrevPrefix, DataType)

SelectErr = 0;

switch DataType
    case 'img'
        InputImgFile = spm_select('ExtFPList', FileDir, ['^', PrevPrefix, '.*\.img']);
    case 'nii'
        InputImgFile = spm_select('ExtFPList', FileDir, ['^', PrevPrefix, '.*\.nii']);
        V = spm_vol(InputImgFile);
        nframes = V(1).private.dat.dim(4);
        InputImgFile = spm_select('ExtFPList', FileDir, ['^', PrevPrefix, '.*\.nii'], (1:nframes));
    case 'txt'
        InputImgFile = spm_select('ExtFPList', FileDir, ['^', PrevPrefix, '.*\.txt']);
    clear V nframes;
end


InputImgFile = deblank(cellstr(InputImgFile));

if isempty(InputImgFile{1})
  SelectErr = 1;
end

end