clear
clc
close all

filename = '../data/lunar/data/training/data/S12_GradeA/xa.s12.00.mhz.1970-01-19HR00_evid00002.csv';
data = csvread(filename, 1, 0);
signal = data(:, 3);  % Velocity

n = length(signal);
disp(n)

start = 1
s_end = min(n, start+ 550000);
signal_segment = signal(start:s_end);

fs = 1000;        

n = length(signal_segment);
t = (0:n-1) / fs;    

signal_fft = fft(signal_segment);

f = linspace(0, fs/2, floor(n/2)+1);

low_cutoff = 200;        % Lower cutoff
high_cutoff = 300;      % Upper cutoff

filter_mask = (f >= low_cutoff) & (f <= high_cutoff);

signal_fft_filtered = signal_fft;
signal_fft_filtered(~filter_mask) = 0;

threshold = 2e-9;
filtered_signal = signal_segment;
filtered_signal(abs(signal_segment) < threshold) = 0;

% Plots
figure;

subplot(3, 1, 1);
plot(t, signal_segment);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3, 1, 2);
plot(f, abs(signal_fft(1:floor(n/2)+1)));
title('Fourier Transform');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

subplot(3, 1, 3);
plot(t, filtered_signal);

title('Filtered Signal');
xlabel('Time (s)');
ylabel('Amplitude');



clear
clc
close all

filename = '../data/lunar/data/training/data/S12_GradeA/xa.s12.00.mhz.1972-06-16HR00_evid00060.csv';
data = csvread(filename, 1, 0);
signal = data(:, 3);  % Velocity
n = length(signal);
t = (0:n-1);
disp(n);


threshold = 1e-9;
signal_clamped = signal;
signal_clamped(abs(signal) < threshold) = 0;