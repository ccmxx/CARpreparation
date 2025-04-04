clear;
pct_ev=[];
grandp='/home/changmingc/project/qinshaozheng20160802/rawdata_preparedforICAN';
cd(grandp);
load('/media/changmingc/fmri/qinlabproject/data_behavioral/Participants_information/participant_info_liudongmingexcluded.mat');
participants=b(:,3);
roi='Interaction_group_x_Emotion_56_4_48_roi';
glmpath='/home/changmingc/project/qinshaozheng20160802/GLMgroupanalysis_20170724';
for i=1:length(participants)
    spm_name =fullfile(grandp, participants{i},'fmri/EM/smoothed_spm8/24-Jul-2017_hpf128_threecontrasts/SPM.mat');
    roi_file = [glmpath,filesep,roi,'.mat'];
    % Make marsbar design object
    D = mardo(spm_name);
    % Make marsbar ROI object
    R = maroi(roi_file);
    % Fetch data into marsbar data object
    Y = get_marsy(R, D, 'mean');
    % Get contrasts from original design
    xCon = get_contrasts(D);
    % Estimate design on ROI data
    E = estimate(D, Y);
    % Put contrasts from original design back into design object
    E = set_contrasts(E, xCon);
    % Get definitions of all events in model
    [e_specs, e_names] = event_specs(E);
    n_events = size(e_specs,2);
    dur = 0;
    % Return percent signal esimate for all events in design
    for e_s = 1:n_events
        pct_ev(i,e_s) = event_signal(E,e_specs(:,e_s), dur);
    end
end
load('/media/changmingc/fmri/qinlabproject/data_behavioral/Participants_information/participant_info_liudongmingexcluded.mat');
groupresults.statistics.BOLD=pct_ev;
groupresults.allconditionnames={'EM','SM'};
groupresults.participantsnames=participants;
groupresults.groupinfo=b(:,4);
cd(glmpath);
save([glmpath,filesep,'GLM_boldpcntchange_',roi],'groupresults');