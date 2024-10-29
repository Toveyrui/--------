% @file shiyani2.m
% @author Reiky
% @date 2024-10-29
% @description: 用于实验2的matlab程序
% 三.实验原理
% (1)二维离散傅里叶变换，余弦变换的正逆变换公式。
% (2)图像的频谱分析原理。
% (3)将一幅图像视为一个二维矩阵，用MATLAB进行图像增强。
% (4)利用MATLAB图像处理工具箱中的函数imread(读)、imshow(显示)、imnoise(加噪)、filter2(滤波)对图像进行去噪处理。
% (5)图像灰度修正：灰度变换。对不满意的图像通过线性或非线性灰度映射关系进行变换，其效果可以得到明显提高。通过分析，会发现变换前后图像的直方图也发生相应的变化。
% (6)图像平滑方法：邻域平均、中值滤波。分析图像降质的性质，区分平稳型还是非平稳型、加性还是乘性等，采用合适的去噪方法，可以去除或降低噪声对图像的影响。从频率域看，平均操作在减低噪声的同时衰减了图像的高频分量，会影响图像细节的重现。中值滤波对某些信号具有不变性，适用于消除图像中的突发干扰，但如果图像含有丰富的细节，则不宜使用。
% (7)图像锐化方法：人眼对目标的边缘和轮廓较为敏感，对图像进行锐化，有助于突出图像的这些特征。从频率域看，锐化提升了图像的高频分量。

% 四.实验内容与步骤
% (1)在MATLAB环境中，进行图像的离散傅里叶变换和离散余弦变换，观察图像的频谱并减少DCT系数，观察重建信号和误差信号，理解正交变换在压缩编码中的应用。
% (2)MATLAB图像增强。
% ①图像灰度修正。测试图像为pout.tif，tire.tif。读入一幅灰度级分布不协调的图像，分析其直方图。根据直方图，设计灰度变换表达式，或调用imadjust函数。调整变换表达式的参数，直到显示图像的灰度级分布较均衡为止。
% ②不均匀光照的校正。测试图像为pout.tif。采用分块处理函数blkproc和图像相减函数imsubtract校正图6.6存在的不均匀光照现象。
% ③三段线性变换增强。测试图像为couple.tif。选择合适的转折点，编程对图6.10进行三段线性变换增强。
% ④图像平滑方法。测试图像为eight.tif。对有噪图像或人为加入噪声的图像进行平滑处理。根据噪声的类型，选择不同的去噪方法，如邻域平均、中值滤波等方法，调用filter2、medfilt2函数，选择不同的滤波模板和参数，观测和分析各种去噪方法对不同噪声图像处理的去噪或降噪效果。
% ⑤图像锐化方法。测试图像为rice. tif、cameraman.tif。读入一幅边缘模糊的图像，利用罗伯茨梯度对图像进行4种锐化处理，比较各自的效果。

%% init
clc;
close all;
clear all;

%% (1)
figure(1);
I = imread('../ImgLib/football.jpg');
I_gray = rgb2gray(I); % Convert to grayscale
disp('I');
% 离散傅里叶变换
F = fft2(I_gray);
% 离散余弦变换
C = dct2(I_gray);
% 逆变换
I_F = ifft2(F);
I_C = idct2(C);
% 显示
subplot(2, 2, 1);
imshow(I);
title('原始图像');
subplot(2, 2, 2);
imshow(log(abs(F)), []);
title('离散傅里叶变换');
subplot(2, 2, 3);
imshow(log(abs(C)), []);
title('离散余弦变换');
subplot(2, 2, 4);
imshow(uint8(I_F));
title('傅里叶逆变换');
% 观察图像的频谱并减少DCT系数
imshow(uint8(I_C)); 
title('余弦逆变换');
%% (2)
figure(2);
% 图像灰度修正
I1 = imread('pout.tif');
I2 = imread('tire.tif');
% 直方图
subplot(2, 2, 1);
imshow(I1);
title('pout.tif的直方图');
subplot(2, 2, 2);
imhist(I1);
subplot(2, 2, 3);
imshow(I2);
title('tire.tif的直方图');
subplot(2, 2, 4);
imhist(I2);
% 根据直方图，设计灰度变换表达式
I1 = imadjust(I1, [0.3, 0.7], [0, 1]);
I2 = imadjust(I2, [0.3, 0.7], [0, 1]);
figure(3);
subplot(2, 2, 1);
imshow(I1);
title('pout.tif的灰度直方图');
subplot(2, 2, 2);
imhist(I1);
subplot(2, 2, 3);
imshow(I2);
title('tire.tif的灰度直方图');
subplot(2, 2, 4);
imhist(I2);
% 不均匀光照的校正
I = imread('pout.tif');
% 分块处理函数blockproc和图像相减函数imsubtract校正图6.6存在的不均匀光照现象
fun = @(block_struct) mean2(block_struct.data) * ones(size(block_struct.data));
I_mean = blockproc(I, [16, 16], fun);
I_mean_resized = imresize(I_mean, [size(I, 1), size(I, 2)]); % Ensure sizes match
I_mean_resized = im2uint8(I_mean_resized); % Convert to uint8
I_corrected = imsubtract(I, I_mean_resized);
figure(4);
imshow(I_corrected);
title('pout.tif的不均匀光照校正');
imshow(I);
title('pout.tif的不均匀光照校正');
% 三段线性变换增强
I = imread('../ImgLib/couple.tiff');
% 选择合适的转折点，编程对图6.10进行三段线性变换增强
I = imadjust(I, [0.3, 0.7], [0, 1]);
figure(5);
imshow(I);
title('couple.tif的三段线性变换增强');
% 图像平滑方法
I = imread('../ImgLib/eight.jpg');
% 对有噪图像或人为加入噪声的图像进行平滑处理
I = imnoise(I, 'salt & pepper', 0.02);
% 选择不同的去噪方法，如邻域平均、中值滤波等方法
I_gray = rgb2gray(I); % Convert to grayscale
I1 = filter2(fspecial('average', 3), I_gray);
I2 = medfilt2(I_gray);
figure(6);
subplot(2, 2, 1);
imshow(I);
title('原始图像');
subplot(2, 2, 2);
imshow(I1);
title('平均去噪图像');
subplot(2, 2, 3);
imshow(I2);
title('中值去噪图像');
% 图像锐化方法
I = imread('../ImgLib/rice.png');
% 利用罗伯茨梯度对图像进行4种锐化处理
I1 = imfilter(I, fspecial('sobel'));
I2 = imfilter(I, fspecial('prewitt'));
I3 = imfilter(I, fspecial('laplacian'));
I4 = imfilter(I, fspecial('log'));
figure(7);
subplot(2, 2, 1);
imshow(I);
title('原始图像');
subplot(2, 2, 2);
imshow(I1);
title('Sobel的锐化');
subplot(2, 2, 3);
imshow(I2);
title('Prewitt的锐化');
subplot(2, 2, 4);
imshow(I3);
title('Laplacian的锐化');
figure(8);
imshow(I4);
title('LoG的锐化');
