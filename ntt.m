function ntt_res = ntt(a)
    % Initialize variables
    N = 256; % 300005
    mod_val = 8380417; % dilithium:8380417
    g = 1753; % dilithium:1753
    
    % Pre-treat for negative wrapped convolution
    for i = 1:N
        a(i) = mod(a(i) * qpow(g, i-1, mod_val), mod_val);
    end
    
    % Perform NTT
    ntt_res = ntt(a, 1, N, g, mod_val);
    
    % Power function (modular exponentiation)
    function res = qpow(a, b, mod_val)
        res = 1;
        while b > 0
            if bitand(b, 1)
                res = mod(res * a, mod_val);
            end
            a = mod(a * a, mod_val);
            b = bitshift(b, -1);
        end
    end
    
    % NTT function
    function a = ntt(a, flag, N, g, mod_val)
        % Bit-reverse order using bitrevorder
        a = bitrevorder(a);
    
        mid = 1;
        while mid < N
            g1 = qpow(qpow(g, 2, mod_val), N / (mid * 2), mod_val);
            if flag == -1
                g1 = qpow(g1, mod_val-2, mod_val);
            end
            for i = 1:mid*2:N
                gk = 1;
                for j = 0:mid-1
                    x = a(i+j);
                    y = mod(a(i+j+mid) * gk, mod_val);
                    a(i+j) = mod(x + y, mod_val);
                    a(i+j+mid) = mod(x - y + mod_val, mod_val);
                    gk = mod(gk * g1, mod_val);
                end
            end
            mid = mid * 2;
        end
    
        if flag == -1
            inv = qpow(N, mod_val-2, mod_val);
            for i = 1:N
                a(i) = mod(a(i) * inv, mod_val);
            end
        end
    end
end
