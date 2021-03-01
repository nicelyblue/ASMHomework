function [ realni_niz ] = ifft_custom( C_array, fs, isSymmetric)
%IFFT Summary of this function goes here
%   Detailed explanation goes here
% sustinski meni grunu complex matricu i fs, ja vratim na slepacki nacin
% realne vrednosti.
    %prebacimo u jednostrani ako vec nije
    df = fs / length(C_array);
    realni_niz = zeros(1,length(C_array));
    t = (1: length(C_array)).*(1/fs);
    if(isequal(isSymmetric,'Y'))
        C_array = C_array(1:length(C_array)/2).*2;
    end
    
    for i = 1 : length(C_array)
       realni_niz = realni_niz + abs(C_array(i)).*cos(2*pi*(i-1)*df*t + angle(C_array(i))); 
    end
end

