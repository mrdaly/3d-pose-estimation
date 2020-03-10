% points - nx3
function [normalized_points] = normalize_points(points, xlim, ylim, zlim)
    xyzMin = [xlim(1) ylim(1) zlim(1)];
    xyzDiff = [diff(xlim) diff(ylim) diff(zlim)];
    
    normalized_points = (points - xyzMin) ./ xyzDiff;
end