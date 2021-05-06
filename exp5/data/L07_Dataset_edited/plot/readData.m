function [A] = readData(file_name)
    fileID = fopen(file_name, 'r');
    
    A = fscanf(fileID, '%f %f %f');
    
    disp(A);
    
    fclose(fileID);
    
    data = load(file_name);
    disp(data);
end