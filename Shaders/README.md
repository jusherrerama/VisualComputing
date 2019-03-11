

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
|     Juan Sebastian Herrera Maldonado       | jusherrerama             |

## Informe

 [ Informe Benchmark entre la implementación por software y la de shaders
de máscara de convolución blur-effect](https://github.com/jusherrerama/VisualComputing/blob/master/Shaders/Informe/Benchmark%20%20%20blur-effect.pdf)

## Presentacion
 [Presentacion Benchmark entre la implementación por software y la de shaders
de máscara de convolución blur-effect](https://github.com/jusherrerama/VisualComputing/blob/master/Shaders/Presentacion/Blur%20effect.pdf)


## Ejecucion

### Implementacion shaders

Imgrese a la carpeta 'Shader/BlurEffect'. 

#### Prerequisites and installation
1. Prerequisites
Usted debera tener instalado:
	- Processing.
	- Demas complementos de video.
	
#### Compilation and  Execution
1. Files in folder

Dentro de la carpeta "Shader/BlurEffect" usted encontrara el archivo 'BlurEffect.pde' El cual lo debe abrir con processing para su ejecucion.

Dentro de la carpeta "Shader/BlurEffect/data" encontrara 3 imagenes png (4k.png 1080.png 720.png ) que seran las utilizadas para la ejecucion de los algoritmos y 7 archivos GLSL, cada uno de estos contiene el shader en OpenGL con el algorimo (la mascara de convolucion) de blur effect segun sea el kernel utilizado.

	- k3.glsl: Contien el shader de la mascara de convolucion de blur effect con kernel 3.  
	- k5.glsl: Contien el shader de la mascara de convolucion de blur effect con kernel 5.
	- k7.glsl: Contien el shader de la mascara de convolucion de blur effect con kernel 7.
	- k9.glsl: Contien el shader de la mascara de convolucion de blur effect con kernel 9.
	- k11.glsl: Contien el shader de la mascara de convolucion de blur effect con kernel 11.
	- k13.glsl: Contien el shader de la mascara de convolucion de blur effect con kernel 13.
	- k15.glsl: Contien el shader de la mascara de convolucion de blur effect con kernel 15.

2. Execution

Una vez en processing usted encontrara un arreglo de Pimage donde estaran ubicadas las imagenes prueba de la siguiente manera:

	- Posicion [0] : estara la imagen "720.png"
	- Posicion [1] : estara la imagen "1080.png"
	- Posicion [2] : estara la imagen "4k.png"
	
Tambien usted encontrara un arreglo de  PShader donde estaran ubicadas las imagenes prueba de la siguiente manera:

	- Posicion [0] : estara el shader de la mascara de convolucion de blur effect con kernel 3.
	- Posicion [1] : estara el shader de la mascara de convolucion de blur effect con kernel 5.
	- Posicion [2] : estara el shader de la mascara de convolucion de blur effect con kernel 7.
	- Posicion [3] : estara el shader de la mascara de convolucion de blur effect con kernel 9.
	- Posicion [4] : estara el shader de la mascara de convolucion de blur effect con kernel 11.
	- Posicion [5] : estara el shader de la mascara de convolucion de blur effect con kernel 13.
	- Posicion [6] : estara el shader de la mascara de convolucion de blur effect con kernel 15.
En el setup usted selecciona la imagen que desea mostrar y el shader que desea aplicar (segun el kernel de blur effect que dessee aplicar). Luego se toman los tiempos de ejecucion y se guarda el frame resultante en la carpeta  "Shader/BlurEffect/" con el nombre de "outputImage.png".



 #### Resultados
 En la carpeta "Shader/BlurEffect/resultados" Encontrara el resultado de el tiempo de ejecucion con cada Kernel.
  


### Implementacion software
Imgrese a la carpeta 'SOFTWARE'. 
#### Prerequisites and installation
1. Prerequisites
Usted debera tener instalado:
	- OpenCV.
	- libpng.


2. Installation
	- OpenCV:
		- sudo apt-get install libopencv-dev
		- sudo apt-get install opencv-data
	- libpng:
		- sudo apt-get install libpng-dev

#### Compilation and  Execution
1. Files in folder
Dentro de la carpeta 'SOFTWARE'  encontrara 3 imagenes png (4k.png 1080.png 720.png ) que seran las utilizadas para la ejecucion de los algoritmos, 4 ejecutables .sh que son utilizados para correr los programas de manera masiva ylos siguientes programas:
	- blur-effect.c	 : Este corresponde al progrma que contiene la logica del blur effect basado en el modelo  Posix.
	- blur-effect-omp.c : Este corresponde al progrma que contiene la logica del blur effect basado en el modelo  OpenMP.	 
	- gpu.cu : Este corresponde al progrma que contiene la logica del blur effect basado en el modelo  CUDA.	 	 

2. Execution: 

	- blur-effect.c
	
			- Compilacion de blur-effect.c : // programa principal , donde se encuentra el algoritmo.
					- gcc blur-effect.c -lpng -pthread -o blur-effect
			- Ejecucion de blur-effect :
					- ./blur-effect 1080.png 1080k3.png 3 5 2;
							
		- Donde:
	
			- 1080.png: es la imagen png a tomar para aplicarle el efecto borroso.
			- 1080k3.png:  es el nombre de la imagen resultado.
			- 3:  Es  tamaño del kernel a tomar (3,5,7,9,11,13,15)
			- 5:  Es el numero de hilos 

	- blur-effect-omp.c
	
			- Compilacion de blur-effect-omp.c : // programa principal , donde se encuentra el algoritmo.
						- gcc blur-effect-omp.c  -lpng -fopenmp -o  blur-effect-omp
			- Ejecucion de blur-effect :
						- ./blur-effect-omp 1080.png 1080k3.png 3 5 3;
		- Donde:
	
			- 1080.png: es la imagen png a tomar para aplicarle el efecto borroso.
			- 1080k3.png:  es el nombre de la imagen resultado.
			- 3 :  Es  tamaño del kernel a tomar (3,5,7,9,11,13,15)
			- 5 :  Es el numero de hilos
			- 2 :  Es la resolucion de la imagen ( 1 -> 4k , 2 -> 1080p , 3 -> 720p) //este campo se usa solo para guardar de forma adecuada los datos resultado
			

	- gpu.cu
	
			- Compilacion de gpu.cu : // programa principal , donde se encuentra el algoritmo.
					-make
			- Ejecucion de blur-effect :
					-./gpu 1080.png 1080k3.png 3 5 3;
		- Donde:		
			- 1080.png: es la imagen png a tomar para aplicarle el efecto borroso.
			- 1080k3.png:  es el nombre de la imagen resultado.
			- 3 :  Es  tamaño del kernel a tomar (3,5,7,9,11,13,15)
			- 5 :  Es el numero de hilos
			- 2 :  Es la resolucion de la imagen ( 1 -> 4k , 2 -> 1080p , 3 -> 720p) //este campo se usa solo para guardar de forma adecuada los datos resultado


 
 #### Resultados
 Dentro de la carpeta 'SOFTWARE'  encontrara 3 carpetas con los resultados de la ejecución de los programas con todos los kernels ( 3,5,7,9,11,13.15 ) y todas las imágenes ( 4k.jpg , 1080.jpg , 720.jpg ) organizadas de la siguiente manera:
 	- results : Corresponde a los resultados implementando POSIX.
	- romp : Corresponde a los resultados implementando OpenMP.
	- rgpu : Corresponde a los resultados implementando CUDA. 
 #### Scripts
 Ademas usted encontrara 4 scripts de ejecucion:
 - [Posix]  Comando de ejecución de script :  ./posix.sh
	El script de ejecucion de este programa variara de 1 hasta 16 hilos , para cada combinacion  de tipo de imagen y tamaño de kernel.

- [OpenMP] Comando de ejecución de script :  ./omp

	El script de ejecucion de este programa variara de 1 hasta 16 hilos , para cada combinacion  de tipo de imagen y tamaño de kernel.

- [CUDA] Comando de ejecución de script :  ./gpu

	El script de ejecucion de este programa variara de 3 hasta 1000 hilos, yendo de 30 en 30 , para cada combinacion  de tipo de imagen y tamaño de kernel.


- [Scrip General] Comando de ejecución de script : ./script;  
  
 

## Entrega

Fecha límite Domingo 10/3/19 a las 24h.
