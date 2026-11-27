clc;
clear;
close all;

fs = 1000;
t = 0:1/fs:1-1/fs;
x = sin(2*pi*100*t);
P = 10;
[a, PE] = lpc(x, P);
x_predicted = filter([0 -a(2:end)], 1, x);
e = x - x_predicted;
MSE = mean(e.^2);
fprintf('Prediction order = %d\n', P);
fprintf('LPC prediction error variance = %.6f\n', PE);
fprintf('Mean square error = %.6f\n', MSE);

figure;

subplot(3, 1, 1);
plot(t, x);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3, 1, 2);
plot(t, x_predicted);
title('Predicted Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3, 1, 3);
plot(t, e);
title('Prediction Error');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
xlim([0 0.01]);
