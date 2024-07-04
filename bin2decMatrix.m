function result = bin2decMatrix(array, width)

    % 计算新矩阵的尺寸
    numElements = length(array) / width;
    numRows = ceil(numElements / 256);
    numCols = min(numElements, 256);

    % 初始化新矩阵
    result = zeros(numRows, numCols);

    % 处理数组并填充新矩阵
    for i = 1:numElements
        % 获取当前的二进制子数组
        binArray = array((i-1)*width + 1:i*width);
        % 将二进制子数组转换为字符串
        binStr = flip(num2str(binArray));
        % 移除空格
        binStr = binStr(~isspace(binStr));
        % 转换为十进制数
        decNum = bin2dec(binStr);
        % 确定新矩阵中的位置
        rowIdx = ceil(i / 256);
        colIdx = mod(i-1, 256) + 1;
        % 存储十进制数
        result(rowIdx, colIdx) = decNum;
    end
end