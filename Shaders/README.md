

# Taller de shaders

## Propósito

Estudiar los [patrones de diseño de shaders](http://visualcomputing.github.io/Shaders/#/4).

## Tarea

Escoja una de las siguientes dos:

1. Hacer un _benchmark_ entre la implementación por software y la de shaders de varias máscaras de convolución aplicadas a imágenes y video.
2. Estudiar e implementar el [shadow mapping](http://www.opengl-tutorial.org/intermediate-tutorials/tutorial-16-shadow-mapping/). Se puede emplear la escena del [punto 2 del taller de transformaciones](https://github.com/VisualComputing/Transformations_ws), así como la librería [frames](https://github.com/VisualComputing/frames). Ver el ejemplo [ShadowMap](https://github.com/VisualComputing/frames/tree/master/examples/demos/ShadowMap).

## Integrantes

Máximo tres.

Complete la tabla:

| Integrante | github nick |
|------------|-------------|
|            |             |

## Informe

(elabore en este sección un informe del ejercicio realizado)


## Ejecucion




Para las graficas se necesita instalar GNUPLOT

Dentro de la carpeta se encuentran 3 imagenes png (4k.png 1080.png 720.png ), dos programas en c (blur-effect.c ,speedup.c  ),  un ejecutable ( scripfin.sh ) y una carpeta de nombre results  la cual guardara todos los datos finales y donde se encontraran 6 archivos los cuales seran los scrips para realizar las graficas una vez corrido el ejecutable. 

Una vez corrido el ejecutable se crearan todos los registros de los resultados en la carpeta results y en la misma carpeta en donde se encuentra el ejecutable se crearan 7 versiones de cada imagen (4kk3.png...4kk15.png .. etc..), donde el nombre de la imagen estara acompañada del tamaño del kernel que se uso para poner borrosa la imagen.

blur-effect.c
	Compilacion de blur-effect.c : // programa principal , donde se encuentra el algoritmo de poner borrosa la imagen
		gcc blur-effect.c -lpng -pthread -o blur-effect
	Ejecucion de blur-effect :
		./blur-effect 1080.png 1080k3.png 3 5 2;
		Donde:
			1080.png: es la imagen png a tomar para aplicarle el efecto borroso.
			1080k3.png:  es el nombre de la imagen resultado.
			3 :  Es  tamaño del kernel a tomar (3,5,7,9,11,13,15)
			5 :  Es el numero de hilos 

blur-effect-omp.c
	Compilacion de blur-effect-omp.c : // programa principal , donde se encuentra el algoritmo de poner borrosa la imagen
		gcc blur-effect-omp.c  -lpng -fopenmp -o  blur-effect-omp
	Ejecucion de blur-effect :
		./blur-effect-omp 1080.png 1080k3.png 3 5 3;
		Donde:
			1080.png: es la imagen png a tomar para aplicarle el efecto borroso.
			1080k3.png:  es el nombre de la imagen resultado.
			3 :  Es  tamaño del kernel a tomar (3,5,7,9,11,13,15)
			5 :  Es el numero de hilos
			2 :  Es la resolucion de la imagen ( 1 -> 4k , 2 -> 1080p , 3 -> 720p) //este campo se usa solo para guardar de forma adecuada los datos resultado

gpu.cu
	Compilacion de gpu.cu : // programa principal , donde se encuentra el algoritmo de poner borrosa la imagen usando cuda
		make
	Ejecucion de blur-effect :
		./gpu 1080.png 1080k3.png 3 5 3;
		Donde:
			1080.png: es la imagen png a tomar para aplicarle el efecto borroso.
			1080k3.png:  es el nombre de la imagen resultado.
			3 :  Es  tamaño del kernel a tomar (3,5,7,9,11,13,15)
			5 :  Es el numero de hilos
			2 :  Es la resolucion de la imagen ( 1 -> 4k , 2 -> 1080p , 3 -> 720p) //este campo se usa solo para guardar de forma adecuada los datos resultado



speedup.c
	Compilacion de speedup.c : // este programa es utilizado para hallar los speedup. 
	  	 gcc speedup.c  -o speedup
	Ejecucion de speedup :
		./speedup
speedupomp.c
	Compilacion de speedupomp.c : // este programa es utilizado para hallar los speedup. 
	  	 gcc speedupomp.c  -o speedupomp
	Ejecucion de speedupomp :
		./speedupomp
speedupgpu.c
	Compilacion de speedupgpu.c : // este programa es utilizado para hallar los speedup. 
	  	 gcc speedupgpu.c  -o speedupgpu
	Ejecucion de speedupgpu :
		./speedupgpu

posix.sh
	Este ejecutable , corre el programa  de efecto borroso con todos los kernels (3,5,7,9,11,13,15),variando el numero de hilos (1-16) para cada uno. Solo basta correr este ejecutable para ver todos los resultados, este ejecutara a blur-effect.c   y luego que halla terminado todas las ejecuciones a este programa, ejecutara a speedup.c para los resultados finales .

omp.sh
	Este ejecutable , corre el programa  de efecto borroso con todos los kernels (3,5,7,9,11,13,15),variando el numero de hilos (1-16) para cada uno. Solo basta correr este ejecutable para ver todos los resultados, este ejecutara a blur-effect-omp.c  y luego que halla terminado todas las ejecuciones a este programa, ejecutara a speedupomp.c para los resultados finales .
gpu.sh
	Este ejecutable , corre el programa  de efecto borroso con todos los kernels (3,5,7,9,11,13,15),variando el numero de hilos (1-1000) para cada uno. Solo basta correr este ejecutable para ver todos los resultados, este ejecutara a gpu.cu  y luego que halla terminado todas las ejecuciones a este programa, ejecutara a speedupgpu.c para los resultados finales .

script.sh
	Ejecucion:
		./script.sh
		Este ejecutable , corre el programa con todos los kernels (3,5,7,9,11,13,15),variando el numero de hilos (1-16) para posix y omp , mientras que para CUda se lanzaran hilos de 3 a 10000 de 30 en 30. para cada uno. Solo basta correr este ejecutable para ver todos los resultados, este ejecutara a blur-effect.c blur-effect-omp.c gpu.cu y luego que halla terminado todas las ejecuciones a este programa, ejecutara a speedup.c speedupomp.c speedupgpu.c para los resultados finales . 



RESULTADOS

Luego de ejecutar los 3 scripts  apareceran los 3 resultados en 3 carpetas diferentes asi:

	resultados: posix
	romp: omp
	rgpu: Cuda
GRAFICAS 

Para ver las graficas hay que instalar gnuplot y cargar cada uno de los archivos '.p' que se encuentran en cada una de las  carpetas  de los resultados ( load 'w_grafica_1080.p' ) dentro del entorno de gnuplot.



## Entrega

Fecha límite Domingo 10/3/19 a las 24h.
