function    verify_result = Verify(pk, signature, M, security_level)
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
    verify_result = 0;%verify_result = 1 <=> error, = 0 <=> correct

    %line1-4
    rho = pk(1:256);
    t1  = pk((256 + 1):(256 + k*256*10));
    c_  = signature(1:2*lambda);
    z   = signature(2*lambda + 1:2*lambda + l*256*(log2(y1)+1));
    h   = signature(2*lambda + l*256*(log2(y1)+1) + 1: 2*lambda + l*256*(log2(y1)+1) + (omega + k)*8);
    
    t1_pre_ntt = bin2decMatrix(t1, 10);
    z_pre_ntt  = bin2decMatrix(z, log2(y1)+1);

    t1_post = zeros(k,256);
    z_post  = zeros(l,256);

    [hint, verify_result] = HintBitUnpack(h, security_level);
    if(verify_result == 1)
        fprintf("error at hint");
        return;
    end

    for i = 1:k
        t1_pre_ntt(i,:) = mod(t1_pre_ntt(i,:) * (2^13), mod_val);
        t1_post(i,:) = ntt(t1_pre_ntt(i,:));
    end

    for i = 1:l
        z_pre_ntt(i,:) = mod(y1 - z_pre_ntt(i,:), mod_val);
        for j = 1:256
            if((z_pre_ntt(i, j) >= y1-beta) && (z_pre_ntt(i, j) <= mod_val-(y1-beta)))
                verify_result = 1;
                fprintf("error at z(%d,%d)", i,j);
                return;
            end
        end
        z_post(i,:) = ntt(z_pre_ntt(i,:));
    end
    

    %line5
    A = zeros(k,l,256);
    for i = 1:k
        for j = 1:l
            A(i,j,:) = Rejsam_a(rho, i-1, j-1);
        end
    end

    %line6
    tr = Shake256(pk, 64);

    %line7
    u = Shake256([tr,M],64);

    %line8~9
    c = SampleInBall(c_(1:256), tau);
    c_post(:) = ntt(c(:));

    %line10
    Az_ct1 = zeros(k, 256);
    w_approx = zeros(k, 256);
    for i = 1:k
        Az_ct1(i,:) = mod(-(c_post .* t1_post(i,:)), mod_val);
        for j = 1:l
            for m = 1:256
                Az_ct1(i,m) = mod( mod(A(i,j,m) * z_post(j,m), mod_val) + Az_ct1(i,m), mod_val);
            end
        end
        w_approx(i, :) = intt(Az_ct1(i, :));
    end

    %line11
    w1_approx = Usehint(w_approx, hint, security_level);

    %line12
    w1 = [];
    for i = 1:k
        for j = 1:256
            w1 = [w1, flip(dec2bin(w1_approx(i,j),w1_width))-'0'];
        end
    end
    c_verify = Shake256([u,w1], 2*lambda/8);%原算法中的~c

    %line13
    if(~isequal(c_verify,c_))
        verify_result = 1;
        fprintf("error at c");
        return;
    end
end