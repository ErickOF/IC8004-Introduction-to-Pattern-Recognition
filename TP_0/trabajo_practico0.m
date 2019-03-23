clear;

#{---------------------------------2.VECTORES--------------------------------}#

# 1.a) Graficacion de los vectores con quiver3
#{
Funcion que grafica en 3D un vector dado
@param u - vector a graficar
@param nombre - nombre del vector a graficar
@return No retorna
#}
function graficar_vector (u, name="vector")
    hold on
    figure(1);
    # Graficar el vector de 3 dimensiones
    quiver3(0, 0, 0, u(1), u(2), u(3));
    # Colocar un nombre al vector
    text(u(1), u(2), u(3), name);
    # Colocar el nombre de los ejes
    xlabel("x");
    ylabel("y");
    zlabel("z");
    
    hold off
endfunction

# 1.d) Calculo del angulo entre los vectores
#{
Funcion que calcula el angulo entre dos vectores de n dimensiones
@param u - primer vector
@param v - segundo vector
@return El angulo entre los dos vectores en grados
#}
function angulo_grados = calcular_angulo (u, v)
    # Calcular la norma de los vectores
    norma_u = norm(u);
    norma_v = norm(v);
    # Calcular el producto punto entre los vectores
    u_punto_v = dot(u, v);
    # Calcular el angulo en radianes entre los vectores
    angulo = acos(u_punto_v / (norma_u * norma_v));
    # Convertir el angulo a grados
    angulo_grados = angulo * 180 / pi;
endfunction

# 1.e) Calculo de la distancia l1, l2 y linf entre los vectores
#{
Funcion que calcula la distancia l1 o norma de Mahattan entre dos vectores
@param u - primer vector
@param v - segundo vector
@return Distancia l1 o norma de Manhattan entre los vectores
#}
function distancia = norma_l1 (u, v)
    distancia = sum(abs(u - v));
endfunction

#{
Funcion que calcula la distancia l2 o norma Euclidiana entre dos vectores
@param u - primer vector
@param v - segundo vector
@return Distancia l2 o norma Euclidiana entre los vectores
#}
function distancia = norma_l2 (u, v)
    # Calcular la diferencia entre los vectores
    resta = abs(u - v);
    # Calcular la distancia Euclidiana
    distancia = sqrt(sum(resta.^2));
endfunction

#{
Funcion que calcula la distancia lp entre dos vectores
@param u - primer vector
@param v - segundo vector
@param p - valor de la norma. Por defecto l = 1
@return Distancia lp entre los vectores
#}
function distancia = norma_lp (u, v, p=1)
    # Calcular la diferencia entre los vectores
    resta = abs(u - v);
    # Verificar si la norma es l infinito
    if p == inf
        # Obtener el valor mayor del vector
        distancia = max(resta);
        return;
    end
    # Calcular la distancia lp
    distancia = sum(resta.^p)^(1/p);
endfunction

#{
Funcion que calcula la distancia linf entre dos vectores
@param u - primer vector
@param v - segundo vector
@return El maximo valor de la resta de las componentes de los vectores en valor
        absoluto
#}
function distancia = norma_linf (u, v)
    distancia = max(abs(u - v));
endfunction


#{-------------------------3.FUNCIONES MULTIVARIABLES------------------------}#

# 1.a Graficacion de planos usando la función surf
#{
Funcion que grafica un plano dado
@param w - valores constantes
@param inicio - minimo valor desde el cual se inicia el grafico
@param fin - maximo valor del grafico
@param paso - cada cuanto se genera un nuevo punto
@param nombre - nombre del plano a graficar
@return No retorna
#}
function graficar_plano (w, inicio=-1, fin=1, paso=0.1, nombre="plain")
    hold on
    figure(2);
    # Creacion del meshgrid
    x = inicio:paso:fin;
    [X, Y] = meshgrid(x);
    # Calcular el valor de Z
    Z = cat(3, X.*w(1), Y.*w(2));
    Z = sum(Z, 3);
    # Graficar el plano
    surf(X, Y, Z);
    # Dar nombre a los ejes
    xlabel("x");
    ylabel("y");
    zlabel("z");
    
    hold off
endfunction

# 2
function multiVar2()
  #Generación del meshgrid
  x = -10:0.1:10;
  [X,Y] = meshgrid (x) ;
  #Función a)
  Z = 3*(X .^ 3).*(Y .^ 2);
  #Graficación de la función a) y los vectores unitarios
  figure(3);
  surf(X,Y,Z) ;
  hold on;
  figure(4);
  quiver3(0, 0, -1, "y");
  quiver3(0.78733, -0.61653, -1, "r");


  xlabel ("x");
  ylabel ("y");
  zlabel ("z");
  title ("Funcion a) y sus vectores gradiente");
  hold off;



  #Generación del meshgrid
  x = -50:1:50;
  [X,Y] = meshgrid (x) ;
  #Función b
  Z = exp(X) + exp(Y) + 2*X.*X + 4*Y +3;

  figure(5);
  surf(X,Y,Z);
  hold on;
  quiver3(0.986, 0.165, -1, "y")
  quiver3(0.426, 0.905, -1, "r");
  hold off;

  xlabel ("x");
  ylabel ("y");
  zlabel ("z");
  title ("Funcion b) y sus vectores gradiente");
  #


  #Generación del meshgrid
  x = -50:1:50;
  [X,Y] = meshgrid (x) ;
  #Función b
  Z = log(X.*X + Y.*Y);

  figure(6);
  surf(X,Y,Z);
  hold on;
  quiver3(-0.335, 0.942, -1, "y")
  quiver3(0, 1, -1, "r");
  hold off;

  xlabel ("x");
  ylabel ("y");
  zlabel ("z");
  title ("Funcion c) y sus vectores gradiente");
  #


  #Generación del meshgrid
  x = -50:1:50;
  [X,Y] = meshgrid (x) ;
  #Función b
  Z = (X.*X + Y.*Y).^(0.5);

  figure(7);
  surf(X,Y,Z);
  hold on;
  quiver3(0.63, 0.776, -1, "y")
  quiver3(0.914, 0.404, -1, "r");
  hold off;

  xlabel ("x");
  ylabel ("y");
  zlabel ("z");
  title ("Funcion d) y sus vectores gradiente");
  #
endfunction


#{---------------------------------4.MATRICES--------------------------------}#
# 3.c) Calculo de la proyeccion del vector en los ub-espacios vectoriales
# espacioGenerado(A) y espacioGenerado(B)
function mat3()
  # Vector y
  y = [1; 2; 3;];
endfunction

# 4) Auto vectores y auto valores
function mat4
  #Definición de la matriz sobre la cual se trabaja
  fprintf("a)Matriz sugerida en el trabajo: \n");
  mat = [9 13 3 6; 13 11 7 6; 3 7 4 7; 6 6 7 10]

  #a)btención de los autovalores y autovectores
  fprintf("Sus autovectores y autovalores: \n");
  [eigVect, eigVals] = eig(mat)


  #b)Comprobación de la ortonormalidad
  if (rank(eigVect) == 4)
    fprintf("b)Todos su autovectores son ortonormales pues es de rango completo \n");
  endif

  #c) Vectores columna paralelos
  fprintf("c)Matriz paralela seleccionada: \n");
  matParal = [1 4 ; 1 4]
  fprintf("Sus autovectores y autovalores: \n");
  [eigVectParal, eigValsParal] = eig(matParal)
  fprintf("El rango de la matriz paralela es: %i \n", rank(matParal));


  #d) Vectores columna ortogonales
  fprintf("d)Matriz ortogonal seleccionada: \n");
  matOrt = [0 3; 3 0]
  fprintf("Sus autovectores y autovalores: \n");
  [eigVectOrt, eigValsOrt] = eig(matOrt)
  fprintf("El rango de la matriz ortogonal es: %i \n", rank(matOrt));

  #e) Vectores columna ortogonales 5 veces más grande
  fprintf("e)Matriz ortogonal 5 veces más grande seleccionada: \n");
  matOrt5 = [0 1; 5 0]
  fprintf("Sus autovectores y autovalores: \n");
  [eigVectOrt5, eigValsOrt5] = eig(matOrt5)
  fprintf("El rango de la matriz ortogonal5 es: %i \n", rank(matOrt5));
endfunction


#{------------------------------------Test-----------------------------------}#

# Vectores a utiliar
vector1 = [-0.3 0.8 0.2];
vector2 = [0.5 0.2 0.4];
vector3 = [1/sqrt(2) -1/sqrt(2) 0];

w1 = [0.5 0.2];
w2 = [-0.1 0.05];

# 2. VECTORES
# 1.a) Graficar vectores
graficar_vector(vector1, "v1");
graficar_vector(vector2, "v2");
graficar_vector(vector3, "v3");

# 1.d) Calcular el angulo entre los vectores
printf("1.d) Calcular el angulo entre los vectores:\n");
printf("Angulo entre v1 y v2 = %3.2f°\n", calcular_angulo(vector1, vector2));
printf("Angulo entre v1 y v3 = %3.2f°\n", calcular_angulo(vector1, vector3));
printf("Angulo entre v2 y v3 = %3.2f°\n\n", calcular_angulo(vector2, vector3));

# 1.e) Calcule la distancia l1, l2 y linf entre los vectores
printf("1.e) Calcule la distancia l1, l2 y linf entre los vectores:\n");
printf("La norma l1 entre v1 y v2 es %f°\n", norma_lp(vector1, vector2, 1));
printf("La norma l1 entre v1 y v3 es %f°\n", norma_l1(vector1, vector3));
printf("La norma l1 entre v2 y v3 es %f°\n", norma_l1(vector2, vector3));

printf("La norma l2 entre v1 y v2 es %f°\n", norma_lp(vector1, vector2, 2));
printf("La norma l2 entre v1 y v3 es %f°\n", norma_l2(vector1, vector3));
printf("La norma l2 entre v2 y v3 es %f°\n", norma_l2(vector2, vector3));

printf("La norma linf entre v1 y v2 es %f°\n", norma_lp(vector1, vector2, inf));
printf("La norma linf entre v1 y v3 es %f°\n", norma_linf(vector1, vector3));
printf("La norma linf entre v2 y v3 es %f°\n", norma_linf(vector2, vector3));

# 3. FUNCIONES MULTIVARIABLES
#1.a Graficacion de planos usando la función surf
graficar_plano (w1, -2, 2, 0.5, "p1");
graficar_plano (w2, -2, 2, 0.5, "p2");

# 2
multiVar2();

# 4. MATRICES
# 3.c) Calculo de la proyeccion del vector en los ub-espacios vectoriales
# espacioGenerado(A) y espacioGenerado(B)
mat3();
# 4) Auto vectores y auto valores
mat4();
