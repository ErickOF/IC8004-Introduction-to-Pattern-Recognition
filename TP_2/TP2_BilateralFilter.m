clear;

pkg load image;

#{
Funcion que filtra una imagen con el filtro bilateral
@param img - imagen en escala de grises
@param N - dimension de la ventana
@param sigma_r - desviacion estandar en el dominio de la intensidad
@return imagen filtrada
#}
function filtered_img = bilateral_filter(img, N, sigma_r)
  # Calcular desviacion espacial estandar
  sigma_s = (N - 1)/4;
  # Obtner las dimensiones de la imagen
  [ROWS, COLUMS] = size(img);
  MID = (N - 1)/2;
  # Padding de la imagen
  img = double(padarray(img, [MID MID], 0, 'symmetric'));
  # Crear matriz de ceros
  filtered_img = zeros(ROWS, COLUMS);
  # Crear el filtro de dominio espacial
  [X Y] = meshgrid(-MID:MID, -MID:MID);
  spacial_domain = exp(-(X.^2 + Y.^2)/(2*sigma_s^2));
  # Aplicar filtro
  for x=MID+1:ROWS+MID
    for y=MID+1:COLUMS+MID
      # Obtener la ventana de la imagen
      I = img(x - MID:x + MID, y - MID:y + MID);
      # Crear mascara
      intensity_domain = exp(-((I - img(x, y)).^2)/(2*sigma_r^2));
      bilateral_filter = spacial_domain .* intensity_domain;
      # Obtener el nuevo pixel
      pixel = sum(dot(I, bilateral_filter));
      # Normalizar pixel
      filtered_img(x-MID, y-MID) = pixel/sum(bilateral_filter(:));
    endfor
  endfor
  filtered_img = uint8(filtered_img);
endfunction


# Constantes a utilizar
SIGMA_R = 10;
WINDOW_SIZE = 5;
PATH1 = 'output/NoisyLena1.PNG';
PATH2 = 'output/NoisyLena2.PNG';
PATH3 = 'output/NoisyLena3.PNG';

# Cargar las imagenes
gray_img1 = imread(PATH1);
gray_img2 = imread(PATH2);
gray_img3 = imread(PATH3);


# Filtrar las imagenes con el filtro bilateral
tic;
bilateral_filtered_img1 = bilateral_filter(gray_img1, WINDOW_SIZE, SIGMA_R);
toc;

tic;
bilateral_filtered_img2 = bilateral_filter(gray_img2, WINDOW_SIZE, SIGMA_R);
toc;

tic;
bilateral_filtered_img3 = bilateral_filter(gray_img3, WINDOW_SIZE, SIGMA_R);
toc;

# Guardar imagenes
imwrite(bilateral_filtered_img1, 'output/BilateralLena1.PNG');
imwrite(bilateral_filtered_img2, 'output/BilateralLena2.PNG');
imwrite(bilateral_filtered_img3, 'output/BilateralLena3.PNG');
