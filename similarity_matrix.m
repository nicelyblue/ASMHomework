function C = similarity_matrix(chroma1, chroma2)

max_ = max(size(chroma1, 2), size(chroma2,2));
min_ = min(size(chroma1, 2), size(chroma2,2));

if size(chroma1, 2) == min_
    temp = chroma2;
    chroma2 = chroma1;
    chroma1 = temp;
end

C = zeros(max_, min_);

for i = 1:max_
    for j = 1:min_
        C(i, j) = norm(chroma1(:, i)-chroma2(:, j));
        %C(i, j) = 1 - (sum(chroma1(:, i).*chroma2(:, j))/(norm(chroma1(:, i))*norm(chroma2(:, j))));
    end
end

C(~any(~isnan(C), 2),:)=[];
C = C(:,all(~isnan(C)));

normC = C - min(C(:));
C = normC ./ max(normC(:));

end