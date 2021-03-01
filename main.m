clear all;
close all;
clc;

fs = 44100;
%Citanje vrednosti iz matrice
M = dlmread('.\Sample txt files\M_copy.txt',',');

%figure, imagesc(M); %Pomocno iscrtavanje za analizu matrice
%figure, imagesc(mag2db(M)); %Pomocno iscrtavanje za analizu matrice

fmin = 150; %100 Hz
fmax = 3480; %4000 Hz
overlap_percentage = 50; % 50% overlap (preklapanje);

df = (fmax - fmin)/size(M,1);
Nfft = round(fs/df); %broj odbiraka, ujedno i duzina prozora (povecacemo za 1 ako je neparan Nfft)
if(mod(Nfft,2) == 1)
    Nfft = Nfft + 1;
end
%svodimo jednostrani amplitudski (realni) spektar na vrednosti amplituda [0 .. 1]
%M = M/(max(max(abs(M))));

%Dodavanje nula pre i posle:
zeros_before = floor(fmin/df);
M_padded = [zeros(zeros_before,size(M,2)) ; M ; zeros(Nfft/2-zeros_before-size(M,1), size(M,2))];
M_total = [M_padded ; flipud(M_padded)] .* 0.5; % dvostrani spektar je 

% Ako je overlap 25% pomeramo + 75% u svakoj iteraciji (vrednost shift-a)
shift = Nfft - round(Nfft * overlap_percentage *0.01); 
% Duzina signala je onda: (broj_prozora - 1) * shift + duzina_jednog_prozora
output_signal = zeros(1,(size(M,2)-1)*shift + Nfft);
%iteriramo po prozorima
for i = 1 : size(M,2)
   prozor_f = M_total(:,i)'; 
   phases = (-pi)*ones(1,Nfft/2)*0.5;
   phases = [phases -1*fliplr(phases)];
   prozor_cplx_f = prozor_f .* (cos(phases) + 1i.*sin(phases));
   
   temp_signal = ifft_custom(prozor_cplx_f,fs,'Y');
   temp_signal = [temp_signal zeros(1,length(output_signal)-Nfft)];
   temp_signal = circshift(temp_signal, (i-1)*shift);
   output_signal = output_signal + temp_signal;
end

output_signal = 0.8 * output_signal/max(abs(output_signal));

