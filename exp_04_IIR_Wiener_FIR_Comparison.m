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

[Pxx, f] = pwelch(x, [], [], [], Fs);
[Pdx, ~] = cpsd(d, x, [], [], [], Fs);
H = Pdx ./ max(Pxx, eps);
omega = 2*pi*f / Fs;
Nz = 4;
Np = 4;
[b_IIR, a_IIR] = invfreqz(H, omega, Nz, Np, [], 100);
assert(all(abs(roots(a_IIR)) < 1), 'The fitted IIR filter is unstable.');
y_IIR = filter(b_IIR, a_IIR, x);

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
y_FIR = filter(h, 1, x);
MSE_before = mean((d - x).^2);
MSE_IIR = mean((d - y_IIR).^2);
MSE_FIR = mean((d - y_FIR).^2);
fprintf('MSE before filtering = %.6f\n', MSE_before);
fprintf('IIR Wiener approximation MSE = %.6f\n', MSE_IIR);
fprintf('FIR Wiener MSE = %.6f\n', MSE_FIR);

figure;

subplot(4, 1, 1);
plot(t, d);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(4, 1, 2);
plot(t, x);
title('Noisy Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(4, 1, 3);
plot(t, y_IIR);
title('IIR Wiener Approximation');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(4, 1, 4);
plot(t, y_FIR);
title('FIR Wiener Filter Output');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

figure;
plot(t, d, 'LineWidth', 1.5);
hold on;
plot(t, y_IIR, 'LineWidth', 1.5);
plot(t, y_FIR, 'LineWidth', 1.2);
title('Comparison of Original, IIR and FIR Signals');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Original', 'IIR', 'FIR');
grid on;
hold off;
