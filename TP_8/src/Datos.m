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

%SENO CON RUIDO
t = 0:.01:50;
y = sin(t) + 0.1 * randn(1, length(t));
y2 = sin(t);

figure
plot(y,'.')
hold on;
plot(y2)