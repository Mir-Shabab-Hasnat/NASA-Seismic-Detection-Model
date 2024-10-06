function cluster_ids = group_by_clusters(mov_avg_clamped, cluster_starts, cluster_range)

    cluster_ids = zeros(size(mov_avg_clamped));
    cluster_id = 1;

    for i = 1:length(cluster_starts)
        start_idx = cluster_starts(i);
        end_idx = min(start_idx + cluster_range, length(mov_avg_clamped));
        
        cluster_ids(start_idx:end_idx) = cluster_id;
        cluster_id = cluster_id + 1;
    end
end

