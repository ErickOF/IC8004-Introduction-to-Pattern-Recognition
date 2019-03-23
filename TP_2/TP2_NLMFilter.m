clear;

pkg load image;

#{
Funcion que filtra una imagen con el filtro de promediado no local
@param img - imagen en escala de grises
@param N - dimensiones de la ventana
@param similarity_window - dimensiones de la ventana de similitud
@param h - desviacion estandar en el dominio de similitud de vecindarios
@return imagen filtrada
#}
function filtered_img = nlm_filter(img, N, similarity_window, h)
  # Obtner las dimensiones de la imagen
  [ROWS, COLUMS] = size(img);
  # Crear matriz de ceros
  filtered_img = zeros(ROWS, COLUMS);
  # Mitad de cada ventana
  MID_SIZE = (N-1)/2;
  MID_SIMILARITY = (similarity_window - 1)/2;
  # Padding de la imagen
  img = double(padarray(img, [MID_SIZE MID_SIZE], 'symmetric'));
  # Filtrado
  for i=MID_SIZE+1:ROWS+MID_SIZE
    for j=MID_SIZE+1:COLUMS+MID_SIZE
      W1 = img(i-MID_SIZE:i+MID_SIZE , j-MID_SIZE:j+MID_SIZE);
      umin = max(i - MID_SIMILARITY, MID_SIZE + 1);
      umax = min(i + MID_SIMILARITY, ROWS + MID_SIZE);
      vmin = max(j - MID_SIMILARITY, MID_SIZE + 1);
      vmax = min(j + MID_SIMILARITY, COLUMS + MID_SIZE);
      normalization_factor = 0;
      # Filtrar a traves de la ventanan de similitud
      for u=umin:umax
        for v=vmin:vmax
          W2 = img(u-MID_SIZE:u+MID_SIZE, v-MID_SIZE:v+MID_SIZE);
          # Similitud entre los pixeles
          similarity = exp(-norm(W1(:) - W2(:))/(h^2));
          normalization_factor += similarity;
          filtered_img(i-MID_SIZE, j-MID_SIZE) += similarity * img(u, v);
        endfor
      endfor
      # Normalizacion del valor
      filtered_img(i-MID_SIZE, j-MID_SIZE) /= normalization_factor;
    endfor
  endfor
  filtered_img = uint8(filtered_img);
endfunction


# Constantes a utilizar
PATH1 = 'output/NoisyLena1.PNG';
PATH2 = 'output/NoisyLena2.PNG';
PATH3 = 'output/NoisyLena3.PNG';
SIGMA_R = 15;
SIMILARITY_WINDOW = 7;
WINDOWS_SIZE = 9;

# Cargar las imagenes
gray_img1 = imread(PATH1);
gray_img2 = imread(PATH2);
gray_img3 = imread(PATH3);

# Filtrar imagen con el filtro Non Local Mean
tic;
nlm_filtered_img1 = nlm_filter(gray_img1, WINDOWS_SIZE, SIMILARITY_WINDOW, SIGMA_R);
toc;

tic;
nlm_filtered_img2 = nlm_filter(gray_img2, WINDOWS_SIZE, SIMILARITY_WINDOW, SIGMA_R);
toc;

tic;
nlm_filtered_img3 = nlm_filter(gray_img3, WINDOWS_SIZE, SIMILARITY_WINDOW, SIGMA_R);
toc;

# Guardar las imagenes
imwrite(nlm_filtered_img1, 'output/NLMLena1.PNG');
imwrite(nlm_filtered_img2, 'output/NLMLena2.PNG');
imwrite(nlm_filtered_img3, 'output/NLMLena3.PNG');
