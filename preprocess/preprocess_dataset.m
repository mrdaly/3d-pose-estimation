%add ubc3v root dir to path
addpath('~/Programming/deepLearning/ubc3v-master');
init;
config;
map_file=load('mapper.mat');
mapper = map_file.mapper;
clear map_file

data_directory = '../data/';

% dataset gives more body part locations than we want, create mask to
% extract ones we care about
pose_mask = [ 1 %head
              2 %neck
              7 %rhip
              8 %rknee
              9 %rfoot
              10 %lhip
              11 %lknee
              12 %lfoot
              13 %rshoulder
              14 %relbow
              15 %rhand
              16 %lshoulder
              17 %lelbow
              18]; %lhand
pose_mask = pose_mask';
sigma = 0.1; % CONSTANT, SPREAD OF HEATMAP

file_idx = 1;
%loop through all 180 sections
for section = 1:180
    % load all 1001 frames
    instances = load_multicam('easy-pose', 'train', 1,1:1001);
    
    %loop through all frames
    for frame = 1:1001
        instance = instances(frame);
        
        %get cloud from cam1
        cloud = generate_cloud_camera( instance.Cam1, mapper );
        pc = pointCloud(cloud);
        
        %normalize point cloud
        xlim = pc.XLimits;
        ylim = pc.YLimits;
        zlim = pc.ZLimits;
        pc = pointCloud(normalize_points(pc.Location, xlim, ylim, zlim));
        
        %extract pose and normalize points (different normalization for
        %different cameras?)
        pose = get_pose(instance);
        pose = pose.joint_locations(pose_mask, :);
        pose = normalize_points(pose, xlim, ylim, zlim);
        
        %downsample cloud to fixed number of points
        pc = sample_points(pc.Location, 2048);
        %pc IS NOW ARRAY NOT POINTCLOUD
        
        %loop through joints and create heatmaps
        num_joints = size(pose,1);
        heatmaps = zeros(num_joints,1);
        for joint = 1:num_joints
            %heatmap = zeros(2048,1); %2048 IS CONSTANT!!!!!
            joint_loc = pose(joint,:);
            
            for i = 1:2048 % CONSTANT!!!!!!!!!!!!
               x = pc(i,:);
               heatmaps(joint,i) = exp(-(((norm(x-joint_loc)).^2)/(sigma^2)));
            end
        end
        
        %write to file
        example = [pc heatmaps'];
        filename = [num2str(file_idx) '.csv'];
        full_path = [data_directory filename];
        csvwrite(full_path, example);
        
        file_idx = file_idx + 1;
    end
end