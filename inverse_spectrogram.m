function [x, t] = inverse_spectrogram(STFT, window, M, H, fs)

% Proveravanje vrste prozora koja se upotrebljava
if strcmp(window, 'rectangle')
    window = rectwin(M);
else
    if strcmp(window, 'blackmanharris')
        window = blackmanharris(M);
    end
end

L = size(STFT, 2); % Broj prozora u potreban za signal
xlen = M + (L-1)*H; % Ocenjivanje duzine signala u odbircima
x = zeros(1, xlen); 

xw = real(ifft(STFT)); % Inverzna Furijeova transformacija prozorovane funkcije
xw = xw(1:M, :); % Zadrzavamo samo prvih M odbiraka jer se tu nalazi signal

% Utiskivanje svakog rekonstruisanog prozorovanog signala u svoje mesto u
% konacnom signalu
for l = 1:L
    x(1+(l-1)*H : M+(l-1)*H) = x(1+(l-1)*H : M+(l-1)*H) + (xw(:, l).*window)';
end

% Racunanje vremenske ose
t = (0:xlen-1)/fs;

end


