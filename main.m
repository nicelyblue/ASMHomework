clear all;
close all;
clc;

file_name = 'Akord_Cdur.wav';

x = audioread(file_name).';
x = x/max(abs(x));

window_length = 2048;
n_overlap = 1024;
nfft = 48000;
fs = 48000;
df = fs/nfft;
n_subranges = 12;

S = spectrogram(x, hamming(window_length), round(n_overlap), nfft, fs);
S = abs(S);

f = (0:df:fs/2);
t = (0: size(S,2)-1).*(window_length - n_overlap)/fs; 

figure(1)
surf(t, f, S)
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

S_reduced = zeros(size(S));
for i = 1 : size(S, 2)
    [~, locs] = findpeaks(S(:, i));
    S_reduced(locs, i) = S(locs, i);
end

figure(2)
surf(t, f, S_reduced)
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

figure(3)
%surf(f, (1:n_subranges), C)
imagesc(C)
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
ylabel('Hromatska skala');
set(gca,'YTick',1:12); 
set(gca,'YTickLabel', {'C';'C#';'D';'D#';'E';'F';'F#';'G';'G#';'A';'A#';'B'})
title('Hroma matrica')
hcol = colorbar;
set(hcol, 'FontName', 'Times New Roman', 'FontSize', 14)
ylabel(hcol, 'Amplituda')

chroma = C*S;
chroma_disp = 20*log10(chroma);
chroma_reduced = C*S_reduced;
chroma_reduced_disp = 20*log10(chroma_reduced);

figure(4)
%surf(t, (1:n_subranges), chroma_disp)
imagesc(chroma_disp)
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
ylabel('Hromatska skala');
set(gca,'YTick',1:12); 
set(gca,'YTickLabel', {'C';'C#';'D';'D#';'E';'F';'F#';'G';'G#';'A';'A#';'B'})
title('Hromatogram')
hcol = colorbar;
set(hcol, 'FontName', 'Times New Roman', 'FontSize', 14)
ylabel(hcol, 'Amplituda')

figure(5)
%surf(t, (1:n_subranges), chroma_reduced_disp)
imagesc(chroma_reduced_disp)
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
ylabel('Hromatska skala');
set(gca,'YTick',1:12); 
set(gca,'YTickLabel', {'C';'C#';'D';'D#';'E';'F';'F#';'G';'G#';'A';'A#';'B'})
title('Hromatogram sa redukovanim spektrogramom')
hcol = colorbar;
set(hcol, 'FontName', 'Times New Roman', 'FontSize', 14)
ylabel(hcol, 'Amplituda')

chroma_profile = sum(chroma(1:n_subranges,:), 2);
chroma_profile = chroma_profile/max(abs(chroma_profile));

figure(6)
bar(chroma_profile);
    set(gca,'XTickLabel', {'C';'C#';'D';'D#';'E';'F';'F#';'G';'G#';'A';'A#';'B'});
title('Hroma profil');

chroma_profile_reduced = sum(chroma_reduced(1:n_subranges,:), 2);
chroma_profile_reduced = chroma_profile_reduced/max(abs(chroma_profile_reduced));

figure(7)
bar(chroma_profile_reduced);
    set(gca,'XTickLabel', {'C';'C#';'D';'D#';'E';'F';'F#';'G';'G#';'A';'A#';'B';});
title('Hroma profil sa redukovanim spektrogramom');