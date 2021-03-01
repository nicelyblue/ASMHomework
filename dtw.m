function [ L, P, D ] = dtw( C )

[N, M] = size(C);
D = zeros(N, M);

for n = 1:N
    sum = 0;
    for k = 1:n
        sum = sum + C(k,1);
    end
    D(n, 1) = sum;
end

for m = 1:M
    sum = 0;
    for k = 1:m
        sum = sum + C(1, k);
    end
    D(1, m) = sum;
end

for n = 2:N
    for m = 2:M
        D(n, m) = C(n, m) + min([D(n-1, m-1), D(n-1, m), D(n, m-1)]);
    end
end

l = 1;
q1 = N;
q2 = M;
P(1, l) = N;
P(1, l) = M;

while 1
    l = l + 1;
    n = q1;
    m = q2;
    if n == 1
        q1 = n;
        q2 = m - 1;
    elseif m == 1
        q1 = n - 1;
        q2 = m;
    else 
        [~, arg] = min([D(n-1, m-1), D(n-1, m), D(n, m-1)]);
        if arg == 1
            q1 = n - 1;
            q2 = m - 1;
        elseif arg == 2
            q1 = n - 1;
            q2 = m;
        else 
            q1 = n;
            q2 = m-1;
        end
    end
    P(1, l) = q1;
    P(2, l) = q2;
    if (q1 == 1) && (q2 == 1)
        L = l;
        break
    end
end

end

