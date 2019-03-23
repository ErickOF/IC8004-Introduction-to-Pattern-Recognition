clear;

# Constantes
PATH = 'input';

#{
Funcion que carga todas las images de una ruta dada.
@param path - ruta de las imagenes
@retun matriz con las imagenes cargadas
#}
function imgs = load_all_imgs(path)
  # Ruta completa
  paths = fullfile(path, 's*');
  # Obtener las carpetas dentro
  base_filenames = dir(paths);
  imgs = [];
  for i=1:length(base_filenames)
    # Obtener las rutas de las imagenes
    folder_name = fullfile(path, base_filenames(i).name);
    folder = fullfile(folder_name, '*.pgm');
    full_filenames = dir(folder);
    # Cargar las imagenes de las carpetas
    for j=1:length(full_filenames)
      img_name = fullfile(folder_name, full_filenames(j).name);
      imgs = [imgs imread(img_name)(:)];
    endfor
  endfor
endfunction

#{
Funcion que calcula la matriz de covarianza
@param X - conjunto de datos como matriz
@return matriz de covarianza
#}
function [Sigma D] = covariance_matrix(X)
  # Obtener las dimensiones de la matriz de imagenes
  [N M] = size(X);
  
endfunction

# Cargar todas las imagenes de pruebas
tic;
imgs = load_all_imgs(PATH);
[N M] = size(imgs);
mu = mean(imgs')';
D = double(imgs - repmat(mu, 1 ,  M));
Sigma = (1/(N-1))*(D')*D;
toc;
