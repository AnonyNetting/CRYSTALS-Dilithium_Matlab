function    hint = Makehint(hint_pre, omega, k)
    hint = zeros(1,(k+omega)*8);
    hint_omega_flag = 1;
    hint_k_flag = omega + 1;%hint wirting-in place
    
    for i = 1:k
        for j = 1:256
            if(hint_pre(i,j) == 1)
                hint(hint_omega_flag*8-7:hint_omega_flag*8) = flip(dec2bin(j-1,8))-'0';
                hint_omega_flag = hint_omega_flag + 1;
            end
        end
        hint(hint_k_flag*8-7:hint_k_flag*8) = flip(dec2bin(hint_omega_flag-1,8))-'0';
        hint_k_flag = hint_k_flag + 1;
    end
end