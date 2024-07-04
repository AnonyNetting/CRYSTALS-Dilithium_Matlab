function    c = SampleInBall(c1, tau)
    c = zeros(1,256);
    res = Shake256(c1,800);
    s_flag = 1;
    res_flag = 9;
    weights = [1 2 4 8 16 32 64 128];
    for i = 256-tau:255
        while(sum(res(res_flag*8-7:res_flag*8) .* weights) > i)
            res_flag = res_flag + 1;
        end
        j = sum(res(res_flag*8-7:res_flag*8) .* weights);
        s = res(s_flag);
        c(i+1) = c(j+1);
        if(s == 1)
            c(j+1) = 8380416;
        else
            c(j+1) = 1;
        end
        s_flag = s_flag + 1;
        res_flag = res_flag + 1;
    end
end