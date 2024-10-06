clear;
clc;
close all;

##input_folder = '../data/lunar/data/training/data/S12_GradeA/';
input_folder = '../data/lunar/data/S12_GradeB/';

process_all_files_in_folder(input_folder);



##% Load the seismic data
##data = dlmread(input_filename, ',', 1, 0);
##
##signal = data(:, 3);  % Velocity data
##clamp_threshold = 1e-9;
##signal_clamped = clamp_signal(signal, clamp_threshold);
##
##w = 200
##mov_avg = movmean(abs(signal_clamped), w);
##mov_avg2 = movmean(mov_avg, w);
##sum_n = 5000
##mov_avg3 = sum_next_n(mov_avg2, sum_n);
##
##cluster_threshold = 5e-3;
##
##th = 5e-8;
##mov_avg_clamped = clamp_signal(mov_avg3-(1000.*mov_avg2), th);
##cluster_starts = mark_clusters(mov_avg_clamped, cluster_threshold);
##
##t = (0:length(signal_clamped)-1);
##
##sub_plots = 5
##figure;
##
##subplot(sub_plots, 1, 1);
##plot(t, signal);
##title('Original');
##xlabel('Time (s)');
##ylabel('Velocity');
##
##
##subplot(sub_plots, 1, 2);
##plot(t, signal_clamped);
##hold on;
##title('Clamped Signal, Threshold = 1e-9');
##xlabel('Time (n)');
##ylabel('Velocity');
##
##
##subplot(sub_plots, 1, 3);
##plot(t, 1000.*mov_avg2, 'b', 'DisplayName', 'Moving Average');
##hold on;
##plot(t, mov_avg3, 'r', 'DisplayName', 'Running Sum');
##title('Moving Average and Running Sum');
##xlabel('Time (n)');
##ylabel('Velocity');
##legend('show');
##hold off;
##
##subplot(sub_plots, 1, 4);
##plot(t, mov_avg_clamped);
##hold on;
##y_limits = ylim;
##for j = 1:length(cluster_starts)
##   line([cluster_starts(j), cluster_starts(j)], y_limits, 'Color', 'r', 'LineWidth', 1);  % Vertical red line
##end
##hold off;
##title('Clamp(Running sum - Moving average), threshold = 5e-8, showing prediction');
##xlabel('Time (n)');
##ylabel('Velocity');
##
##subplot(sub_plots, 1, 5);
##plot(t, signal);
##hold on;
##y_limits = ylim;
##for j = 1:length(cluster_starts)
##   line([cluster_starts(j), cluster_starts(j)], y_limits, 'Color', 'r', 'LineWidth', 1);  % Vertical red line
##end
##hold off;
##title('Original (with prediction)');
##xlabel('Time (n)');
##ylabel('Velocity');
##
##annotation('textbox', [0.5, 0.98, 0, 0], 'String', ['File: ', fn], 'EdgeColor', 'none', 'HorizontalAlignment', 'center', 'FontSize', 12);

