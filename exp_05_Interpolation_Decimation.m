clc;
clear;
close all;

fs = 1000;
t = 0:1/fs:0.1;
x = sin(2*pi*100*t);

L = 3;
x_interp = interp(x, L);
fs_interp = L*fs;
t_interp = (0:length(x_interp)-1) / fs_interp;

M = 2;
x_dec = decimate(x_interp, M);
fs_dec = fs_interp / M;
t_dec = (0:length(x_dec)-1) / fs_dec;

x_new = resample(x, L, M);
fs_new = fs*L / M;
t_new = (0:length(x_new)-1) / fs_new;

fprintf('Original sampling frequency = %.2f Hz\n', fs);
fprintf('After interpolation: L = %d, fs = %.2f Hz\n', L, fs_interp);
fprintf('After decimation of interpolated signal: M = %d, fs = %.2f Hz\n', M, fs_dec);
fprintf('After resampling: L/M = %.2f, fs = %.2f Hz\n', L/M, fs_new);

figure;

subplot(4, 1, 1);
plot(t, x);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(4, 1, 2);
plot(t_interp, x_interp);
title('Interpolated Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(4, 1, 3);
plot(t_dec, x_dec);
title('Decimated Interpolated Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(4, 1, 4);
plot(t_new, x_new);
title('Rationally Resampled Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
