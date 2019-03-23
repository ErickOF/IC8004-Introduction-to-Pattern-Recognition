function kittler
  %abrimos la imagen
  img = rgb2gray(imread('input/cuadro1_005.bmp'));
  figure; imshow(img);
  title('Imagen original');
    
  %calculamos el histograma
  histograma = zeros(1, 256);
    
  for i = 1:size(img,1)
    for j = 1:size(img,2)
      z = img(i, j);
      histograma(z) = histograma(z) + 1; 
    end
  end
    
  histograma = histograma / (size(img,1) * size(img,2));
    
  %graficamos el histograma
  figure; plot(histograma);
  xlabel('Escala de grises, valor T');
  ylabel('Probabilidad p(T)');
    
  %umbral optimo por maxima verosimilitud con Kittler
  [T_optimo, paramKittler, J_s] = kittlerAlgorithm(histograma);
   
  %graficamos los J_s   
  figure; plot(0:1:length(J_s)-1,J_s);
  ylabel('J(T)');
  xlabel('Escala de grises, valor T');
    
  %Imagen umbralizada
  imageKittler = zeros(size(img));
  imageKittler(img > T_optimo) = 1;
  figure; imshow(imageKittler);
  title('Imagen umbralizada con Kittler');
    
  fprintf('T óptimo: %4.2f \n\nP1: %4.2f \nMu1: %4.2f \nVar1: %4.2f \n\nP2: %4.2f \nMu2: %4.2f \nVar2: %4.2f \n', T_optimo, paramKittler(1),paramKittler(2),paramKittler(3),paramKittler(4),paramKittler(5),paramKittler(6));
end

%Obtiene valor P_i
function P = get_P(histograma, a, b)
  P = sum(histograma(a:b));
end

%Calcula la media
function mu = get_Mu(histograma, a, b, P)    
  z = double(a:1:b);
  mu = sum(histograma(a:b) .* z) / double(P);
end

%Calcula la varianza
function varU = get_Var(histograma, a, b, P, mu)
  z = double(a:1:b);
  varU = sum(histograma(a:b) .* ((z - double(mu)).^2)) / double(P);
end

%kittler
function [T_optimo, paramKittler, J_s] = kittlerAlgorithm(histograma)
  J_optimo = 999;
  for T = 1:length(histograma)
    P_1 = get_P(histograma, 1, T);
    mu_1 = get_Mu(histograma, 1, T, P_1);
    var_1 = get_Var(histograma, 1, T, P_1, mu_1);

    P_2 = get_P(histograma, T + 1, 256);
    mu_2 = get_Mu(histograma, T + 1, 256, P_2);
    var_2 = get_Var(histograma, T + 1, 256, P_2, mu_2);    

    J_1 = P_1 * log(sqrt(var_1) + eps) + P_2 * log(sqrt(var_2) + eps);
    J_2 = P_1 * log(P_1 + eps) + P_2 * log(P_2 + eps);
        
    J = J_1 - J_2;
    J_s(T) = J;
        
    if(~isnan(J) && J < J_optimo)
      J_optimo = J;
      T_optimo = T;            
      paramKittler = [P_1  mu_1  var_1  P_2  mu_2  var_2];
    end
  end
end

function Th = applyThreshold(U, tau)
    
end
