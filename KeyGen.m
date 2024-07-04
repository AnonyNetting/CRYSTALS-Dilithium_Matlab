function    [pk,sk] = KeyGen(seed, security_level)
    %parameter
    mod_val = 8380417;
    switch(security_level)
        case 2
            k = 4;
            l = 4;
        case 3
            k = 6;
            l = 5;
        case 5
            k = 8;
            l = 7;
    end
    %line2
    Shake256_res        = Shake256(seed,128);
    rho                 = Shake256_res(1:256);
    rho_apostrophe      = Shake256_res(257:768);
    K                   = Shake256_res(769:1024);

    %line3: RejsamA
    for i = 1:k
        for j = 1:l
            A(i,j,:) = Rejsam_a(rho, i-1, j-1);
        end
    end

    %line4: NTT(RejsamS)
    for i = 1:(k+l)
        if(i <= l)
            s1(i,:)   = Rejsam_s(rho_apostrophe, i-1, security_level);
        else
            s2(i-l,:) = Rejsam_s(rho_apostrophe, i-1, security_level);
        end
    end

    if(security_level == 3)
        for i = 1:l
            s1_post(i,1:256) = mod(4 - s1(i, 1:256), mod_val);
            s1_post(i,:) = ntt(s1_post(i,:));
        end
        for i = 1:k
            s2_post(i, 1:256)= mod(4 - s2(i, 1:256), mod_val);
        end
    else
        for i = 1:l
            s1_post(i,1:256) = mod(2 - s1(i, 1:256), mod_val);
            s1_post(i,:) = ntt(s1_post(i,:));
        end
        for i = 1:k
            s2_post(i, 1:256)= mod(2 - s2(i, 1:256), mod_val);
        end
    end

    %line5: INTT(A*s1)+s2
    A_s1 = zeros(k, 256);
    for i = 1:k
        for j = 1:l
            for m = 1:256
                %t(i,m) = mod(intt(mod(sum(mod(A(i,1:l,m) * s1_post(1:l,m), mod_val)), mod_val)) + s2_post(i,m), mod_val);
                A_s1(i,m) = mod( mod(A(i,j,m) * s1_post(j,m), mod_val) + A_s1(i,m), mod_val);
            end
        end
            A_s1_intt(i, :) = intt(A_s1(i, :));
            t(i,:) = mod(A_s1_intt(i, :) + s2_post(i, :), mod_val);
    end

    %line6: Power2Round(t)
    for i = 1:k
        [t1(i,:), t0(i,:)] = Power2Round(t(i,:));
    end

    %line7
    pk = rho;
    for i = 1:k
        for m = 1:256
            pk = [pk, flip(dec2bin(t1(i,m), 10)) - '0'];
        end
    end

    %line8
    tr = Shake256(pk, 64);

    %line9
    sk = [rho, K, tr];
    if(security_level == 3)%s1, s2
        for i = 1:l
            for m = 1:256
                sk = [sk, flip(dec2bin(s1(i,m),4))-'0'];
            end
        end
        for i = 1:k
            for m = 1:256
                sk = [sk, flip(dec2bin(s2(i,m),4))-'0'];
            end
        end
    else
        for i = 1:l
            for m = 1:256
                sk = [sk, flip(dec2bin(s1(i,m),3))-'0'];
            end
        end
        for i = 1:k
            for m = 1:256
                sk = [sk, flip(dec2bin(s2(i,m),3))-'0'];
            end
        end
    end
    for i = 1:k%t0
        for m = 1:256
            sk = [sk, flip(dec2bin(t0(i,m), 13))-'0'];
        end
    end
end
