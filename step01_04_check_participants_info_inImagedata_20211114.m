% this script found the suborder-name correspondence in the DST project
% by Changming Chen, 2021-11-15

grandir='R:\qinproject\analysis20220409\mrirawdata';
cd(grandir);
subject_date_time=cell(1);
subs=dir('20*');
for i=1:numel(subs)
    curfile=dir(fullfile(grandir,subs(i).name,'em','*.IMA'));
    curfile1=curfile(1).name;
    a=dicominfo(fullfile(grandir,subs(i).name,'em',curfile1));
    subject_date_time{i,1}=a.PatientID;
    subject_date_time{i,2}=a.SeriesDate;
    subject_date_time{i,3}=a.SeriesTime;
    subject_date_time{i,4}=a.StudyDate;
    subject_date_time{i,5}=a.StudyTime;
end
cd R:\qinproject\datamostoriginal\onsets;
xlswrite('subject_date_time_from_Imaging.xls',subject_date_time);