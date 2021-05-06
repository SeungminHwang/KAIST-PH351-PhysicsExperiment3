function [paired_array] = makePair(B, arrI, arrV)
    %disp(arrI)
    [~, n] = size(arrI);
    paired_array = zeros(n, 3);
    for i=1:n
        paired_array(i, :) = [B, arrI(i), arrV(i)];        
    end
end