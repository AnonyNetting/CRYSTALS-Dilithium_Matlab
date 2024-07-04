function    rej_s_res = Rejsam_s(rho_apostrophe, row, security_level)
    row_matrix      = flip(dec2bin(row,16)) - '0';
    res = Shake256([rho_apostrophe,row_matrix],800);
    poly_cnt = 0;
    for i = 1:2000
        if(poly_cnt < 256)
            if(security_level == 3)%security_level3时rejsam_s规则略有不同
                if(bin2dec(flip(reshape(char(res((4*i-3):(4*i))+'0'),4,''))') < 9)
                    rej_s_res(poly_cnt+1) = bin2dec(flip(reshape(char(res((4*i-3):(4*i))+'0'),4,''))');
                    poly_cnt = poly_cnt + 1;
                end
            else
                if(bin2dec(flip(reshape(char(res((4*i-3):(4*i))+'0'),4,''))') < 15)
                    rej_s_res(poly_cnt+1) = mod(bin2dec(flip(reshape(char(res((4*i-3):(4*i))+'0'),4,''))'),5);
                    poly_cnt = poly_cnt + 1;
                end
            end
        else
            break;
        end
    end
end
