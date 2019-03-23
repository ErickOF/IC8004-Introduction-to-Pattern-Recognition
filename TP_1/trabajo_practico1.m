clear;

pkg load image;

# Constantes
MEAN = 0;
VARIANCE = 0.005;
DENSITY = 0.003;

#{---------------------------------Funciones---------------------------------}#
#{
Funcion que contamina una imagen en escala de grises dada con ruido gaussiano e
impulsivo.
@param img - imagen a la que se le desea aplicar el ruido
@param mean - promedio del ruido
@param variance - varianza del ruido
@param density - porcentaje de pixeles afectados por el ruido. Valor entre 0 y 1
@return imagen contaminada
#}
function noisy_img = gaussian_noise(img, mean, variance, density)
  # Aplicar ruido gaussiano
  gaussian_noisy_img = imnoise(img, 'gaussian', mean, variance);
  # Aplicar ruido impulsivo
  noisy_img = imnoise(gaussian_noisy_img, 'salt & pepper', density);
endfunction

#{
Funcion que recibe una imagen y retorna un arreglo con las ocurrencias de los
pixeles normalizados.
@param img - imagen a la que se le desea contar los pixeles
@return arreglo con las ocurrencias de los pixeles normalizados
#}
function pixels_array = calculate_histogram(img)
  # Obtener la cantidad de pixeles en la imagen
  [rows, columns] = size(img);
  img_size = rows * columns;
  # Crear un array de pixeles para guardar las ocurrencias
  pixels_array = zeros(1, 256);
  # Ciclo para contar la ocurrencia de cada pixel
  for i=1:256
    pixels_array(i) = sum(sum(img==(i - 1)));
  endfor
  # Normalizar los pixeles de la imagen
  pixels_array ./= img_size;
endfunction

#{
Funcion que recibe una imagen y la recorta.
@param x - posicion inicial en x de la imagen
@param y - posicion inicial en y de la imagen
@param sizex - cantidad de pixeles que se toman al rededor de las filas
@param sizey - cantidad de pixeles que se toman al rededor de las columnas
@return imagen recortada
#}
function cut = cut_img(img, x, y, sizex, sizey)
  cut = img(x - sizex:x + sizex, y - sizey:y + sizey);
endfunction

#{
Funcion que se encarga de graficar un histograma
@param x - eje x del grafico
@param y - eje y del grafico
@param name - nombre del grafico
@param fig_num - numero de la figura donde se graficara
@return None
#}
function plot_histogram(x, y, name, fig_num)
  figure(fig_num);
  plot(x, y);
  title(name);
  xlabel('numero de pixel');
  ylabel('frecuencia normalizada del pixel');
endfunction

#{------------------------------------Test------------------------------------}#
# 1. Leer las imagenes
example_img = imread('inputs\example.jpg');
seeds_img = imread('inputs\semillas.PNG');

# 2. Convertir las imagenes a escala de grises
gray_example_img = rgb2gray(example_img);
gray_seeds_img = rgb2gray(seeds_img);

# 3. Contaminar las imagenes
noisy_example_img = gaussian_noise(gray_example_img, MEAN, VARIANCE, DENSITY);
noisy_seeds_img = gaussian_noise(gray_seeds_img, MEAN, VARIANCE, DENSITY);
# Guardar las imagenes
imwrite(noisy_example_img, 'outputs\noisy_example.jpg');
imwrite(noisy_seeds_img, 'outputs\semillas_con_ruido.PNG');

# 4. Calcular el histograma
example_pixels_array = calculate_histogram(gray_example_img);
seeds_pixels_array = calculate_histogram(gray_seeds_img);

# 5. Recorta tres regiones uniformes de las imagenes
cut_example_img1 = cut_img(noisy_example_img, 150, 150, 100, 100);
cut_example_img2 = cut_img(noisy_example_img, 250, 250, 100, 100);
cut_example_img3 = cut_img(noisy_example_img, 350, 250, 100, 100);
cut_seeds_img1 = cut_img(noisy_seeds_img, 151, 151, 100, 100);
cut_seeds_img2 = cut_img(noisy_seeds_img, 151, 251, 100, 100);
cut_seeds_img3 = cut_img(noisy_seeds_img, 251, 151, 100, 100);
# Guardar las imagenes
imwrite(cut_example_img1, 'outputs\cut_example1.jpg');
imwrite(cut_example_img2, 'outputs\cut_example2.jpg');
imwrite(cut_example_img3, 'outputs\cut_example3.jpg');
imwrite(cut_seeds_img1, 'outputs\semillas_recorte1.PNG');
imwrite(cut_seeds_img2, 'outputs\semillas_recorte2.PNG');
imwrite(cut_seeds_img3, 'outputs\semillas_recorte3.PNG');
# Calcular el histograma
cut_example_img1_histogram = calculate_histogram(cut_example_img1);
cut_example_img2_histogram = calculate_histogram(cut_example_img2);
cut_example_img3_histogram = calculate_histogram(cut_example_img3);
cut_seeds_img1_histogram = calculate_histogram(cut_seeds_img1);
cut_seeds_img2_histogram = calculate_histogram(cut_seeds_img2);
cut_seeds_img3_histogram = calculate_histogram(cut_seeds_img3);
# Graficar el histograma
pixels = 0:255;
plot_histogram(pixels, cut_example_img1_histogram,
              'Imagen <example.jpg> primer corte', 1);
plot_histogram(pixels, cut_example_img2_histogram,
              'Imagen <example.jpg> segundo corte', 2);
plot_histogram(pixels, cut_example_img3_histogram,
              'Imagen <example.jpg> tercer corte', 3);
plot_histogram(pixels, cut_seeds_img1_histogram,
              'Imagen <seeds.PNG> primer corte', 4);
plot_histogram(pixels, cut_seeds_img2_histogram,
              'Imagen <seeds.PNG> segundo corte', 5);
plot_histogram(pixels, cut_seeds_img3_histogram,
              'Imagen <seeds.PNG> tercer corte', 6);
