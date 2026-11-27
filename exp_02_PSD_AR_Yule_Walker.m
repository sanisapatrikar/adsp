clc;
clear;
close all;

Fs = 1000;
N = 1024;
t = (0:N-1) / Fs;
f1 = 100;
f2 = 250;
x = sin(2*pi*f1*t) + 0.5*sin(2*pi*f2*t) + 0.5*randn(size(t));

[Pxx_periodogram, f_periodogram] = periodogram(x, [], N, Fs);
overlap = 128;
[Pxx_welch, f_welch] = pwelch(x, hamming(256), overlap, N, Fs);

AR_order = 20;
[a, noise_variance] = aryule(x, AR_order);
f_AR = (0:N/2)' * Fs / N;
H_AR = freqz(sqrt(noise_variance), a, f_AR, Fs);
Pxx_AR = abs(H_AR).^2 / Fs;
Pxx_AR(2:end-1) = 2*Pxx_AR(2:end-1);

figure;
plot(f_periodogram, 10*log10(Pxx_periodogram), 'b', 'LineWidth', 1.2);
hold on;
plot(f_welch, 10*log10(Pxx_welch), 'r', 'LineWidth', 1.2);
plot(f_AR, 10*log10(Pxx_AR), 'k', 'LineWidth', 1.5);
grid on;
xlabel('Frequency (Hz)');
ylabel('Power Spectral Density (dB/Hz)');
title('Comparison of PSD Estimates');
legend('Periodogram', 'Welch', 'AR Model - Yule-Walker');
xlim([0 Fs/2]);
hold off;

[~, idx1] = max(Pxx_periodogram);
[~, idx2] = max(Pxx_welch);
[~, idx3] = max(Pxx_AR);
fprintf('\nPeak Frequency Results:\n');
fprintf('Periodogram = %.2f Hz\n', f_periodogram(idx1));
fprintf('Welch = %.2f Hz\n', f_welch(idx2));
fprintf('AR-Yule-Walker = %.2f Hz\n', f_AR(idx3));
fprintf('\nAR Model Order = %d\n', AR_order);
fprintf('Estimated Noise Variance = %.4f\n', noise_variance);
fprintf('\nAR Model Coefficients:\n');
disp(a);
