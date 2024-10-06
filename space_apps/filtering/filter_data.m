clear
clc
close all

##% Load the seismic data from a CSV file
##filename = '../data/lunar/data/training/data/S12_GradeA/xa.s12.00.mhz.1972-06-16HR00_evid00060.csv';
##data = csvread(filename, 1, 0);
##signal = data(:, 3);  % Velocity
##n = length(signal);
##t = (0:n-1);
##disp(n);
##
##
##threshold = 1e-9;
##signal_clamped = signal;
##signal_clamped(abs(signal) < threshold) = 0;

% Parameters
input_directory = '../data/lunar/data/training/data/S12_GradeA/';  % Input directory
output_directory = '../data/lunar/data/training/data/Processed/';  % Output directory
threshold_clamp = 1e-9;  % Clamping threshold

% Create output directory if it doesn't exist
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

