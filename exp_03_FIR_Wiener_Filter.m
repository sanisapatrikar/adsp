clc;
clear;
close all;

Fs = 1000;
N = 1000;
t = (0:N-1) / Fs;
f1 = 50;
f2 = 120;
d = sin(2*pi*f1*t) + 0.5*sin(2*pi*f2*t);
rng(1);
noise = 0.5*randn(1, N);
x = d + noise;

M = 20;
L = M + 1;
rxx_full = xcorr(x, M, 'biased');
rxx = rxx_full(M+1:end);
rxx = rxx(:);
rdx_full = xcorr(d, x, M, 'biased');
rdx = rdx_full(M+1:end);
rdx = rdx(:);
R = toeplitz(rxx);
h = R \ rdx;

disp('FIR Wiener filter coefficients:');
disp(h);
y = filter(h, 1, x);
MSE_before = mean((d - x).^2);
MSE_after = mean((d - y).^2);
fprintf('\nMSE before filtering = %.4f\n', MSE_before);
fprintf('MSE after filtering = %.4f\n', MSE_after);

figure(1);

subplot(3, 1, 1);
plot(t, d);
title('Original Signal (Clean Signal)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3, 1, 2);
plot(t, x);
title('Corrupted Signal with Gaussian Noise');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3, 1, 3);
plot(t, y);
title('FIR Wiener Filter Output');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

figure(2);
plot(t, d);
hold on;
plot(t, y);
xlabel('Time (s)');
ylabel('Amplitude');
title('Clean Signal vs Wiener Filter Output');
legend('Clean Signal', 'Filtered Signal');
grid on;
hold off;
