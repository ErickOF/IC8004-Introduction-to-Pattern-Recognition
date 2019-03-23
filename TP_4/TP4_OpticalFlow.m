clear;
close all;


pkg load image;
pkg load signal

#{
Funcion que carga las imagenes
@return arreglo de imagenes
#}
function video = load_imgs()
  video = [];
  # Rutas de las imagenes
  img_name1 = 'input\animation\1.jpg';
  img_name2 = 'input\animation\2.jpg';
  # Cargar y concatenera imagenes
  video = cat(3, video, imread(img_name1));
  video = cat(3, video, imread(img_name2));
endfunction


#{
Funcion que muestra la imagen con el flujo optico
@param img - imagen que se le aplico el algoritmo
@param Vx - velocidad en x
@param Vy - velocidad en y
@parama name - nombre del grafico
#}
function display_plot(img, Vx, Vy, name)
    figure;
    axis equal;
    hold on;
    title(name);
    # Mostrar imagen
    imshow(impyramid(impyramid(img, 'reduce'), 'reduce'));
    # Mostrar vectores
    quiver(impyramid(impyramid(medfilt2(Vx, [5 5]), 'reduce'), 'reduce'), -impyramid(impyramid(medfilt2(Vy, [5 5]), 'reduce'), 'reduce'));
    hold off;
endfunction


#{
Funcion que calcula el flujo optico en un video
@param video - video al cual se le aplicara el algoritmo
@param N - dimensiones de la ventana
@param weight_window - tipo de ventana de pesado
#}
function [Vx Vy] = optical_flow(video, N, weight_window='none')
  tic;
  # Dimensiones de la imagen y cantidad de frames
  [ROWS, COLS, T] = size(video);
  # Mitad de la ventana
  MID = round((N-1)/2);
  # Ventana de pesado
  W = [];
  if strcmp(weight_window, 'gaussian')
    # Calculo de la ventana gaussiana
    sigma_s = (N-1)/2;
    if sigma_s == 0
      sigma_s = 0.5;
    endif
    NMID = round((N*N-1)/2);
    [X Y] = meshgrid(-NMID:NMID, -NMID:NMID);
    W = exp(-(X.^2 + Y.^2)/(sigma_s^2));
  elseif strcmp(weight_window, 'hamming')
    # Calculo de la ventana de Hamming
    H = window(@hamming, N*N);
    W = repmat(H, 1, N*N) .* repmat(H', N*N, 1);
  endif
  # Diferenciales
  dx = [-0.25 0.25; -0.25 0.25];
  dy = [-0.25 -0.25; 0.25 0.25];
  # Gradiente para el tiempo
  NABLA = [0.25 0.25; 0.25 0.25];
  # Velocidades
  Vx = zeros(ROWS, COLS, T);
  Vy = zeros(ROWS, COLS, T);
  # Recorrer todos los frames
  for k=1:T-1
    # Imagen en Tau y Tau + 1
    IT = video(:, :, k);
    IT1 = video(:, :, k + 1);
    # Derivadas parciales respecto a x, y, t
    IxT = conv2(IT, dx);
    IyT = conv2(IT, dy);
    It = conv2(IT, NABLA) + conv2(IT1, -NABLA);
    # Calculo de la velocidad en cada pixel
    for i = MID+1:ROWS-MID
      for j = MID+1:COLS-MID
        # Metodo de Lucas Kanade
        A = [IxT(i-MID:i+MID, j-MID:j+MID)(:) IyT(i-MID:i+MID, j-MID:j+MID)(:)];
        b = -It(i-MID:i+MID, j-MID:j+MID)(:);
        # Obtencion de la velocidad
        velocity = [];
        if strcmp(weight_window, 'none')
          AT = A';
          velocity = pinv(AT*A)*AT*b;
        else
          ATW = (A')*W;
          velocity = pinv(ATW*A)*(ATW*b);
        endif
        Vx(i, j, k) = velocity(1);
        Vy(i, j, k) = velocity(2);
      endfor
    endfor
  endfor
  toc;
  # Graficacion del flujo optico
  for i=1:T-1
    name = ['Ventana de ' num2str(N) 'x' num2str(N)];
    if strcmp(weight_window, 'gaussian')
      name = [name ' con filtro Gaussiano'];
    elseif strcmp(weight_window, 'hamming')
      name = [name ' con filtro de Hamming'];
    else
      name = [name ' sin filtro'];
    endif
    display_plot(video(:, :, i), Vx(:, :, i), Vy(:, :, i), name);
  endfor
endfunction


# Cargar datos
video = load_imgs();
result = load('src/resultado.mat').B;
# Pruebas para distintas dimensiones de imagenes sin fintro
#[Vx1 Vy1] = optical_flow(video, 1);
#[Vx3 Vy3] = optical_flow(video, 3);
#[Vx9 Vy9] = optical_flow(video, 9);
#[Vx21 Vy21] = optical_flow(video, 21);
# Pruebas para distintas dimensiones de imagenes con filtro Gaussiana
#[VxG1 VyG1] = optical_flow(video, 1, 'gaussian');
#[VxG3 VyG3] = optical_flow(video, 3, 'gaussian');
#[VxG9 VyG9] = optical_flow(video, 9, 'gaussian');
#[VxG21 VyG21] = optical_flow(video, 21, 'gaussian');
# Pruebas para distintas dimensiones de imagenes con filtro de Hamming
#[VxH1 VyH1] = optical_flow(video, 1, 'hamming');
#[VxH3 VyH3] = optical_flow(video, 3, 'hamming');
#[VxH9 VyH9] = optical_flow(video, 9, 'hamming');
[VxH21 VyH21] = optical_flow(video, 21, 'hamming');
