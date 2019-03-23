clear;
close all;

pkg load statistics

i_train = 1;
i_test = 1;

for d = 1:41
    path = strcat('input/s', num2str(d));
    idx = datasample(1:10,2,'Replace',false);
    for k = 1:10
        filename = strcat(path,'/',num2str(k),'.pgm');
        image = imread(filename);
        if ismember(k,idx)
            X_test(i_test,:) = image(:);
            Y_test(i_test,:) = d;
            i_test = i_test + 1;
        else
            X_train(i_train,:) = image(:);
            Y_train(i_train,:) = d;
            i_train = i_train + 1;
        end
    end
end

% Preparando datos de entrenamiento
len_test = size(X_test);
len_train = size(X_train);

mu = mean(X_train);
mu_vec = repmat (mu, len_train(1) , 1);

D = double(X_train - uint8(mu_vec));

% Preparando datos de prueba
mu_test = mean(X_test);
mu_vec = repmat (mu_test, len_test(1) , 1);

D_t = double(X_test - uint8(mu_vec));

% Nuevo espacio generado
sigma_V = (1/(len_train(1)-1)) * (D * D.');
[V,Lambda] = eig(sigma_V);

W = V * D;

N = [0.1 0.3 0.5 0.7 0.9]; % Porcentajes de autovectores a utilizar.

nw_W = [];

acc_KNN_E = [];
acc_KNN_M = [];
acc_Clustering_E = [];
acc_Clustering_M = [];

for n = 1:5    
    cant_vectores = int16(len_train(1) * N(n));
    Lambda_aux = max(Lambda);
    
    nw_W = [];

    for i = 1:cant_vectores
        [A, I] = max(Lambda_aux);
        nw_W(i,:) = W(I,:);
        Lambda_aux(I) = [];
    end

    % Proyección en el nuevo espacio
    D_prime = D * nw_W';
    D_test = D_t * nw_W';

    % KNN
    K = [2 5 7 10]; % K vecinos a comparar
    
    for k = 1:4
        knn_E = [];
        knn_M = [];
        predicted_Y_E = [];
        predicted_Y_M = [];
        
        for i = 1:len_test(1)
            X = D_test(i,:);
            distancesE = pdist2(D_prime,X); % Euclideana
            distancesM = pdist2(D_prime,X,'minkowski',1); % Manhattan
            %distancesM = pdist2(D_prime,X,'mahalanobis'); % Mahalanobis

            for j = 1:K(k)
                [A, I] = min(distancesE);
                knn_E(j,:) = Y_train(I);
                distancesE(I) = [];
                
                [A, I] = min(distancesM);
                knn_M(j,:) = Y_train(I);
                distancesM(I) = [];
                
            end

            predicted_Y_E(i,:) = mode(knn_E);
            predicted_Y_M(i,:) = mode(knn_M);
        end

        aciertos = predicted_Y_E - Y_test;
        aciertos(aciertos ~= 0) = 1;
        total_E = sum(~aciertos);

        aciertos = predicted_Y_M - Y_test;
        aciertos(aciertos ~= 0) = 1;
        total_M = sum(~aciertos);

        acc_KNN_E(n,k) = total_E * 100 / len_test(1);
        acc_KNN_M(n,k) = total_M * 100 / len_test(1);
    end

    % Clustering
    
    % Preparando centroides
    centroids = [];
    predicted_Y_E = [];
    predicted_Y_M = [];
    
    for i = 1:41
       idx = Y_train == i;
       cluster = D_prime(idx,:);
       centroids(i,:) = mean(cluster);
    end

    for i = 1:len_test(1)
        X = D_test(i,:);
        distancesE = pdist2(centroids,X); % Euclideana
        distancesM = pdist2(centroids,X,'minkowski',1); % Manhattan

        [A, I] = min(distancesE);
        predicted_Y_E(i,:) = I;
        
        [A, I] = min(distancesM);
        predicted_Y_M(i,:) = I;
    end

    aciertos = predicted_Y_E - Y_test;
    aciertos(aciertos ~= 0) = 1;
    total_E = sum(~aciertos);
    
    aciertos = predicted_Y_M - Y_test;
    aciertos(aciertos ~= 0) = 1;
    total_M = sum(~aciertos);

    acc_Clustering_E(n,:) = total_E * 100 / len_test(1);
    acc_Clustering_M(n,:) = total_M * 100 / len_test(1);
end

plot(N,acc_KNN_E(:,1));
plot(N,acc_KNN_M(:,1));
plot(N,acc_Clustering_E);
plot(N,acc_Clustering_M);

save('train.mat','X_test', 'Y_test', 'X_train', 'Y_train');
