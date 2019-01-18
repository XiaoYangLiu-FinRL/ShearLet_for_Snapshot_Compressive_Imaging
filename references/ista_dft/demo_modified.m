%% Reference
% https://people.rennes.inria.fr/Cedric.Herzet/Cedric.Herzet/Sparse_Seminar/Entrees/2012/11/12_A_Fast_Iterative_Shrinkage-Thresholding_Algorithmfor_Linear_Inverse_Problems_(A._Beck,_M._Teboulle)_files/Breck_2009.pdf

%% COST FUNCTION
% x^* = argmin_x { 1/2 * || A(X) - Y ||_2^2 + lambda * || X ||_1 }
%
% x^k+1 = threshold(x^k - 1/L*AT(A(x^k)) - Y), lambda/L)

%%
clear ;
close all;
home;

%% GPU Processing
% If there is GPU device on your board, 
% then isgpu is true. Otherwise, it is false.
bgpu    = false;
bfig    = true;

%% DATA GENERATION
% for Kobe
load("../../dataset/kobe32_cacti.mat") % orig,mean,mask
x       = orig(:,:,1);
x_full  = x;
N       = 256;
M = mask(:,:,1); 
LAMBDA  = 3000; % ϡ���Ե���Ҫ�̶�
L       = 3; % L���󲽳���С��������
niter   = 50; 


% for XCAT
% N       = 512;
% M = rand(512,512)>0.5; % mask����
% LAMBDA  = 0.8;
% L       = 10;
% niter   = 100; 
% load('XCAT512.mat'); % XCAT512
% x       = imresize(double(XCAT512), [N, N]);
% x_full  = x;

%% SYSTEM SETTING FFT2+M
A       = @(x) M.*ifft2(x);
AT      = @(y) fft2(M.*y);
%% ʩ�Ӹ���
pn = M.*x;
x_low   = pn;

%% NEWTON METHOD INITIALIZATION
y       = pn;
x0      = zeros(size(x));

L1              = @(x) norm(x, 1);
L2              = @(x) power(norm(x, 'fro'), 2);
COST.equation   = '1/2 * || A(X) - Y ||_2^2 + lambda * || X ||_1';
COST.function	= @(X) 1/2 * L2(A(X) - y) + LAMBDA * L1(x);

%% RUN NEWTON METHOD
if bgpu
    y  = gpuArray(y);
    x0 = gpuArray(x0);
end

[x_ista, obj]	= MISTA(A, AT, x0, y, LAMBDA, L, niter, COST, bfig);
x_ista = ifft2(x_ista);
%% CALCUATE QUANTIFICATION FACTOR 
x_low           = max(x_low, 0);
nor             = max(x(:));

mse_x_low       = immse(x_low./nor, x./nor);
mse_x_ista      = immse(x_ista./nor, x./nor);

psnr_x_low      = psnr(x_low./nor, x./nor);
psnr_x_ista     = psnr(x_ista./nor, x./nor);

ssim_x_low      = ssim(x_low./nor, x./nor);
ssim_x_ista     = ssim(x_ista./nor, x./nor);

%% DISPLAY
figure(1); 
colormap gray;

suptitle('ISTA Method');
subplot(131);   imagesc(x);	axis image off;     title('orig');
subplot(132);   imagesc(x_low);  	axis image off;     title({'masked', ['MSE : ' num2str(mse_x_low, '%.4e')], ['PSNR : ' num2str(psnr_x_low, '%.4f')], ['SSIM : ' num2str(ssim_x_low, '%.4f')]});
subplot(133);   imagesc(x_ista);  	axis image off;     title({'recon_{ISTA}', ['MSE : ' num2str(mse_x_ista, '%.4e')], ['PSNR : ' num2str(psnr_x_ista, '%.4f')], ['SSIM : ' num2str(ssim_x_ista, '%.4f')]});

%% ������ͼ����
% ƽ������
mean3Sample = filter2(fspecial('average',3),x_ista); % 3��ֵ�˲�
mean7Sample = filter2(fspecial('average',7),x_ista); % 7��ֵ�˲�
gaussianSample = filter2(fspecial('gaussian'),x_ista); % ��˹�˲�
% figure(2);
% colormap gray;
% suptitle('ƽ��');
% 
% subplot(221); 
% imagesc(x_ista); title('ista');
% subplot(222);
% imagesc(mean3Sample); title('average 3');
% subplot(223);
% imagesc(mean7Sample); title('average 7');
% subplot(224);
% imagesc(gaussianSample); title('gaussian');

% �񻯴���
prewittSample = filter2(fspecial('prewitt'),x_ista)/(max(x_ista(:))-min(x_ista(:)));
sobelSample = filter2(fspecial('sobel'),x_ista)/(max(x_ista(:))-min(x_ista(:)));
% figure(3);
% suptitle('��');
% colormap gray;
% subplot(131); 
% imagesc(x_ista); title('ista');
% subplot(132);
% imagesc(prewittSample); title('prewitt');
% subplot(133);
% imagesc(sobelSample); title('sobel');

% �ۺ�
subSample3 = x_ista*2 - mean3Sample;
subSample7 = x_ista*2 - mean7Sample;
subSampleG = x_ista*2 - gaussianSample;
addSampleP = x_ista + prewittSample;
addSampleS = x_ista + sobelSample;

psnr_x_P = psnr(addSampleP./nor, x./nor);
psnr_x_S = psnr(addSampleS./nor, x./nor);
psnr_x_3 = psnr(subSample3./nor, x./nor);
psnr_x_7 = psnr(subSample7./nor, x./nor);
psnr_x_G = psnr(subSampleG./nor, x./nor);

ssim_x_P     = ssim(addSampleP./nor, x./nor);
ssim_x_S      = ssim(addSampleS./nor, x./nor);
ssim_x_3     = ssim(subSample3./nor, x./nor);
ssim_x_7      = ssim(subSample7./nor, x./nor);
ssim_x_G     = ssim(subSampleG./nor, x./nor);

figure(4);
colormap gray;
suptitle('�ۺ�');
subplot(231); 
imagesc(x_ista); title({'ista',['PSNR : ' num2str(psnr_x_ista, '%.4f')], ['SSIM : ' num2str(ssim_x_ista, '%.4f')]});
subplot(232);
imagesc(addSampleP); title({'prewitt',['PSNR : ' num2str(psnr_x_P, '%.4f')], ['SSIM : ' num2str(ssim_x_P, '%.4f')]});
subplot(233);
imagesc(addSampleS); title({'sobel',['PSNR : ' num2str(psnr_x_S, '%.4f')], ['SSIM : ' num2str(ssim_x_S, '%.4f')]});
subplot(234); 
imagesc(subSample3); title({'average 3',['PSNR : ' num2str(psnr_x_3, '%.4f')], ['SSIM : ' num2str(ssim_x_3, '%.4f')]});
subplot(235);
imagesc(subSample7); title({'average 7',['PSNR : ' num2str(psnr_x_7, '%.4f')], ['SSIM : ' num2str(ssim_x_7, '%.4f')]});
subplot(236);
imagesc(subSampleG); title({'gaussian',['PSNR : ' num2str(psnr_x_G, '%.4f')], ['SSIM : ' num2str(ssim_x_G, '%.4f')]});