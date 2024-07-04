function    [t1, t0] = Power2Round(t)
    mod_val = 8380417;
    t0 = mod(t,2^13);
    for i = 1 : length(t)
        if(t0(i) > 2^12)
            t0(i) = t0(i) - 2^13;
        end
    end
    t1 = (t - t0)/(2^13);
    t0 = mod(2^12 - t0, mod_val);%transform the format fit for packing
end