clc;
clear;
close all;

N = 1024;
n = 0:N-1;
x = sin(2*pi*5*n/N) + 0.5*sin(2*pi*20*n/N);
xn = x + 0.4*randn(size(x));
[C, L] = wavedec(xn, 4, 'db4');
D1 = detcoef(C, L, 1);
sigma = median(abs(D1)) / 0.6745;
T = sigma*sqrt(2*log(N));
Cnew = C;
Cnew(L(1)+1:end) = wthresh(C(L(1)+1:end), 's', T);
xr = waverec(Cnew, L, 'db4');

MSE = mean((x - xr).^2);
SNR = 10*log10(sum(x.^2) / sum((x - xr).^2));
retained_coefficients = nnz(Cnew);
zero_percentage = 100*(1 - retained_coefficients/numel(Cnew));
coefficient_ratio = numel(Cnew) / max(retained_coefficients, 1);
fprintf('Mean Square Error (MSE) = %.6f\n', MSE);
fprintf('Signal-to-Noise Ratio (SNR) = %.6f dB\n', SNR);
fprintf('Retained coefficients = %d of %d\n', retained_coefficients, numel(Cnew));
fprintf('Zero coefficients = %.2f percent\n', zero_percentage);
fprintf('Coefficient-count ratio = %.2f:1\n', coefficient_ratio);

figure;

subplot(3, 1, 1);
plot(n, x);
title('Original Signal');
xlabel('Samples');
ylabel('Amplitude');
grid on;
xlim([0 N-1]);

subplot(3, 1, 2);
plot(n, xn);
title('Noisy Signal');
xlabel('Samples');
ylabel('Amplitude');
grid on;
xlim([0 N-1]);

subplot(3, 1, 3);
plot(n, xr);
title('Denoised and Reconstructed Signal');
xlabel('Samples');
ylabel('Amplitude');
grid on;
xlim([0 N-1]);

figure;
plot(n, xn, 'r');
hold on;
plot(n, xr, 'b', 'LineWidth', 1.2);
title('Noisy and Denoised Signal');
legend('Noisy Signal', 'Denoised Signal');
xlabel('Samples');
ylabel('Amplitude');
xlim([0 N-1]);
grid on;
hold off;
