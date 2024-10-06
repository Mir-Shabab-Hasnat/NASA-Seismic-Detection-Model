clear
clc
close all


input_directory = '../data/lunar/data/test/data/S16_GradeA/'; 
output_directory = '../data/lunar/data/test/data/Filt_S16_GradeA/';
threshold_clamp = 1e-9;

if ~exist(output_directory, 'dir')
    mkdir(output_directory);
end

% Get CSV files in the input directory
files = dir(fullfile(input_directory, '*.csv'));

plot_count = 0;

for i = 1:length(files)
    input_filename = fullfile(input_directory, files(i).name);
    output_filename = fullfile(output_directory, files(i).name);

    fid = fopen(input_filename, 'r');
    header = fgetl(fid);
    fclose(fid);

    data = dlmread(input_filename, ',', 1, 0);

    data = real(data);

    signal = data(:, 3);  % Velocity data

    signal_clamped = clamp_signal(signal, threshold_clamp);

    data(:, 3) = signal_clamped;

    fid = fopen(output_filename, 'w');
    fprintf(fid, '%s\n', header);
    fclose(fid);

    dlmwrite(output_filename, data, '-append');

    fprintf('Processed and saved: %s\n', files(i).name);

    % Plot the first 3 signals for visual confirmation
    if plot_count < 3
        t = (0:length(signal)-1);

        figure;
        subplot(2, 1, 1);
        plot(t, signal);
        title(['Original Signal - ', files(i).name]);
        xlabel('Time (s)');
        ylabel('Amplitude');

        subplot(2, 1, 2);
        plot(t, signal_clamped);
        title(['Clamped Signal - ', files(i).name]);
        xlabel('Time (s)');
        ylabel('Amplitude');

        plot_count = plot_count + 1;
    end
end

disp('All files processed and saved.');

