clear, close all;

fs = 4400;
M = 1020;
t = 0:1/fs:1;
f = 880;

black_harr = blackmanharris(M).';
rect_win = rectwin(M).';

y = sin(2*pi*f*t);
y(1, 1:M) = y(1, 1:M).*black_harr;
y(1, M:end) = 0;
n = length(y);

Y = fft(y);

f = (0:n-1)*(fs/n);
x = zeros(1, length(Y));
x(1, 780:970) = Y(1, 780:970);
x(1, 3400:3600) = Y(1, 3400:3600);
z = zeros(1, length(Y));
z(1, 880) = Y(1, 880);
z(1, 3520) = Y(1, 3520);

y_reconstructed = real(ifft(x));
y_reconstructed_2 = real(ifft(z));

t = (0:length(y)-1)/fs;
figure(1)
plot(t, y, 'b')
grid on
xlim([0 max(t)])
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
xlabel('Vreme, s')
ylabel('Amplituda signala')
title('Originalni i rekonstruisani signal')

hold on
plot(t, y_reconstructed, '-.r')
legend('Originalni signal', 'Rekonstruisani signal')

figure(2)
plot(t, y, 'b')
grid on
xlim([0 max(t)])
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
xlabel('Vreme, s')
ylabel('Amplituda signala')
title('Originalni i rekonstruisani signal')

hold on
plot(t, y_reconstructed_2, '-.r')
legend('Originalni signal', 'Rekonstruisani signal')