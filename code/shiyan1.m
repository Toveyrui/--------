% file: shiyan1.m
% author: Reiky
% date: 2024-10-27
% description: 用于实验1的matlab程序
% 三.实验原理
% (1)将一幅图像视为一个二维矩阵。
% (2)利用MATLAB图像处理工具箱读、写和显示图像文件。
% ①调用imread函数将图像文件读入图像数组(矩阵)。例如“I= imread(tire. tif);”。其基木格式为：“A=imread(filename,fmt)”，其中，A为二维数组，filename为文件名，fmt为图像文件格式的扩展名。
% ②调用imwrite函数将图像矩阵写入图像文件。例如“imwrite(A,’tire.tif’);”。其基本格式为：“imwrite(a, filename, fmt）”。
% ③调用imshow函数显示图像。例如“imshow(‘tire.tif’);”。其基本格式为：“mshow(I,N)”，其中，I为图像矩阵，N为显示的灰度级数，默认时为256。
% (3)计算图像的有关统计参数。
% 四.实验步骤
% (1)利用“读图像文件I/O”函数读入图像football. jpg。
% (2)利用“读图像文件I/O”的imfinfo函数了解图像文件的基本信息：主要包括Filename(文件名)、FileModDate(文件修改时间)、FileSize(文件尺寸)、Format(文件格式)、FormatVersion(格式版本)、Width(图像宽度)、Height(图像高度)、BitDepth(每个像素的位深度)、ColorType(彩色类型)、CodingMethod(编码方法)等。
% (3)利用“像素和统计处理”函数计算读入图像的二维相关系数(corr2函数)，确定像素颜色值(impixel函数)，确定像素的平均值(mean2函数)，显示像素的信息(pixval函数)、计算像素的标准偏移(std2函数)等。
% 要求：参照例1.1，对图像J加均值为0、方差为0.01的高斯白噪声形成有噪图像J1，即“J1=imnoise(J, ‘gaussian‘, 0, 0.01);”，求J1的像素总个数、图像灰度的平均值、标准差、J和J1的互协方差和相关系数、J和K的互协方差和相关系数。
% 将方差加至0.1，重新计算上述统计参数。
% (4)改变图像尺寸(imresize函数)、旋转图像(imrotate函数)、对图像进行裁剪(imcrop函数)等,再对操作后的图像进行统计。图2.20所示为裁剪后的显微图像。
% 原图像I按比例SCALE改变尺寸后的图像为J。imresize函数的调用格式是“J=imsize(I,SCALE)”，同理，图像A按ANGLE角度进行旋转得到图像B的语句为：“B=imrotate(A,ANGLE)”。对于图1.17中的SBS改性沥青材料的显微图像，由于尺寸偏大，可以按水平和垂直0.15的比例降低空间分辨率。对图像J进行裁剪的MATLAB函数是imcrop，调用格式为“K=imcrop(J,RECT)”，其中RECT是4元素向量[XMIN YMIN WIDTH HEIGHT]，XMIN、YMIN为左下角坐标值，WIDTH、HEIGHT分别是裁剪区域的宽度和高度。由于曝光不均匀,可能给图像处理和分析带来困难。舍去暗的地区，采用图像裁剪参数RECT=[0 181 363 283]得到光照较均匀的左下角图像，裁剪结果如图2.20所示。
% 要求：参照例2.1，将图像I分别放大和缩小1.5倍、旋转30°，再对操作后的图像进行统计。
% (5)将经上述不同操作后的图像用“读图像文件I/O”函数分别写入各自的图像文件。
% (6)选择cameraman和lena图像进行直方图的计算。
% (7)编程实现图3.5中不同采样率图像的显示效果。
% (8)编程实现图3.6中不同量化等级图像的显示效果。

%% (1)
figure(1);
I = imread('../ImgLib/football.jpg');
imshow(I);

%% (2)
disp('FileName');
disp(imfinfo('../ImgLib/football.jpg').Filename);
disp('FileModDate');
disp(imfinfo('../ImgLib/football.jpg').FileModDate);
disp('FileSize');
disp(imfinfo('../ImgLib/football.jpg').FileSize);
disp('Format');
disp(imfinfo('../ImgLib/football.jpg').Format);
disp('FormatVersion');
disp(imfinfo('../ImgLib/football.jpg').FormatVersion);
disp('Width');
disp(imfinfo('../ImgLib/football.jpg').Width);
disp('Height');
disp(imfinfo('../ImgLib/football.jpg').Height);
disp('BitDepth');
disp(imfinfo('../ImgLib/football.jpg').BitDepth);
disp('ColorType');
disp(imfinfo('../ImgLib/football.jpg').ColorType);
disp('CodingMethod');
disp(imfinfo('../ImgLib/football.jpg').CodingMethod);

%% (3)
J = imnoise(I, 'gaussian', 0, 0.01);
J1 = imnoise(I, 'gaussian', 0, 0.1);
% 求J1的像素总个数
numel(J1);
disp('The number of J1:');
disp(numel(J1));
% 图像灰度的平均值
mean2(J1);
disp('Advange of J1:');
disp(mean2(J1));
% 标准差
std2(J1);
disp('Standard deviation of J1:');
disp(std2(J1));
% J和J1的互协方差和相关系数
cov(double(J(:)), double(J1(:)));
corr2(rgb2gray(J), rgb2gray(J1));
disp('Covariance and correlation coefficient of J and J1:');
disp(cov(double(J(:)), double(J1(:))));
disp(corr2(rgb2gray(J), rgb2gray(J1)));
% J和K的互协方差和相关系数
K = imnoise(I, 'gaussian', 0, 0.01);
cov(double(J(:)), double(K(:)));
corr2(rgb2gray(J), rgb2gray(K));
disp('Covariance and correlation coefficient of J and K:');
disp(cov(double(J(:)), double(K(:))));
disp(corr2(rgb2gray(J), rgb2gray(K)));

%% (4)
figure(4);
J = imresize(I, 1.5);
K = imresize(I, 0.5);
B = imrotate(I, 30);
% 对图像进行裁剪
RECT = [0 181 363 283];
%% 展示变换成果
subplot(2, 2, 1);
imshow(J);
title('J');
subplot(2, 2, 2);
imshow(K);
title('K');
subplot(2, 2, 3);
imshow(B);
title('B');
L = imcrop(I, RECT);
subplot(2, 2, 4);
imshow(L);
title('L');

%% (5)
imwrite(J, 'J.jpg');
imwrite(K, 'K.jpg');
imwrite(B, 'B.jpg');
imwrite(L, 'L.jpg');

%% (6)
figure(6);
cameraman = imread('../ImgLib/cameraman.png');
lena = imread('../ImgLib/lena.jpg');
% cameraman直方图
imhist(cameraman);
% lena直方图
imhist(lena);

%% (7)
% 编程实现图3.5中不同采样率图像的显示效果
% 读取图像
figure(7);
I = imread('../ImgLib/football.jpg');
% 采样率
rate = [0.1, 0.2, 0.5, 0.8, 1];
for i = 1:5
    J = imresize(I, rate(i));
    subplot(2, 3, i);
    imshow(J);
    title(['rate = ', num2str(rate(i))]);
end

%% (8)
figure(8);
% 编程实现图3.6中不同量化等级图像的显示效果
% 读取图像
I = imread('../ImgLib/football.jpg');
% 量化等级
level = [2, 4, 8, 16, 32, 64];
for i = 1:6
    J = im2uint8(mat2gray(I) * (level(i) - 1));
    subplot(2, 3, i);
    imshow(J, []);
    title(['level = ', num2str(level(i))]);
end