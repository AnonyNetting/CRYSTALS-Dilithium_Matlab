function    w1_approx = Usehint(w_approx, hint, security_level)
    switch(security_level)
        case 2
            k = 4;
            m = 44;
        case 3
            k = 6;
            m = 16;
        case 5
            k = 8;
            m = 16;
    end

    w1_approx = zeros(k,256);

    for i = 1:k
        for j = 1:256
            [r1,  r0] = Decompose(w_approx(i,j), security_level);
            if((hint(i,j) == 1) && (r0 > 0) && (r0 < 4190208))%r0 > 0
                w1_approx(i,j) = mod(r1 + 1, m);
                continue;
            end
            if((hint(i,j) == 1) && ((r0 == 0) || (r0 > 4190208)))%r0 <= 0
                w1_approx(i,j) = mod(r1 - 1, m);
                continue;
            end
            w1_approx(i,j) = r1;
        end
    end
end