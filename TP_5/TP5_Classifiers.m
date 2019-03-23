close all;
clear;

#{
Funcion que se encarga de separar el dataset de entrenamiento en 70% de muestras
de entrenamiento y 30% de muestras de validacion
@param X - dataset
@return las muestras de entrenamiento y de validacion como dos vectores
#}
function [Xtraining, Xvalidation] = separateData(X)
  N = size(X, 1);
  tf = false(N, 1);
  tf(1:round(0.7*N)) = true;
  tf = tf(randperm(N));
  Xtraining = X(tf,:);
  Xvalidation = X(~tf,:);
end

#{
Funcion que se encarga del entrenamiento del perceptron
@param C1n - muestras de la primera clase
@param C2n - muestras de la segunda clase
@param numIter - numero de iteraciones a realizar
@return los pesos W
#}
function W = perceptronTraining(C1n, C2n, numIter)
  # Matriz de pesos
  W = ones(1, 3);
  # Taza de aprendizaje
  alpha = 1;
  # Iterar para el aprendizaje
  for i=1:numIter
    # Iterar sobre la primera clase
    for j=1:size(C1n,1)
      # Predicion del perceptron
      prediction = (C1n(j,:) * W')* -1;
      # Validar prediction
      if (prediction < 0)
        W += alpha*(C1n(j,:))*(-1);
      end
    end
    # Iterar sobre la segunda clase
    for j=1:size(C2n,1)
      prediction = (C2n(j,:) * W');
      if (prediction < 0)
        W += alpha * (C2n(j,:));
      end
    end
  end    
end

#{
Funcion de activacion del perceptron
@param W - pesos del perceptron
@param x - muestra a validar
@return resultado de la evaluacion
#}
function f = perceptronActivationFunc(W, x)
  # Producto punto
  y = W * x';
  # Clasificar
  if y >= 0
    f = 1;
  else
    f = -1;
  end
end

#{
Implementacion del discriminante de Fisher
@param C1 - muestras de la primer clase
@param C2 - muestras de la segunda clase
@return los pesos W
#}
function w = fisherDA(C1, C2)
  # Means
  mu1 = mean(C1, 1);
  mu2 = mean(C2, 1);
  # Interclass covariance matrix
  D1 = double(C1 - repmat(mu1, size(C1, 1), 1));
  D2 = double(C2 - repmat(mu2, size(C2, 1), 1));
  Sw = D1'*D1 + D2'*D2;
  # Weights
  w = pinv(Sw) * (mu1 - mu2)';
end

#{
Funcion que calcula el resultado de la evalucion con los pesos de Fisher
@param W - pesos
@param x - muestra
@return resultado de la evaluacion
#}
function y = getYFish(W, x)
  # Producto punto
  y = W' * x';
end

#{
Funcion que evalua el algoritmo de minimos cuadrados
@param W - pesos
@param m - muestra
@return evaluacion del vector
#}
function y = getY(W, m)
  y = W' *  m';
  %w0 is the threshold used for decision
  y = y - W(1) >= 0;
end

#{
Funcion para obtener los pesos por minimos cuadrados
@param X - vector de muestras
@param T - vector de etiquetas
@return los pesos W
#}
function W = getW_leastSquares(X, T)
  W = ((X'*X)^-1)*X'*T;
end

#{
Funcion para aproximar el discriminante de Fisher
@param x - muestra
@return aproximacion del discriminante de Fisher
#}
function y = realDiscriminant(x)
  y = 2*x(1) - 2*x(2) - 2;
end

#{
Funcion que clasifica en dos clases un conjunto de muestras
@param N - dimensionalidad de las muestras
@param M - cantidad de muestras por clase
@param maxValues - arreglo con el valor maxima de los datos en cada dimension
@return las predicciones de los distintos algoritmos
#}
function [yResC1,yResC2,yC1Fish,yC2Fish,yC1nResPerc,yC2nResPerc]= twoClassesClassificationSkeleton(N, M, maxValues=[], separacion)
  [DIM] = size(maxValues);
  if DIM == 0
    maxValues = repmat([15], 1, N);
  elseif DIM != N
    return;
  end
  X = [];
  %N features, generated randomly
  for i=1:N
    X = [X maxValues(i)*rand(M, 1)];
  end
  % one sample per row
  c1 = 1;
  c2 = 1;
  t_i = 1;
  for i  = 1 : size(X, 1)
    Y(i, 1) = realDiscriminant(X(i, :)); 
    %If the distance from the real discriminant function is more than
    %5, is taken as a valid sample
    if(abs(Y(i, 1)) > separacion)
      %a sample per row, of dimension D = 2
      %with dummy input
      Xd(t_i, :) = [1 X(i, :)];
      %the output of the discriminant surface with the sample as an
      %input its positive, then belongs to Class 1
      if(Y(i, 1) > 0)
        C1(c1, :) =  X(i, :);
        c1 = c1 + 1;
        T(t_i) = 0;
      else           
        C2(c2, :) = X(i, :);
        c2 = c2 + 1;  
        T(t_i) = 1;
      end
      t_i = t_i + 1;
    end
  end
  %T is a column vector
  T = T';
  %plots the training samples
  figure;
  title('Training samples');
  scatter(C1(:,1), C1(:, 2), 'x');
  hold on;
  scatter(C2(:,1), C2(:, 2));
  %Calculates the least squares weight array
  W = getW_leastSquares(Xd, T);
  %test 1
  for i = 1:size(C1, 1)
    yResC1(i) = getY(W, [1 C1(i, :)]);
  end
  for i = 1:size(C2, 1)
    yResC2(i) = getY(W, [1 C2(i, :)]);
  end
  
  Yd = (W(1) - W(2)*Xd(:, 2))/W(3);
  %plots the decision boundary
  plot(Xd(:, 2), Yd);

  %fisher test
  C1n = [ones(size(C1, 1), 1) C1];
  C2n = [ones(size(C2, 1), 1) C2];
  %fisher evaluation
  Wfish = fisherDA(C1n, C2n);
  %threshold good choise would be the hyperplane between projections of the two means
  threshold = Wfish' * (0.5*(mean(C1n) + mean(C2n)))';
  for i = 1:size(C1, 1)
    yResC1Fish(i) = getYFish(Wfish, C1n(i, :));
  end
  for i = 1:size(C2, 1)
    yResC2Fish(i) = getYFish(Wfish, C2n(i, :));
  end

  figure;
  scatter(yResC1Fish, yResC1Fish, 'x');
  hold on;
  scatter(yResC2Fish, yResC2Fish);
  
  yC1Fish = yResC1Fish <= threshold;
  yC2Fish = yResC2Fish <= threshold;

  %perceptron test
  %perceptron needs T to be -1 or 1, not 0 or 1, needs to be corrected
  numIter = 1000;
  [C1ntraining, C1nvalidation] = separateData(C1n);
  [C2ntraining, C2nvalidation] = separateData(C2n);
  Wperc = perceptronTraining(C1ntraining, C2ntraining, numIter);
  for i = 1:size(C1nvalidation, 1)
    yC1nResPerc(i) = perceptronActivationFunc(Wperc, C1nvalidation(i, :));
  end
  for i = 1:size(C2nvalidation, 1)
    yC2nResPerc(i) = perceptronActivationFunc(Wperc, C2nvalidation(i, :));
  end
end

# Constants to use
N = 2;
M = 100;

# Promediando para sep = 0.05
for i=1:10
  [yResC1, yResC2, yC1Fish, yC2Fish, yC1nResPerc, yC2nResPerc] = twoClassesClassificationSkeleton(N, M, [], 0.05);
  yResC1Prom(i) = 1 - sum(yResC1)/size(yResC1, 2);
  yResC2Prom(i) = sum(yResC2)/size(yResC2, 2);
  yC1FishProm(i) = 1 - sum(yC1Fish)/size(yC1Fish, 2);
  yC2FishProm(i) = sum(yC2Fish)/size(yC2Fish, 2);
  yC1nResPerc(yC1nResPerc == 1) = 0;
  yC2nResPerc(yC2nResPerc == -1) = 0;
  yC1nResPercProm(i) = sum(-yC1nResPerc)/size(yC1nResPerc, 2);
  yC2nResPercProm(i) = sum(yC2nResPerc)/size(yC2nResPerc, 2);
end
printf('Separacion = 0.05\n');
printf('*Minimos cuadrados\n');
printf('**Clase1: %f\n', sum(yResC1Prom)/10);
printf('**Clase2: %f\n', sum(yResC2Prom)/10);
printf('*Fisher\n')
printf('**Clase1: %f\n', sum(yC1FishProm)/10);
printf('**Clase2: %f\n', sum(yC2FishProm)/10);
printf('*Perceptron\n');
printf('**Clase1: %f\n', sum(yC1nResPercProm)/10);
printf('**Clase2: %f\n\n', sum(yC2nResPercProm)/10);

# Promediando para sep = 1
for i=1:10
  [yResC1, yResC2, yC1Fish, yC2Fish, yC1nResPerc, yC2nResPerc] = twoClassesClassificationSkeleton(N, M, [], 1);
  yResC1Prom(i) = 1 - sum(yResC1)/size(yResC1, 2);
  yResC2Prom(i) = sum(yResC2)/size(yResC2, 2);
  yC1FishProm(i) = 1 - sum(yC1Fish)/size(yC1Fish, 2);
  yC2FishProm(i) = sum(yC2Fish)/size(yC2Fish, 2);
  yC1nResPerc(yC1nResPerc == 1) = 0;
  yC2nResPerc(yC2nResPerc == -1) = 0;
  yC1nResPercProm(i) = sum(-yC1nResPerc)/size(yC1nResPerc, 2);
  yC2nResPercProm(i) = sum(yC2nResPerc)/size(yC2nResPerc, 2);
end
printf('Separacion = 1\n');
printf('*Minimos cuadrados\n');
printf('**Clase1: %f\n', sum(yResC1Prom)/10);
printf('**Clase2: %f\n', sum(yResC2Prom)/10);
printf('*Fisher\n')
printf('**Clase1: %f\n', sum(yC1FishProm)/10);
printf('**Clase2: %f\n', sum(yC2FishProm)/10);
printf('*Perceptron\n');
printf('**Clase1: %f\n', sum(yC1nResPercProm)/10);
printf('**Clase2: %f\n\n', sum(yC2nResPercProm)/10);

# Promediando para sep = 5
for i=1:10
  [yResC1, yResC2, yC1Fish, yC2Fish, yC1nResPerc, yC2nResPerc] = twoClassesClassificationSkeleton(N, M, [], 5);
  yResC1Prom(i) = 1 - sum(yResC1)/size(yResC1, 2);
  yResC2Prom(i) = sum(yResC2)/size(yResC2, 2);
  yC1FishProm(i) = 1 - sum(yC1Fish)/size(yC1Fish, 2);
  yC2FishProm(i) = sum(yC2Fish)/size(yC2Fish, 2);
  yC1nResPerc(yC1nResPerc == 1) = 0;
  yC2nResPerc(yC2nResPerc == -1) = 0;
  yC1nResPercProm(i) = sum(-yC1nResPerc)/size(yC1nResPerc, 2);
  yC2nResPercProm(i) = sum(yC2nResPerc)/size(yC2nResPerc, 2);
end
printf('Separacion = 5\n');
printf('*Minimos cuadrados\n');
printf('**Clase1: %f\n', sum(yResC1Prom)/10);
printf('**Clase2: %f\n', sum(yResC2Prom)/10);
printf('*Fisher\n')
printf('**Clase1: %f\n', sum(yC1FishProm)/10);
printf('**Clase2: %f\n', sum(yC2FishProm)/10);
printf('*Perceptron\n');
printf('**Clase1: %f\n', sum(yC1nResPercProm)/10);
printf('**Clase2: %f\n', sum(yC2nResPercProm)/10);
