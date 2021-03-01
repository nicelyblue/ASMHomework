clear, close all;

[x, fs] = audioread('flauta.wav');
[y, ~] = audioread('meseceva sonata.wav', [1 length(x)]);
x = x.';
y = y.';
window = 'blackmanharris';
M = 1001;
overlap = 25;
H = round(M*(overlap/100));
NFFT = 2048;

[S1, f, ~] = spectrogram(x, window, NFFT, H, M, fs);
S2 = spectrogram(y, window, NFFT, H, M, fs);

magnitude = real(S1);
phase = imag(S2);

R = magnitude + 1i*phase;

[x_reconstructed, t_reconstructed] = inverse_spectrogram(R, window, M, H, fs);

t = (0:length(x)-1)/fs;
figure(1)
plot(t, x, 'b')
grid on
xlim([0 max(t)])
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
xlabel('Vreme, s')
ylabel('Amplituda signala')
title('Originalni i rekonstruisani signal')

hold on
plot(t_reconstructed, x_reconstructed, '-.r')
legend('Originalni signal', 'Rekonstruisani signal')