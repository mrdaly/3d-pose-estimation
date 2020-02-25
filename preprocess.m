%% load point clouds and labels
point_clouds = h5read('ITOP_side_test_point_cloud.h5', '/data');
real_world_coordinates = h5read('ITOP_side_test_labels.h5', '/real_world_coordinates');
is_valid = h5read('ITOP_side_test_labels.h5', '/is_valid');
visible_joints = h5read('ITOP_side_test_labels.h5', '/visible_joints');
%% transpose for matlab
point_clouds = permute(point_clouds, [3 2 1]);
real_world_coordinates = permute(real_world_coordinates, [3 2 1]);
visible_joints = visible_joints';

%% filter out invalid point clouds
point_clouds = point_clouds([is_valid],:,:);