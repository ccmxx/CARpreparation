
grandir='R:\qinproject\analysis20220409\mripreprocessedsetorigin';
cd(grandir);
allsubs=dir('20*');
for i=1:numel(allsubs)
    cusubj=fullfile(grandir,allsubs(i).name);
    matlabbatch=cell(1);
    file1s=dir(fullfile(cusubj,'mri\anat\201*nii'));
    file1=fullfile(cusubj,'mri\anat',[file1s(1).name,',1']);
    file2s=dir(fullfile(cusubj,'mri\anat\o201*nii'));
    file2=fullfile(cusubj,'mri\anat',[file1s(1).name,',1']);


    matlabbatch{1}.spm.util.checkreg.data = {
        fullfile(cusubj,'fmri\em\unnormalized','I.nii,1');
        fullfile(cusubj,'fmri\resting\unnormalized','I.nii,1');
        file1;
        fullfile(cusubj,'mri\anat','I.nii,1');
        file2;
        };
    spm_jobman('run',matlabbatch);
    pause;
end
