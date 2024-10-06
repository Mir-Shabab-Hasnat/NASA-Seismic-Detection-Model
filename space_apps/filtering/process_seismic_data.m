##function process_seismic_data(folder_path, file_name, output_folder)
##
##    input_filename = fullfile(folder_path, file_name);
##
##    data = dlmread(input_filename, ',', 1, 0);
##
##    %Sseismic signal (velocity data)
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
##    % Moving averages
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
####    % Original signal plot
####    subplot(sub_plots, 1, 1);
####    plot(t, signal);
####    title('Original Signal', 'FontSize', 10);
####    xlabel('Time (s)', 'FontSize', 8);
####    ylabel('Velocity(m/s)', 'FontSize', 8);
####
####    % Clamped signal plot
####    subplot(sub_plots, 1, 2);
####    plot(t, signal_clamped);
####    hold on;
####    title('Clamped Signal, Threshold = 1e-9', 'FontSize', 10);
####    xlabel('Time (n)', 'FontSize', 8);
####    ylabel('Velocity(m/s)', 'FontSize', 8);
####    hold off;
####
####    % Moving average and running sum plot
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
####    % Original signal with predicted clusters
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

    % Read the input file
    input_filename = fullfile(folder_path, file_name);
    
    % Open the file and read the header
    fid = fopen(input_filename, 'r');
    header = fgetl(fid);  % Read the first line (header)
    fclose(fid);
    
    % Load the seismic data, skipping the header
    data = dlmread(input_filename, ',', 1, 0);  % Read numerical data (skip the header)

    % Seismic signal (velocity data)
    signal = data(:, 3);

    % Clamping threshold for the signal
    clamp_threshold = 1e-9;
    signal_clamped = clamp_signal(signal, clamp_threshold);

    % Parameters for moving averages and cluster detection
    w = 200;  % Window size for moving average
    sum_n = 5000;  % Window size for running sum
    cluster_threshold = 4e-4;  % Threshold for cluster detection
    th = 5e-8;  % Threshold for clamping

    % Step 1: Moving averages
    mov_avg = movmean(abs(signal_clamped), w);  % First moving average
    mov_avg2 = movmean(mov_avg, w);  % Second moving average

    % Step 2: Running sum
    mov_avg3 = sum_next_n(mov_avg2, sum_n);  % Running sum

    % Step 3: Subtract weighted moving average, clamp negative values to 0
    running_sum_sub_mov_avg = mov_avg3 - (1000 .* mov_avg2);
    running_sum_sub_mov_avg(running_sum_sub_mov_avg < 0) = 0;

    % Final clamped moving average for cluster detection
    mov_avg_clamped = clamp_signal(mov_avg3 - (1000 .* mov_avg2), th);

    % Step 4: Detect clusters
    cluster_starts = mark_clusters(mov_avg_clamped, cluster_threshold);

    % Define the cluster range
    cluster_range = 10000;
    cluster_ids = group_by_clusters(mov_avg_clamped, cluster_starts, cluster_range);

    % Add the original first two columns, signal_clamped, mov_avg_clamped, and cluster_ids
    processed_data = [data(:, 1:2), signal_clamped, mov_avg_clamped, cluster_ids];

    % Only save real values of the processed data
    processed_data_real = real(processed_data);

    % Define the output directory (Filtered folder)
    if ~exist(output_folder, 'dir')
        mkdir(output_folder);
    end

    % Generate the output filename
    output_filename = fullfile(output_folder, file_name);
    
    % Define the new header
    new_header = sprintf('%s,signal_clamped,mov_avg_clamped,cluster_ids', header);

    % Save the processed data with the new header
    fid = fopen(output_filename, 'w');  % Open the file for writing
    fprintf(fid, '%s\n', new_header);  % Write the updated header
    fclose(fid);

    % Append the processed real data to the file (without overwriting the header)
    dlmwrite(output_filename, processed_data_real, '-append');

    % Display completion message
    fprintf('Processed and saved: %s\n', output_filename);
end

