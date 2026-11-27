clc;
clear;
close all;

fs = 1000;
t = 0:1/fs:1-1/fs;
N = length(t);
s = sin(2*pi*50*t);
x = randn(1, N);
V = filter([1 0.5], 1, x);
V = 0.5*V / std(V);
d = s + V;

M = 16;
mu = 0.01;
w = zeros(M, 1);
y = zeros(1, N);
e = d;

for n = M:N
    xn = x(n:-1:n-M+1).';
    y(n) = w.'*xn;
    e(n) = d(n) - y(n);
    w = w + mu*e(n)*xn;
end

valid = M:N;
output_power = mean(e(valid).^2);
MSE_before = mean((d(valid) - s(valid)).^2);
MSE_after = mean((e(valid) - s(valid)).^2);
fprintf('LMS filter taps = %d (order %d)\n', M, M-1);
fprintf('Step size = %.3f\n', mu);
fprintf('Noise-cancelled output power = %.6f\n', output_power);
fprintf('MSE before cancellation = %.6f\n', MSE_before);
fprintf('MSE after cancellation = %.6f\n', MSE_after);

figure;

subplot(3, 1, 1);
plot(t, s);
title('Desired Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3, 1, 2);
plot(t, d);
title('Noise-Added Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3, 1, 3);
plot(t, e);
title('Noise-Cancelled Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
