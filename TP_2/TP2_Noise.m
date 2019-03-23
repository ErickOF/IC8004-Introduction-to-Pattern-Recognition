clear;

pkg load image;


# Constantes a utilizar
D = 0.02;
M = 0;
SIGMA1 = 0.0005;
SIGMA2 = 0.0025;

# Leer imagen
img = imread('input/Lena.PNG');
# Convertir imagen a escala de grisis
gray_img = rgb2gray(img);

# Dar ruido a las imagenes
gray_img_noise1 = imnoise(gray_img, 'gaussian', M, SIGMA1);
gray_img_noise2 = imnoise(gray_img, 'gaussian', M, SIGMA2);
gray_img_noise3 = imnoise(gray_img, 'salt & pepper', D);

# Guardar imagenes con ruido
imwrite(gray_img, 'output/GrayLena.PNG');
imwrite(gray_img_noise1, 'output/NoisyLena1.PNG');
imwrite(gray_img_noise2, 'output/NoisyLena2.PNG');
imwrite(gray_img_noise3, 'output/NoisyLena3.PNG');
