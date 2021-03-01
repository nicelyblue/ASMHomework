clear, close all;

[x, fs] = audioread('flauta.wav');
x = x.';
window = 'blackmanharris';
M = 1001;
overlap = 25;
H = round(M*(overlap/100));
NFFT = 2048;

[STFT, f] = spectrogram(x, window, NFFT, H, M, fs);
S = (abs(STFT).^2)/length(x);
S = sum(S, 2);

for i=1:NFFT
   if S(i)>=0.3
       continue
   else
       S(i)=0;
   end
end

k = find(S, 10);

for i=1:NFFT
   if ismember(i, k)
       continue
   else
       STFT(i, :) = 0;
   end
end

[x_reconstructed, t_reconstructed] = inverse_spectrogram(STFT, window, M, H, fs);

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