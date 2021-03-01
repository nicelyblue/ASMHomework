clc; clear, close all;

matrix = load('M.txt');
s_m = size(matrix);
fs = 44100;
dt = 0.1;
overlap = 0.5;
window = 'blackmanharris';

figure(1)
surf(matrix)
hold on
imagesc(matrix)
colorbar

%%
M = round(dt*fs);
df = fs/M;
H = round(overlap * M);
prior = zeros(49, s_m(2));
matrix = [prior; matrix];
matrix(M/2, s_m(2)) = 0;
matrix(M/2+1:M, :) = flip(matrix);
phase = (pi/2)*rand(size(matrix));
phase = (cos(phase) + 1i*sin(phase))/sqrt(2);
matrix = matrix .* phase;

[x_reconstructed, t_reconstructed] = inverse_spectrogram(matrix, window, M, H, fs);

x_reconstructed = x_reconstructed / max(abs(x_reconstructed));

filename = 'rekonstrukcija_Pap_Marko.wav';
audiowrite(filename,x_reconstructed,fs);
