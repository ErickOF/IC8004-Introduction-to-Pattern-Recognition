clear;

# Cargar imagenes
clear_img = imread('output/GrayLena.PNG');
img_bf1 = imread('output/BilateralLena1.PNG');
img_bf2 = imread('output/BilateralLena2.PNG');
img_bf3 = imread('output/BilateralLena3.PNG');
img_nlm1 = imread('output/NLMLena1.PNG');
img_nlm2 = imread('output/NLMLena2.PNG');
img_nlm3 = imread('output/NLMLena3.PNG');
img_gaussian1 = imread('output/GaussianLena1.PNG');
img_gaussian2 = imread('output/GaussianLena2.PNG');
img_gaussian3 = imread('output/GaussianLena3.PNG');

# Calcular el PSNR de cada imagen
psnr_bf1 = psnr(img_bf1, clear_img);
psnr_bf2 = psnr(img_bf2, clear_img);
psnr_bf3 = psnr(img_bf3, clear_img);
psnr_nlm1 = psnr(img_nlm1, clear_img);
psnr_nlm2 = psnr(img_nlm2, clear_img);
psnr_nlm3 = psnr(img_nlm3, clear_img);
psnr_gaussian1 = psnr(img_gaussian1, clear_img);
psnr_gaussian2 = psnr(img_gaussian2, clear_img);
psnr_gaussian3 = psnr(img_gaussian3, clear_img);

# Mostrar el PSNR de cada imagen
fprintf('PSNR de la primera imagen filtrada con BF: %0.4f\n', psnr_bf1);
fprintf('PSNR de la segunda imagen filtrada con BF: %0.4f\n', psnr_bf2);
fprintf('PSNR de la tercera imagen filtrada con BF: %0.4f\n', psnr_bf3);
fprintf('PSNR de la primera imagen filtrada con NLM: %0.4f\n', psnr_nlm1);
fprintf('PSNR de la segunda imagen filtrada con NLM: %0.4f\n', psnr_nlm2);
fprintf('PSNR de la tercera imagen filtrada con NLM: %0.4f\n', psnr_nlm3);
fprintf('PSNR de la primera imagen filtrada con Gaussiano: %0.4f\n', psnr_gaussian1);
fprintf('PSNR de la segunda imagen filtrada con Gaussiano: %0.4f\n', psnr_gaussian2);
fprintf('PSNR de la tercera imagen filtrada con Gaussiano: %0.4f\n', psnr_gaussian3);
