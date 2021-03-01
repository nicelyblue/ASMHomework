close, clear all;

[x, fs] = audioread('meseceva sonata.wav', [1, 44100]);
x = x.';
window = 'rectangle';
M = 201;
overlap = 25;
H = round(M*(overlap/100));
NFFT = 2048;

[S, f, t] = spectrogram(x, window, NFFT, H, M, fs);
SS = 20*log10(abs(S));

figure(1)
surf(t, f, SS)
shading interp
axis tight
view(0, 90)
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
xlabel('Vreme, s')
ylabel('Frekvencija, Hz')
title('Amplitudski spektar signala')
hcol = colorbar;
set(hcol, 'FontName', 'Times New Roman', 'FontSize', 14)
ylabel(hcol, 'Amplituda, dB')

[x_reconstructed, t_reconstructed] = inverse_spectrogram(S, window, M, H, fs);

t = (0:length(x)-1)/fs;
figure(2)
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
