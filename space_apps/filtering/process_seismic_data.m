##function process_seismic_data(folder_path, file_name, output_folder)
##
##    input_filename = fullfile(folder_path, file_name);
##
##    data = dlmread(input_filename, ',', 1, 0);
##
##    signal = data(:, 3);
##
##    clamp_threshold = 1e-9;
##    signal_clamped = clamp_signal(signal, clamp_threshold);
##
##    % Parameters
##    w = 200;
##    sum_n = 5000;
##    cluster_threshold = 4e-3;
##    th = 5e-8;
##
##    mov_avg = movmean(abs(signal_clamped), w);
##    mov_avg2 = movmean(mov_avg, w);
##
##    % Running sum
##    mov_avg3 = sum_next_n(mov_avg2, sum_n);
##
##    % Final clamped signal for cluster detection
##    running_sum_sub_mov_avg = mov_avg3 - (1000 .* mov_avg2);
##    running_sum_sub_mov_avg(running_sum_sub_mov_avg < 0) = 0;
##    mov_avg_clamped = clamp_signal(mov_avg3 - (1000 .* mov_avg2), th);
##
##    % Detect cluster starts
##    cluster_starts = mark_clusters(mov_avg_clamped, cluster_threshold);
##    
##    cluster_range = 10000;
##    cluster_ids = group_by_clusters(mov_avg_clamped, cluster_starts, cluster_range);
##
####    t = (0:length(signal_clamped) - 1);
####
####    sub_plots = 5;
####
####    figure('Position', [100, 100, 1200, 800]);
####
####    subplot(sub_plots, 1, 1);
####    plot(t, signal);
####    title('Original Signal', 'FontSize', 10);
####    xlabel('Time (s)', 'FontSize', 8);
####    ylabel('Velocity(m/s)', 'FontSize', 8);
####
####    subplot(sub_plots, 1, 2);
####    plot(t, signal_clamped);
####    hold on;
####    title('Clamped Signal, Threshold = 1e-9', 'FontSize', 10);
####    xlabel('Time (n)', 'FontSize', 8);
####    ylabel('Velocity(m/s)', 'FontSize', 8);
####    hold off;
####
####    subplot(sub_plots, 1, 3);
####    plot(t, 1000 .* mov_avg2, 'b', 'DisplayName', 'Moving Average');
####    hold on;
####    plot(t, mov_avg3, 'r', 'DisplayName', 'Running Sum');
####    title('Moving Average and Running Sum', 'FontSize', 10);
####    xlabel('Time (n)', 'FontSize', 8);
####    ylabel('Velocity(m/s)', 'FontSize', 8);
####    legend('Location', 'northeast', 'FontSize', 8);
####    hold off;
####
####    % Clamp(Running sum - Moving average), showing clusters
####    subplot(sub_plots, 1, 4);
####    plot(t, mov_avg_clamped);
####    hold on;
####    y_limits = ylim;
####    for j = 1:length(cluster_starts)
####        line([cluster_starts(j), cluster_starts(j)], y_limits, 'Color', 'r', 'LineWidth', 1);  % Vertical red line
####    end
####    hold off;
####    title('Clamp(Running Sum - Moving Average), Threshold = 5e-8, Showing Clusters', 'FontSize', 10);
####    xlabel('Time (n)', 'FontSize', 8);
####    ylabel('Velocity(m/s)', 'FontSize', 8);
####
####    subplot(sub_plots, 1, 5);
####    plot(t, signal);
####    hold on;
####    y_limits = ylim;
####    for j = 1:length(cluster_starts)
####        line([cluster_starts(j), cluster_starts(j)], y_limits, 'Color', 'r', 'LineWidth', 1);  % Vertical red line
####    end
####    hold off;
####    title('Original Signal with Cluster Prediction', 'FontSize', 10);
####    xlabel('Time (n)', 'FontSize', 8);
####    ylabel('Velocity(m/s)', 'FontSize', 8);
####
####    annotation('textbox', [0.5, 0.99, 0, 0], 'String', ['File: ', file_name], ...
####               'EdgeColor', 'none', 'HorizontalAlignment', 'center', 'FontSize', 12);
####
####    set(gcf, 'PaperPositionMode', 'auto');
####    subplot_adjustment = 0.05;
####    for i = 1:sub_plots
####        ax = subplot(sub_plots, 1, i);
####        pos = get(ax, 'Position');
####        pos(2) = pos(2) - subplot_adjustment;
####        set(ax, 'Position', pos);
####    end
####
####    output_filename = fullfile(output_folder, [file_name(1:end-4), '.png']);
####    saveas(gcf, output_filename);
####
####    close(gcf);
##
##end


function process_seismic_data(folder_path, file_name, output_folder)

    input_filename = fullfile(folder_path, file_name);
    
    fid = fopen(input_filename, 'r');
    header = fgetl(fid); 
    fclose(fid);
    
    data = dlmread(input_filename, ',', 1, 0);
    signal = data(:, 3);

    clamp_threshold = 1e-9;
    signal_clamped = clamp_signal(signal, clamp_threshold);

    w = 200;  
    sum_n = 5000;
    cluster_threshold = 4e-4; 
    th = 5e-8; 

    mov_avg = movmean(abs(signal_clamped), w); 
    mov_avg2 = movmean(mov_avg, w); 

    mov_avg3 = sum_next_n(mov_avg2, sum_n);  % Running sum

    running_sum_sub_mov_avg = mov_avg3 - (1000 .* mov_avg2);
    running_sum_sub_mov_avg(running_sum_sub_mov_avg < 0) = 0;

    mov_avg_clamped = clamp_signal(mov_avg3 - (1000 .* mov_avg2), th);

    cluster_starts = mark_clusters(mov_avg_clamped, cluster_threshold);

    cluster_range = 10000;
    cluster_ids = group_by_clusters(mov_avg_clamped, cluster_starts, cluster_range);

    processed_data = [data(:, 1:2), signal_clamped, mov_avg_clamped, cluster_ids];

    processed_data_real = real(processed_data);

    if ~exist(output_folder, 'dir')
        mkdir(output_folder);
    end

    output_filename = fullfile(output_folder, file_name);
    
    new_header = sprintf('%s,signal_clamped,mov_avg_clamped,cluster_ids', header);

    fid = fopen(output_filename, 'w'); 
    fprintf(fid, '%s\n', new_header);
    fclose(fid);

    dlmwrite(output_filename, processed_data_real, '-append');

    fprintf('Processed and saved: %s\n', output_filename);
end

