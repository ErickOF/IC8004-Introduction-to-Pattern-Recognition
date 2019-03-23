clear;

# Constantes a utilizar
PATH1 = 'output/NoisyLena1.PNG';
PATH2 = 'output/NoisyLena2.PNG';
PATH3 = 'output/NoisyLena3.PNG';

# Cargar las imagenes
gray_img1 = imread(PATH1);
gray_img2 = imread(PATH2);
gray_img3 = imread(PATH3);

# Filtrar imagenes
gaussian_img1 = imsmooth(gray_img1, 'Gaussian');
gaussian_img2 = imsmooth(gray_img2, 'Gaussian');
gaussian_img3 = imsmooth(gray_img3, 'Gaussian');

# Guardar imagenes
imwrite(gaussian_img1, 'output/GaussianLena1.PNG');
imwrite(gaussian_img2, 'output/GaussianLena2.PNG');
imwrite(gaussian_img3, 'output/GaussianLena3.PNG');
