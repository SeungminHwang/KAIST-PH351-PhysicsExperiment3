% PH351 Exp.1 Figures
%clear all;

%fundamental jobs
file_name = '../data/sample.png';
img = imread(file_name);

[img_h, img_w, ~] = size(img); % get dimension of img


% Generate gray image
mat_gray = zeros(img_h, img_w);
mat_gray(:,:) = img(:,:,1)/3 + img(:,:,2)/3 + img(:,:,3)/3; 
img_gray = mat2gray(mat_gray);

%imwrite(img_gray, "test/test.png");

%% Figure RGB distribution

% position of center of diffraction ring
horizontal_line = 2034;
vertical_line = 2979;

subplot(2, 2, 1);
plot(img(horizontal_line, :, 1), "ro", 'MarkerSize',1);
title("Value of R on y = " + num2str(horizontal_line), 'FontSize', 15);

subplot(2, 2, 2);
plot(img(horizontal_line, :, 2), "go", 'MarkerSize',1);
title("Value of G on y = " + num2str(horizontal_line), 'FontSize', 15);

subplot(2, 2, 3);
plot(img(horizontal_line, :, 3), "bo",'MarkerSize', 1);
title("Value of B on y = " + num2str(horizontal_line), 'FontSize', 15);


subplot(2, 2, 4);
imagesc(img);
t = linspace(1, 6000, 20);
y = horizontal_line*ones(1,20);
line(t, y, 'LineWidth', 2, 'Color', 'red', 'LineStyle', ':');
title("Sample Image, y = " + num2str(horizontal_line), 'FontSize', 15);


%saveas(gcf, '../../exp1_final_report/img/RGB_distribution.png');

%% extract local maxima

cumulative = zeros(size(img(horizontal_line, :, 2)));
width = 1;%40;
temp = 30;

for i = 1800:4200
    acc = 0;
    for j = -width:width
        for k = -temp:temp
            acc = acc + int32(img(horizontal_line + k, i + j, 2));
            %sum = sum + int32(mat_gray(horizontal_line + k, i + j));
        end
    end
    cumulative(i) = acc/(width*2 + 1)/(temp*2 + 1);
end


subplot(1, 1, 1);
plot(cumulative);



%% smooth intensity plot

hr = horizontal_line;
smInten = zeros(1, 6000);

% nx variation
ny = 0;
for j = 1:5
    subplot(2, 5, j);
    nx = 20*(j - 1);
    for i = 1000:5000
        smInten(i) = smooth_intensity(i, hr, nx, ny, img,'grey');
    end
    plot(smInten);
    title("nx = " + num2str(nx) + ", ny = " + num2str(ny), 'FontSize', 15);
    ylabel("Smooth intensity", 'FontSize', 15);
    xlabel("pixel on horizontal line", 'FontSize', 15);
end

% ny variation
nx = 0;
for j = 1:5
    subplot(2, 5, 5 + j);
    ny = 20*(j - 1);
    for i = 1000:5000
        smInten(i) = smooth_intensity(i, hr, nx, ny, img,'grey');
    end
    plot(smInten);
    title("nx = " + num2str(nx) + ", ny = " + num2str(ny), 'FontSize', 15);
    ylabel("Smooth intensity", 'FontSize', 15);
    xlabel("pixel on horizontal line", 'FontSize', 15);
end

%saveas(gcf, '../../exp1_final_report/img/smooth_intensity_param.png');

%% bar
subplot(1, 1, 1);
kg = 10:10:90;
n = [264 268 267 270 270 267 265 262];
histogram('BinEdges',kg,'BinCounts',n)
xlabel('ruler interval (mm)', 'FontSize', 15)
ylabel('Pixels on the Interval (px)', 'FontSize', 15)

%saveas(gcf, '../../exp1_final_report/img/px-len-conv.png');



temp_y = [264 268 267 270 270 267 265 262];
temp_y_inv = ones(1, 8)./temp_y;
temp_x = [15 25 35 45 55 65 75 85];

%% Analysis
nx = 10;
ny = 5;

for i = 1:3
    hr = horizontal_line;
    smInten = zeros(1, 6000);
    
    file_name = sprintf('../data/v%d_%d.png', 5000, i);
    img = imread(file_name);
    
    for j = 1000:5000
        smInten(j) = smooth_intensity(j, hr, nx, ny, img, 'grey');
    end
    subplot(1, 3, i);
    plot(smInten);
end

%% calculate
close all;

%d1 = [28.16, 27.68, 27.75, 25.28, 25.43, 25.84, 24.16, 24.16, 23.86, 22.43, 22.81, 22.77, 20.94, 21.57, 21.61];
d1 = [28.2, 27.7, 27.8, 25.3, 25.4, 25.8, 24.2, 24.2, 23.9, 22.4, 22.8, 22.8, 20.9, 21.6, 21.6];
d2 = [48.46, 47.68, 47.98, 44.76, 45.43, 44.64, 42.47, 43.37, 42.43, 39.48, 40.49, 40.07, 38.2, 38.2, 38.16];



x = zeros(1, 5);
y1 = zeros(1, 5);
e1 = zeros(1, 5);
y2 = zeros(1, 5);
e2 = zeros(1, 5);
for i = 0:4
    V = 3000 + i*500;
    %x(i + 1) = 1/sqrt(double(V));
    % for relativistic
    x(i + 1) = 1/sqrt(double(V))*1/sqrt(1 + 1.602/9.11/2/2.998/2.998*10^(-4)*V);
    
    
    % mean
    y1(i + 1) = mean(d1(i*3 + 1 : i*3 + 3));
    y2(i + 1) = mean(d2(i*3 + 1 : i*3 + 3));
    
    %std
    e1(i + 1) = std(d1(i*3 + 1 : i*3 + 3), 1);
    e2(i + 1) = std(d2(i*3 + 1 : i*3 + 3), 1);
end

subplot(1, 1, 1);

hold on;
res1 = errorbar(x, y1, e1);
res1.LineStyle = 'none';
res1.LineWidth = 2;
res1.Marker = '.';

res2 = errorbar(x, y2, e2);
res2.LineStyle = 'none';
res2.LineWidth = 2;
res2.Marker = '.';


% linear fit
mdl1 = fitlm(x, y1);
mdl2 = fitlm(x, y2);

t = linspace(min(x), max(x), 100);
A1 = mdl1.Coefficients.Estimate(1);
B1 = mdl1.Coefficients.Estimate(2);
A2 = mdl2.Coefficients.Estimate(1);
B2 = mdl2.Coefficients.Estimate(2);

plot(t, A1 + B1*t , 'LineWidth', 1, 'LineStyle', '--')
plot(t, A2 + B2*t, 'LineWidth', 1, 'LineStyle', '--')


%xlabel('$1/ \sqrt{V} \;\; $[$V^{-\frac{1}{2}}$]', 'Interpreter', 'latex', 'FontSize', 15, 'FontWeight', 'bold')
% for relativistic
xlabel('$(1 + \frac{eV}{2m_0c^2})^{-1/2} {V}^{-1/2} \;\; $[$ V^{-\frac{1}{2}}$]', 'Interpreter', 'latex', 'FontSize', 15, 'FontWeight', 'bold')
ylabel('$D \;\; $[mm]', 'Interpreter', 'latex', 'FontSize', 15, 'FontWeight', 'bold')
text(0.017, 28, sprintf('y = %.3f + %.3f x\nRMSE: %.3f\nR^2: %.3f',A1, B1, mdl1.RMSE, mdl1.Rsquared.Ordinary));
text(0.0175, 45, sprintf('y = %.3f + %.3f x\nRMSE: %.3f\nR^2: %.3f',A2, B2, mdl2.RMSE, mdl2.Rsquared.Ordinary));

%saveas(gcf, '../../exp1_final_report/img/final_graph.png');
%saveas(gcf, '../../exp1_final_report/img/final_graph_rel.png');

hold off;
