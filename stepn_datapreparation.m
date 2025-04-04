% 设置rawdata文件夹路径
folder_path = 'R:\qinproject\analysis20220409\gppianalysis\results\conn\rawdata';

subs=dir(fullfile(folder_path,'20*'));

for isub=1:numel(subs)
    cursub=fullfile(folder_path,subs(isub).name);

    % 获取rawdata文件夹下所有文件的信息
    files = dir(cursub);


    % 遍历文件夹中的所有文件
    for i = 1:length(files)
        % 获取文件的名字
        file_name = files(i).name;

        % 排除'.'和'..'文件夹以及anatI.nii和funI.nii
        if ~ismember(file_name, {'.', '..', 'anatI.nii', 'funI.nii','conditions.mat'})
            % 拼接文件的完整路径
            file_path = fullfile(cursub, file_name);

            % 删除文件
            delete(file_path);
            disp(['删除文件: ', file_path]);
        end
    end
end

disp('删除完成');
