function    rej_a_res = Rejsam_a(rho, row, column)
    row_matrix      = flip(dec2bin(row,8)) - '0';
    column_matrix   = flip(dec2bin(column,8)) - '0';
    res = Shake128([rho,column_matrix, row_matrix],800);
    poly_cnt = 0;
    for i = 1:600
        if(poly_cnt < 256)
            if(bin2dec(flip(reshape(char(res((24*i-23):(24*i-1))+'0'),23,''))') < 8380417)
                rej_a_res(poly_cnt+1) = bin2dec(flip(reshape(char(res((24*i-23):(24*i-1))+'0'),23,''))');
                poly_cnt = poly_cnt + 1;
            end
        else
            break;
        end
    end
end
