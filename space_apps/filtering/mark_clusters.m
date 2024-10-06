function cluster_peak_indices = mark_clusters(signal, threshold)
    cluster_peak_indices = [];
    i = 1;

    while i <= length(signal)
        if signal(i) ~= 0
            cluster_start_index = i;

            while i <= length(signal) && signal(i) ~= 0
                i = i + 1;
            end
            cluster_end_index = i - 1;  % Ending point of the cluster

            % Compute the sum of the cluster
            cluster_sum = sum(signal(cluster_start_index:cluster_end_index));

            % If the sum exceeds the threshold, find the peak of the cluster
            if cluster_sum > threshold
                % Find the index of the maximum value in the cluster
                [~, peak_index_in_cluster] = max(signal(cluster_start_index:cluster_end_index));
                peak_index_global = cluster_start_index + peak_index_in_cluster - 1;
                cluster_peak_indices = [cluster_peak_indices; peak_index_global];
            end
        end
        i = i + 1;
    end
end

