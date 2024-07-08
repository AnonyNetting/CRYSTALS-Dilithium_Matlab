function    signature = Sign(sk, M, security_level)
    %parameter
    mod_val = 8380417;
    switch(security_level)
        case 2
            k = 4;
            l = 4;
            s_width = 3;
            w1_width = 6;
            y1 = 2^17;
            y2 = (mod_val-1)/88;
            omega = 80;
            tau = 39;
            lambda = 128;
            beta = 78;
        case 3
            k = 6;
            l = 5;
            s_width = 4;
            w1_width = 4;
            y1 = 2^19;
            y2 = (mod_val-1)/32;
            omega = 55;
            tau = 49;
            lambda = 192;
            beta = 196;
        case 5
            k = 8;
            l = 7;
            s_width = 3;
            w1_width = 4;
            y1 = 2^19;
            y2 = (mod_val-1)/32;
            omega = 75;
            tau = 60;
            lambda = 256;
            beta = 120;
    end

    %line1-4
    rho = sk(1:256);
    K   = sk(257:512);
    tr  = sk(513:1024);
    s1  = sk(1025:(1024+l*256*s_width));
    s2  = sk((1024+l*256*s_width + 1): (1024+l*256*s_width + k*256*s_width));
    t0  = sk((1024+l*256*s_width + k*256*s_width + 1):(1024+l*256*s_width + k*256*s_width + k*256*13));
    
    s1_pre_ntt = bin2decMatrix(s1, s_width);
    s2_pre_ntt = bin2decMatrix(s2, s_width);
    t0_pre_ntt = bin2decMatrix(t0, 13);

    s1_post = zeros(l,256);
    s2_post = zeros(k,256);
    t0_post = zeros(k,256);
    for i = 1:l
        if(security_level == 3)
            s1_pre_ntt(i,:) = mod(4 - s1_pre_ntt(i,:), mod_val);
        else
            s1_pre_ntt(i,:) = mod(2 - s1_pre_ntt(i,:), mod_val);
        end
        s1_post(i,:) = ntt(s1_pre_ntt(i,:));
    end

    for i = 1:k
        if(security_level == 3)
            s2_pre_ntt(i,:) = mod(4 - s2_pre_ntt(i,:), mod_val);
        else
            s2_pre_ntt(i,:) = mod(2 - s2_pre_ntt(i,:), mod_val);
        end
        s2_post(i,:) = ntt(s2_pre_ntt(i,:));
    end

    for i = 1:k
        t0_pre_ntt(i,:) = mod(2^12 - t0_pre_ntt(i,:), mod_val);
        t0_post(i,:) = ntt(t0_pre_ntt(i,:));
    end

    %line5
    A = zeros(k,l,256);
    for i = 1:k
        for j = 1:l
            A(i,j,:) = Rejsam_a(rho, i-1, j-1);
        end
    end

    %line6
    u = Shake256([tr,M],64);

    %line7

    %line8
    rho_apostrophe = Shake256([K, zeros(1,256), u],64);
    
    %line9
    rej_round = 0;

    %line10
    rej_flag = 0;

    %line11
    while(rej_flag == 0)
        rej_flag = 1;
    %line12
        for i = 1:l
            y(i,:)   = Rejsam_y(rho_apostrophe, i-1+rej_round, security_level);
            if(security_level == 2)
                y(i,:) = mod(2^17 - y(i,:), mod_val);
            else
                y(i,:) = mod(2^19 - y(i,:), mod_val);
            end
            y_post(i,:) = ntt(y(i,:));
        end
    
    %line13
        A_y = zeros(k, 256);
        w = zeros(k, 256);
        for i = 1:k
            for j = 1:l
                for m = 1:256
                    A_y(i,m) = mod( mod(A(i,j,m) * y_post(j,m), mod_val) + A_y(i,m), mod_val);
                end
            end
            w(i, :) = intt(A_y(i, :));
        end

    %line14
        w1 = [];
        for i = 1:k
            for j = 1:256
                w1 = [w1, flip(dec2bin(Highbits(w(i,j),security_level), w1_width))-'0'];
            end
        end

    %line15
        c_ = Shake256([u,w1], 2*lambda/8);%原算法中的~c
    
    %line17
        c = SampleInBall(c_(1:256), tau);

    %line18
        c_post = ntt(c(:));
    
    %line19
        c_s1 = zeros(l,256);
        for i = 1:l
            for j = 1:256
                c_s1(i,j) = mod(c_post(j)*s1_post(i,j), mod_val);
            end
            c_s1(i,:) = intt(c_s1(i,:));
        end

    %line20
        c_s2 = zeros(k,256);
        for i = 1:k
            for j = 1:256
                c_s2(i,j) = mod(c_post(j)*s2_post(i,j), mod_val);
            end
            c_s2(i,:) = intt(c_s2(i,:));
        end

    %line21
        z = zeros(l,256);
        for i = 1:l
            z(i,:) = mod(y(i,:)+c_s1(i,:), mod_val);
        end

    %line22
        r0 = zeros(k,256);
        for i = 1:k
            r0(i,:) = Lowbits(mod(w(i,:) - c_s2(i,:), mod_val), security_level);
        end

    %line23
        for i = 1:l
            for j = 1:256
                if((z(i,j) >= y1 - beta) && (z(i,j) <= mod_val - (y1-beta)))
                    rej_flag = 0;
                    fprintf("z error happens at i = %d, j = %d, z(%d, %d) = %x, rej_round = %d\n", i, j, i, j, z(i,j), rej_round);
                    break;
                end
            end
            if(rej_flag ==0)
                break;
            end
        end

        for i = 1:k
            for j = 1:256
                if((r0(i,j) >= y2 - beta) && (r0(i,j) <= mod_val - (y2 - beta)))
                    rej_flag = 0;
                    fprintf("r0 error happens at i = %d, j = %d, rej_round = %d\n", i, j, rej_round);
                    break;
                end
            end
            if(rej_flag ==0)
                break;
            end
        end

        if(rej_flag == 0)
            rej_round = rej_round + l;
            continue;
        end
        
    %line25
        c_t0 = zeros(k,256);
        for i = 1:k
            for j = 1:256
                c_t0(i,j) = mod(c_post(j)*t0_post(i,j), mod_val);
            end
            c_t0(i,:) = intt(c_t0(i,:));
        end
    
    %line26
        for i = 1:k
            makehint_A = mod(-c_t0(i,:), mod_val);
            makehint_B = mod(w(i,:) - c_s2(i,:), mod_val);
            makehint_B = mod(makehint_B + c_t0(i,:), mod_val);
            hint_pre(i,:) = Makehint_pre(makehint_A, makehint_B, security_level);
        end

    %line27
        for i = 1:k
            for j = 1:256
                if(c_t0(i,j) >= y2 && c_t0(i,j) <= (mod_val - y2))
                    rej_flag = 0;
                    fprintf("c_t0 error happens at i = %d, j = %d, rej_round = %d\n", i, j, rej_round);
                    break;
                end
            end
            if(rej_flag == 0)
                break;
            end
        end
        if(sum(hint_pre(:)) > omega)
            rej_flag =0;
            fprintf("hint error happens, #of1 in hint is %d, rej_round = %d\n", sum(hint_pre(:)), rej_round);
        end
    
    %line30
        rej_round = rej_round + l;
    end
    
    %line32
    hint = Makehint(hint_pre, omega, k);

    signature = c_;
    
    for i = 1:l
        for j = 1:256
            z(i,j) = mod(y1 - z(i,j), mod_val);
            signature = [signature, flip(dec2bin(z(i,j), log2(y1)+1))-'0'];
        end
    end

    signature = [signature, hint];
end
