close, clear all;

[x, fs] = wavread('meseceva sonata.wav', [44100, 5*44100]);
x = x.';
window = 'rectangle';
M = round(0.001*fs);
overlap = 25;
H = round(M*(overlap/100));
NFFT = fs;

[S, f, t] = spectrogram(x, window, NFFT, H, M, fs);

figure(1)
surf(t, f, abs(S))
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
