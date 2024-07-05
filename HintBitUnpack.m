function    [hint, verify_result] = HintBitUnpack(h, security_level)
    switch(security_level)
        case 2
            k = 4;
            omega = 80;
        case 3
            k = 6;
            omega = 55;
        case 5
            k = 8;
            omega = 75;
    end
    
    hint = zeros(k,256);
    index = 0;
    verify_result = 0;

    y = bin2decMatrix(h, 8);
    
    for i = 1:k
        if((y(omega + i) < index) || y(omega + i) > omega)
            verify_result = 1;
            return;
        end
        while(index < y(omega + i))
            hint(i, y(index + 1) + 1) = 1;
            index = index + 1;
        end
    end

    while(index < omega)
        if(y(index + 1) ~= 0)
            verify_result = 1;
            return;
        end
        index = index + 1;
    end

    if(sum(hint(:)) > omega)%number of 1's in h is > omega ?
        verify_result = 1;
    end
end
