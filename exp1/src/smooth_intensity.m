function [smIntensity] = smooth_intensity(x, y, nx, ny, img, mode)
    smIntensity = 0; % smooth intentiy init.
    
    [h, w] = size(img);
    
    for i = -ny:ny
        for j = -nx:nx
            inten = 0;
            
            % intensity model of single pixel
            if(strcmp(mode, 'grey')) % grey img
                inten = img(y + i, x + j, 1)/3 + img(y + i, x + j, 2)/3 + img(y + i, x + j, 3)/3;
            end
            if(strcmp(mode, 'green')) % green img
                inten = img(y + i, x + j, 2);
            end
            if(strcmp(mode, 'rb')) % red and blue img
                inten = img(y + i, x + j, 1)/2 + img(y + i, x + j, 3)/2;
            end
            
            smIntensity = smIntensity + int32(inten);
        end
    end
    
    smIntensity = smIntensity/(2*nx + 1)/(2*ny + 1); % mean value
end