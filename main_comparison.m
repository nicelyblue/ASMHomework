clear all;
close all;
clc;

fs = 44100;
window_length = 2048;
n_overlap = 1024;
nfft = 44100;
df = fs/nfft;
n_subranges = 1200;

%% Loading, normalizing and synchronising signals
x_1 = audioread('Sound 1.wav');
x_2 = audioread('Sound 2.wav');
x_3 = audioread('Sound 3.wav');
x_4 = audioread('Sound 4.wav');

x_1 = x_1/max(abs(x_1));
x_2 = x_2/max(abs(x_2));
x_3 = x_3/max(abs(x_3));
x_4 = x_4/max(abs(x_4));

figure
plot(x_1)
hold on
plot(x_2)
plot(x_3)
plot(x_4)
hold off

[x1, x2] = alignsignals(x_1, x_2,[],'truncate');
[x2, x3] = alignsignals(x_2, x_3,[],'truncate');
[x3, x4] = alignsignals(x_3, x_4,[],'truncate');
[x4, x1] = alignsignals(x_4, x_1,[],'truncate');

figure
plot(x1)
hold on
plot(x2)
plot(x3)
plot(x4)
hold off

%% Calculating spectrogram
X1 = spectrogram(x1, hamming(window_length), round(n_overlap), nfft, fs);
X2 = spectrogram(x2, hamming(window_length), round(n_overlap), nfft, fs);
X3 = spectrogram(x3, hamming(window_length), round(n_overlap), nfft, fs);
X4 = spectrogram(x4, hamming(window_length), round(n_overlap), nfft, fs);

X1 = abs(X1);
X2 = abs(X2);
X3 = abs(X3);
X4 = abs(X4);

%% Creating chroma matrix
NSpec = nfft/2 + 1;
C = zeros(n_subranges, NSpec);
C0 = 16.35;
f_max = fs/2;
tones = C0 * 2.^((0:n_subranges-1)./n_subranges);

for i = 1 : length(tones)
    row = zeros(1, NSpec);
    f_base = tones(i);
    max_numb_of_octave = floor(log(f_max/f_base)/log(2));
    for octave_ind = 0 : max_numb_of_octave
        f_tone = f_base*(2^octave_ind);
        k = round (f_tone/(fs/nfft));
        bump = 0:NSpec-1;
        bump = exp(-50.*abs(log(bump/k)/log(2)));
        bump = bump/norm(bump);
        row = row + bump;
    end
    C(i, :) = row;
end

normC = C - min(C(:));
C = normC ./ max(normC(:));

%% Calculating and displaying chromagrams

chroma_x1 = C*X1;
chroma_x2 = C*X2;
chroma_x3 = C*X3;
chroma_x4 = C*X4;

chroma_x1_disp = 20*log10(chroma_x1);
chroma_x2_disp = 20*log10(chroma_x2);
chroma_x3_disp = 20*log10(chroma_x3);
chroma_x4_disp = 20*log10(chroma_x4);

y_ticks = n_subranges/12:n_subranges/12:n_subranges;

figure
imagesc(chroma_x1_disp)
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
ylabel('Hromatska skala');
set(gca,'YTick', y_ticks); 
set(gca,'YTickLabel', {'C';'C#';'D';'D#';'E';'F';'F#';'G';'G#';'A';'A#';'B'})
title('Hromatogram X1')
hcol = colorbar;
set(hcol, 'FontName', 'Times New Roman', 'FontSize', 14)
ylabel(hcol, 'Amplituda')

figure
imagesc(chroma_x2_disp)
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
ylabel('Hromatska skala');
set(gca,'YTick', y_ticks); 
set(gca,'YTickLabel', {'C';'C#';'D';'D#';'E';'F';'F#';'G';'G#';'A';'A#';'B'})
title('Hromatogram X2')
hcol = colorbar;
set(hcol, 'FontName', 'Times New Roman', 'FontSize', 14)
ylabel(hcol, 'Amplituda')

figure
imagesc(chroma_x3_disp)
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
ylabel('Hromatska skala');
set(gca,'YTick', y_ticks); 
set(gca,'YTickLabel', {'C';'C#';'D';'D#';'E';'F';'F#';'G';'G#';'A';'A#';'B'})
title('Hromatogram X3')
hcol = colorbar;
set(hcol, 'FontName', 'Times New Roman', 'FontSize', 14)
ylabel(hcol, 'Amplituda')

figure
imagesc(chroma_x4_disp)
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
ylabel('Hromatska skala');
set(gca,'YTick', y_ticks); 
set(gca,'YTickLabel', {'C';'C#';'D';'D#';'E';'F';'F#';'G';'G#';'A';'A#';'B'})
title('Hromatogram X4')
hcol = colorbar;
set(hcol, 'FontName', 'Times New Roman', 'FontSize', 14)
ylabel(hcol, 'Amplituda')

%% Creating similarity matrices, C12 == C21 ...

C12 = similarity_matrix(chroma_x1, chroma_x2);
C13 = similarity_matrix(chroma_x1, chroma_x3);
C14 = similarity_matrix(chroma_x1, chroma_x4);
C23 = similarity_matrix(chroma_x2, chroma_x3);
C24 = similarity_matrix(chroma_x2, chroma_x4);
C34 = similarity_matrix(chroma_x3, chroma_x4);

C11 = similarity_matrix(chroma_x1, chroma_x1);
C22 = similarity_matrix(chroma_x2, chroma_x2);
C33 = similarity_matrix(chroma_x3, chroma_x3);
C44 = similarity_matrix(chroma_x4, chroma_x4);

%% Plotting similarity matrices

figure
imagesc(C12)
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
title('Matrica slicnosti X1 i X2')
hcol = colorbar;
set(hcol, 'FontName', 'Times New Roman', 'FontSize', 14)

figure
imagesc(C13)
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
title('Matrica slicnosti X1 i X3')
hcol = colorbar;
set(hcol, 'FontName', 'Times New Roman', 'FontSize', 14)

figure
imagesc(C14)
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
title('Matrica slicnosti X1 i X4')
hcol = colorbar;
set(hcol, 'FontName', 'Times New Roman', 'FontSize', 14)

figure
imagesc(C23)
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
title('Matrica slicnosti X2 i X3')
hcol = colorbar;
set(hcol, 'FontName', 'Times New Roman', 'FontSize', 14)

figure
imagesc(C24)
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
title('Matrica slicnosti X2 i X4')
hcol = colorbar;
set(hcol, 'FontName', 'Times New Roman', 'FontSize', 14)

figure
imagesc(C34)
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
title('Matrica slicnosti X3 i X4')
hcol = colorbar;
set(hcol, 'FontName', 'Times New Roman', 'FontSize', 14)

figure
imagesc(C11)
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
title('Matrica samoslicnosti X1')
hcol = colorbar;
set(hcol, 'FontName', 'Times New Roman', 'FontSize', 14)

figure
imagesc(C22)
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
title('Matrica samoslicnosti X2')
hcol = colorbar;
set(hcol, 'FontName', 'Times New Roman', 'FontSize', 14)

figure
imagesc(C33)
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
title('Matrica samoslicnosti X3')
hcol = colorbar;
set(hcol, 'FontName', 'Times New Roman', 'FontSize', 14)

figure
imagesc(C44)
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
title('Matrica samoslicnosti X4')
hcol = colorbar;
set(hcol, 'FontName', 'Times New Roman', 'FontSize', 14)

%% Calculating similarities

[~, ~, D12] = dtw(C12);
[~, ~, D13] = dtw(C13);
[~, ~, D14] = dtw(C14);
[~, ~, D23] = dtw(C23);
[~, ~, D24] = dtw(C24);
[~, ~, D34] = dtw(C34);
[~, ~, D11] = dtw(C11); % Kontrolna vrednost

%% Printing maximum values

disp(max(D11(:))) % Kontrolna vrednost
disp(max(D12(:)))
disp(max(D13(:)))
disp(max(D14(:)))
disp(max(D23(:)))
disp(max(D24(:)))
disp(max(D34(:)))
