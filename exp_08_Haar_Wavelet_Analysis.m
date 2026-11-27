clc;
clear;
close all;

N = 256;
n = 0:N-1;
x = sin(2*pi*5*n/N) + 0.5*sin(2*pi*20*n/N);
[C, L] = wavedec(x, 3, 'haar');
A3 = appcoef(C, L, 'haar', 3);
D1 = detcoef(C, L, 1);
D2 = detcoef(C, L, 2);
D3 = detcoef(C, L, 3);

figure;

subplot(5, 1, 1);
plot(n, x);
title('Original Signal');
xlabel('Sample index');
ylabel('Amplitude');
grid on;

subplot(5, 1, 2);
plot(0:length(A3)-1, A3);
title('Approximation Coefficients A3');
xlabel('Coefficient index');
ylabel('Amplitude');
grid on;

subplot(5, 1, 3);
plot(0:length(D3)-1, D3);
title('Detail Coefficients D3');
xlabel('Coefficient index');
ylabel('Amplitude');
grid on;

subplot(5, 1, 4);
plot(0:length(D2)-1, D2);
title('Detail Coefficients D2');
xlabel('Coefficient index');
ylabel('Amplitude');
grid on;

subplot(5, 1, 5);
plot(0:length(D1)-1, D1);
title('Detail Coefficients D1');
xlabel('Coefficient index');
ylabel('Amplitude');
grid on;

xr = waverec(C, L, 'haar');
figure;
plot(n, x, 'b', n, xr, 'r--');
title('Original and Reconstructed Signal');
legend('Original', 'Reconstructed');
xlabel('Samples');
ylabel('Amplitude');
grid on;
fprintf('Maximum reconstruction error = %.3e\n', max(abs(x - xr)));
