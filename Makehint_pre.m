function    hint_pre = Makehint_pre(A, B, security_level)%没有转换格式的hint
    mod_val = 8380417;
    hint_pre = zeros(1,length(A));
    
    Z = mod(B + A, mod_val);
    for i = 1:length(A)
        if(Highbits(B(i), security_level) == Highbits(Z(i), security_level))
            hint_pre(i) = 0;
        else
            hint_pre(i) = 1;
        end
    end
end