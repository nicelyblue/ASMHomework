function [STFT, f, t] = spectrogram(x, window, NFFT, H, M, fs)
 
L = 1 + fix((length(x) - M)/H); % Broj prozora potrebnih za signal
STFT = zeros(NFFT, L); % Prealokacija zbog brzine

% Proveravanje vrste prozora koja se upotrebljava
if strcmp(window, 'rectangle')
    window = rectwin(M).';
else
    if strcmp(window, 'blackmanharris')
        window = blackmanharris(M).';
    end
end

% Racunanje STFT
for l = 0:L-1
    xw = x(1+l*H : M+l*H).*window;
    X = fft(xw, NFFT);
    STFT(:, 1+l) = X;
end

% Racunanje vremenskih i frekvencijskih osa
t = (M/2:H:M/2+(L-1)*H)/fs;
f = (0:NFFT-1)*fs/NFFT;

end

