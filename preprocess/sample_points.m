% points - Nx3, returns nx3
function [points] = sample_points(points, n)
    pc = pointCloud(points);
    
    if pc.Count > n % downsample
        percentage = n / pc.Count;
        pc = pcdownsample(pc, 'random',percentage);
    else %upsample
        replication_factor = ceil(n/pc.Count);
        idx = rempmat(1:pc.Count,1,replication_factor);
        pc = select(pc,idx);
    end
    points = pc.Location;
end