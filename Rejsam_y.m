function    rej_y_res = Rejsam_y(rho_apostrophe, row, security_level)
    row_matrix      = flip(dec2bin(row,16)) - '0';
    res = Shake256([rho_apostrophe,row_matrix],800);
    poly_cnt = 0;
    for i = 1:2000
        if(poly_cnt < 256)
            if(security_level == 2)%security_level3时rejsam_y规则略有不同
                rej_y_res(poly_cnt+1) = bin2dec(flip(reshape(char(res((18*i-17):(18*i))+'0'),18,''))');
                poly_cnt = poly_cnt + 1;
            else
                rej_y_res(poly_cnt+1) = bin2dec(flip(reshape(char(res((20*i-19):(20*i))+'0'),20,''))');
                poly_cnt = poly_cnt + 1;
            end
        else
            break;
        end
    end
end
