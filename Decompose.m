function    [w1, w0] = Decompose(w, security_level)
    mod_val = 8380417;
    if(security_level == 2)
        double_y2 = (8380416)/44;
    else
        double_y2 = (8380416)/16;
    end
    w0 = mod(w, double_y2);
    for i = 1 : length(w)
        if(w0(i) > double_y2/2)
            w0(i) = w0(i) - double_y2;
        end
    end
    w1 = (w - w0);
    for i = 1:length(w)
        if(w(i) >= mod_val - double_y2 / 2)
            w1(i) = 0;
            w0(i) = mod(w0(i)-1,mod_val);
        else
            w1(i) = w1(i)/double_y2;
            w0(i) = mod(w0(i),mod_val);
        end
    end
end