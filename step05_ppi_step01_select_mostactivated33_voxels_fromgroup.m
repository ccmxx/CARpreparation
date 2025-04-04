%% for medial orbital frontal lobe
clear;
pwd1=pwd;

groupanovaresult='R:\qinproject\analysis20220409\glmanalysis\glmgroupresultsneuroimage';
% step03_individualstats_spm12_glmanalysis.m

roidirs='R:\qinproject\analysis20220409\gppianalysis\rois';

cd(roidirs);
try
    delete('MOFCaal323*_mask.nii');
end
rois=dir('MOFCaal323*.nii');

nvoxels=33;
% nvoxels=33;

voxels=[];
for iroi=1:numel(rois)
    gogogo=1;
    tempname=rois(iroi).name;
    tempname=tempname(1:end-4);
    matlabbatch=cell(1);
    matlabbatch{1}.spm.util.imcalc.input = {
        'R:\qinproject\analysis20220409\glmanalysis\glmgroupresultsneuroimage\mask.nii,1'
        % step04_2by2ANOVA_ldm_20211122_neuroimage.m
        fullfile(roidirs,[rois(iroi).name,',1']);
        };  % attention: mask.nii should go first
    matlabbatch{1}.spm.util.imcalc.output = fullfile(roidirs,[tempname,'_mask.nii']);
    matlabbatch{1}.spm.util.imcalc.outdir = {''};
    matlabbatch{1}.spm.util.imcalc.expression = '(i1.*i2)>0';
    matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{1}.spm.util.imcalc.options.mask = 0;
    matlabbatch{1}.spm.util.imcalc.options.interp = 1;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
    spm_jobman('run',matlabbatch);

    for ivoxel=nvoxels
        if gogogo==1
            cd(roidirs);
            outputdir=roidirs;

            clear a1 v1 a2 v2 c1 c2 indices d1 d;
            %     load(fullfile(cursub,'VOI_DCMmedialorbifrontal_mask_1.mat'));
            %     voxels(i,1)=size(xY.XYZmm,2);
            delete('VOI_ppi*');
            delete('ppi1*');
            v1=spm_vol(fullfile(groupanovaresult,'spmF_0013.nii'));
            a1=spm_read_vols(v1);

            v2=spm_vol(fullfile(roidirs,[tempname,'_mask.nii']));
            a2=spm_read_vols(v2);
            inputfile=v2;

            v2.fname=['roi',num2str(ivoxel),'voxels_',tempname,'_mask.nii'];

            if sum(a2(:))>=max(nvoxels)
                c1=a1.*(a2);
                max(c1(:))
                c2=a1.*(a2>0);
                max(c2(:))
                sum(a2(:))
                d=sort(c1(:),'descend');
                indices=find(c2>=d(ivoxel));
                indices=indices(1:ivoxel);
                [x,y,z]=ind2sub(size(c1),indices);

                d1=zeros(size(a2));
                for ix=1:numel(x)
                    d1(x(ix),y(ix),z(ix))=1;
                end
                cd(outputdir);
                spm_write_vol(v2,d1);
                gogogo=1;
            else
                gogogo=0;
                break;
            end


        end
    end
end
cd(roidirs);
