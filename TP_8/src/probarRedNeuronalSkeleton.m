function probarRedNeuronal    
   probarMNIST;
end

function probarMNIST
    % Change the filenames if you've saved the files under different names
    % On some platforms, the files might be saved as 
    % train-images.idx3-ubyte / train-labels.idx1-ubyte
    %images = loadMNISTImages('train-images-idx3-ubyte.gz');
    %labels = loadMNISTLabels('train-labels-idx1-ubyte.gz');
    %tomado de http://www.cad.zju.edu.cn/home/dengcai/Data/MLData.html
    %contains variables 'fea', 'gnd', 'trainIdx' and 'testIdx'. Each row of 'fea' is a sample; 'gnd' is the label.
    load('2k2k.mat');
    a = fea(1,:);
    mat = vec2mat(a',28);
    figure; imagesc(mat);
    
end

function pruebaDatosR2
    [X, T] = generarDatosR2;
    %0.05 para pocas neuronas en la capa oculta
    %[2 25 1], 0.25, casi converge
    %inicializarRed([2 10 1], 0.1, 1);
    %ENTRE MAS NEURONAS EN LA CAPA OCULTA, MAS ALTO DEBE SER ALPHA
    redEj1 = inicializarRed([2 2 1], 0.01, 1);
    numIter = 10000;
    redEj1 = entrenarRed(numIter, X, T, redEj1);
end
 
function [X, T] = generarDatosR2
    %GRUPO 1
    mu = [2,10];
    sigma = [1,1.5;1.5,3];
    %rng default  % For reproducibility
    r = mvnrnd(mu,sigma,100);

    %GRUPO 2
    mu2 = [2,7];
    sigma2 = [1,1.5;1.5,3];
    %rng default  % For reproducibility
    r2 = mvnrnd(mu2,sigma2,50);

    figure
    plot(r(:,1),r(:,2),'+')
    hold on;
    plot(r2(:,1),r2(:,2),'*')

    values = [r; r2];
    targeta = zeros(100,1);
    targetb = ones(50,1);
    target = [targeta; targetb];
    X = values;
    T = target;


end



function y = evaluarMuestra(x, red)
    
    
end

function red = entrenarRed(numIter, X, T, red)
    
end


function numErrores = evaluarClasificacionesErroneas(X, T, red)    
    
   
end


function red = actualizarPesosSegunDeltas(red)
    
end



%Recibe un vector fila y lo asigna a las neuronas de entrada en la red
function red = asignarEntrada(x, red)
   
end


function red = asignarSalidaDeseada(t, red)
    
end

function red = calcularPasadaAtrasEnCapa(red, numCapa)
    

end

function red = calcularPasadaAdelanteEnCapa(red, numCapa)
    
end





%se supondra que la primer capa es la capa de entrada
function red = inicializarRed(numNeuronasPorCapa, alpha, maxPesosRand)
    
end

function y = sigmoid(x)
    y = 1/ (1 + exp(-x));
end