#!/bin/bash
if [ -f RESULT.txt ]; then
    rm RESULT.txt
fi
if [ -f romp/1080k3.txt ]; then
    rm  romp/1080k3.txt
fi
if [ -f romp/1080k5.txt ]; then
    rm  romp/1080k5.txt
fi
if [ -f romp/1080k7.txt ]; then
    rm  romp/1080k7.txt
fi
if [ -f romp/1080k9.txt ]; then
    rm  romp/1080k9.txt
fi
if [ -f romp/1080k11.txt ]; then
    rm  romp/1080k11.txt
fi
if [ -f romp/1080k13.txt ]; then
    rm  romp/1080k13.txt
fi
if [ -f romp/1080k15.txt ]; then
    rm  romp/1080k15.txt
fi


if [ -f romp/720k3.txt ]; then
    rm  romp/720k3.txt
fi
if [ -f romp/720k5.txt ]; then
    rm  romp/720k5.txt
fi
if [ -f romp/720k7.txt ]; then
    rm  romp/720k7.txt
fi
if [ -f romp/720k9.txt ]; then
    rm  romp/720k9.txt
fi
if [ -f romp/720k11.txt ]; then
    rm  romp/720k11.txt
fi
if [ -f romp/720k13.txt ]; then
    rm  romp/720k13.txt
fi
if [ -f romp/720k15.txt ]; then
    rm  romp/720k15.txt
fi


if [ -f romp/4kk3.txt ]; then
    rm  romp/4kk3.txt
fi
if [ -f romp/4kk5.txt ]; then
    rm  romp/4kk5.txt
fi
if [ -f romp/4kk7.txt ]; then
    rm  romp/4kk7.txt
fi
if [ -f romp/4kk9.txt ]; then
    rm  romp/4kk9.txt
fi
if [ -f romp/4kk11.txt ]; then
    rm  romp/4kk11.txt
fi
if [ -f romp/4kk13.txt ]; then
    rm  romp/4kk13.txt
fi
if [ -f romp/4kk15.txt ]; then
    rm  romp/4kk15.txt
fi

if [ -f romp/speedup1080k3.txt ]; then
    rm  romp/speedup1080k3.txt
fi
if [ -f romp/speedup1080k5.txt ]; then
    rm  romp/speedup1080k5.txt
fi
if [ -f romp/speedup1080k7.txt ]; then
    rm  romp/speedup1080k7.txt
fi
if [ -f romp/speedup1080k9.txt ]; then
    rm  romp/speedup1080k9.txt
fi
if [ -f romp/speedup1080k11.txt ]; then
    rm  romp/speedup1080k11.txt
fi
if [ -f romp/speedup1080k13.txt ]; then
    rm  romp/speedup1080k13.txt
fi
if [ -f romp/speedup1080k15.txt ]; then
    rm  romp/speedup1080k15.txt
fi


if [ -f romp/speedup720k3.txt ]; then
    rm  romp/speedup720k3.txt
fi
if [ -f romp/speedup720k5.txt ]; then
    rm  romp/speedup720k5.txt
fi
if [ -f romp/speedup720k7.txt ]; then
    rm  romp/speedup720k7.txt
fi
if [ -f romp/speedup720k9.txt ]; then
    rm  romp/speedup720k9.txt
fi
if [ -f romp/speedup720k11.txt ]; then
    rm  romp/speedup720k11.txt
fi
if [ -f romp/speedup720k13.txt ]; then
    rm  romp/speedup720k13.txt
fi
if [ -f romp/speedup720k15.txt ]; then
    rm  romp/speedup720k15.txt
fi


if [ -f romp/speedup4kk3.txt ]; then
    rm  romp/speedup4kk3.txt
fi
if [ -f romp/speedup4kk5.txt ]; then
    rm  romp/speedup4kk5.txt
fi
if [ -f romp/speedup4kk7.txt ]; then
    rm  romp/speedup4kk7.txt
fi
if [ -f romp/speedup4kk9.txt ]; then
    rm  romp/speedup4kk9.txt
fi
if [ -f romp/speedup4kk11.txt ]; then
    rm  romp/speedup4kk11.txt
fi
if [ -f romp/speedup4kk13.txt ]; then
    rm  romp/speedup4kk13.txt
fi
if [ -f romp/speedup4kk15.txt ]; then
    rm  romp/speedup4kk15.txt
fi

gcc  blur-effect-omp.c  -lpng -fopenmp -o  blur-effect-omp
echo "COMPILACIÓN "



    echo "Resultados ejecución de hilos con POSIX" >> RESULT.txt
    echo "Desde 1 hilo hasta 16 - IMAGEN 720 - kernel 3" >> RESULT.txt
    echo "" >> RESULT.txt

    for (( i = 1; i < 17; i += 1 )); do
    	echo "           Hilo = $i" >> RESULT.txt
      time=$( TIMEFORMAT="%R"; { time ./blur-effect-omp 720.png 720ompk3.png 3 $i 3; } 2>&1 );
     echo $i$'\t'${time} >> romp/720k3.txt
        echo "" >> RESULT.txt
    done

    echo "" >> RESULT.txt
    echo "Desde 1 hiloS hasta 16 - IMAGEN 720 - kernel 5" >>RESULT.txt
    echo "" >> RESULT.txt

    for (( i = 1; i < 17; i += 1 )); do
    	echo "           Hilo = $i" >> RESULT.txt
      time=$( TIMEFORMAT="%R";{ time ./blur-effect-omp 720.png 720ompk5.png 5 $i 3; }  2>&1 );
      echo $i$'\t'${time} >> romp/720k5.txt
        echo "" >> RESULT.txt
    done

    echo "" >> RESULT.txt
    echo "Desde 1 hilo hasta 16 - IMAGEN 720 - kernel 7" >> RESULT.txt

    echo "" >> RESULT.txt

    for (( i = 1; i < 17; i += 1 )); do
    	echo "           Hilo = $i" >> RESULT.txt
      time=$( TIMEFORMAT="%R";{ time ./blur-effect-omp 720.png 720ompk7.png 7 $i 3; }  2>&1 );
      echo $i$'\t'${time} >> romp/720k7.txt
        echo "" >> RESULT.txt
    done

    echo "" >> RESULT.txt
    echo "Desde 1 hilo hasta 16 - IMAGEN 720 - kernel 9" >> RESULT.txt

    echo "" >> RESULT.txt


    for (( i = 1; i < 17; i += 1 )); do
    	echo "           Hilo = $i" >> RESULT.txt
      time=$( TIMEFORMAT="%R";{ time ./blur-effect-omp 720.png 720ompk9.png 9 $i 3; }  2>&1 );
      echo $i$'\t'${time} >>romp/720k9.txt
        echo "" >> RESULT.txt
    done

    echo "" >> RESULT.txt
    echo "Desde 1 hilo hasta 16 - IMAGEN 720 - kernel 11" >>RESULT.txt

    echo "" >> RESULT.txt

    for (( i = 1; i < 17; i += 1 )); do
    	echo "           Hilo = $i" >> RESULT.txt
      time=$( TIMEFORMAT="%R";{ time ./blur-effect-omp 720.png 720ompk11.png 11 $i 3; }  2>&1 );
      echo $i$'\t'${time} >> romp/720k11.txt
        echo "" >> RESULT.txt
    done

    echo "" >> RESULT.txt
    echo "Desde 1 hilo hasta 16 - IMAGEN 720 - kernel 13" >> RESULT.txt

    echo "" >> RESULT.txt

    for (( i = 1; i < 17; i += 1 )); do
    	echo "           Hilo = $i" >> RESULT.txt
      time=$( TIMEFORMAT="%R";{ time ./blur-effect-omp 720.png 720ompk13.png 13 $i 3; }  2>&1 );
      echo $i$'\t'${time} >>romp/720k13.txt
        echo "" >> RESULT.txt
    done

    echo "" >> RESULT.txt
    echo "Desde 1 hilo hasta 16 - IMAGEN 720 - kernel 15" >>  RESULT.txt

    echo "" >> RESULT.txt

    for (( i = 1; i < 17; i += 1 )); do
    	echo "           Hilo = $i" >> RESULT.txt
      time=$( TIMEFORMAT="%R";{ time ./blur-effect-omp 720.png 720ompk15.png 15 $i 3; } 2>&1 );
      echo $i$'\t'${time}  >> romp/720k15.txt
        echo "" >> RESULT.txt
    done

    echo "" >> RESULT.txt
    echo "Desde 1 hilo hasta 16 - IMAGEN 1080 - kernel 3" >> RESULT.txt
    echo "" >> RESULT.txt

    for (( i = 1; i < 17; i += 1 )); do
    	echo "           Hilo = $i" >> RESULT.txt
      time=$( TIMEFORMAT="%R";{ time ./blur-effect-omp 1080.png 1080ompk3.png 3 $i 2; }  2>&1 );
      echo $i$'\t'${time}  >>  romp/1080k3.txt
        echo "" >> RESULT.txt
    done

    echo "" >> RESULT.txt
    echo "Desde 1 hilo hasta 16 - IMAGEN 1080 - kernel 5" >> RESULT.txt
    echo "" >> RESULT.txt

    for (( i = 1; i < 17; i += 1 )); do
    	echo "           Hilo = $i" >> RESULT.txt
      time=$( TIMEFORMAT="%R";{ time ./blur-effect-omp 1080.png 1080ompk5.png 5 $i 2;  }  2>&1 );
      echo $i$'\t'${time}  >>  romp/1080k5.txt
        echo "" >> RESULT.txt
    done

    echo "" >> RESULT.txt
    echo "Desde 1 hilo hasta 16 - IMAGEN 1080 - kernel 7" >> RESULT.txt

    echo "" >> RESULT.txt

    for (( i = 1; i < 17; i += 1 )); do
    	echo "           Hilo = $i" >> RESULT.txt
      time=$( TIMEFORMAT="%R";{ time ./blur-effect-omp 1080.png 1080ompk7.png 7 $i 2;  }  2>&1 );
      echo $i$'\t'${time} >>  romp/1080k7.txt
        echo "" >> RESULT.txt
    done

    echo "" >> RESULT.txt
    echo "Desde 1 hilo hasta 16 - IMAGEN 1080 - kernel 9" >> RESULT.txt
    echo "" >> RESULT.txt

    for (( i = 1; i < 17; i += 1 )); do
    	echo "           Hilo = $i" >> RESULT.txt
      time=$( TIMEFORMAT="%R";{ time ./blur-effect-omp 1080.png 1080ompk9.png 9 $i 2; }  2>&1 );
      echo $i$'\t'${time}  >>  romp/1080k9.txt
        echo "" >> RESULT.txt
    done

    echo "" >> RESULT.txt
    echo "Desde 1 hilo hasta 16 - IMAGEN 1080 - kernel 11" >> RESULT.txt
    echo "" >> RESULT.txt

    for (( i = 1; i < 17; i += 1 )); do
      echo "           Hilo = $i" >> RESULT.txt
      time=$( TIMEFORMAT="%R";  { time ./blur-effect-omp 1080.png 1080ompk11.png 11 $i 2; }   2>&1 );
      echo $i$'\t'${time}  >>  romp/1080k11.txt
        echo "" >> RESULT.txt
    done

    echo "" >> RESULT.txt
    echo "Desde 1 hilo hasta 16 - IMAGEN 1080 - kernel 13" >> RESULT.txt
    echo "" >> RESULT.txt

    for (( i = 1; i < 17; i += 1 )); do
      echo "           Hilo = $i" >> RESULT.txt
      time=$( TIMEFORMAT="%R";  { time ./blur-effect-omp 1080.png 1080ompk13.png 13 $i 2; } 2>&1 );
      echo $i$'\t'${time}  >>  romp/1080k13.txt
        echo "" >> RESULT.txt
    done

    echo "" >> RESULT.txt
    echo "Desde 1 hilo hasta 16 - IMAGEN 1080 - kernel 15" >> RESULT.txt
    echo "" >> RESULT.txt

    for (( i = 1; i < 17; i += 1 )); do
      echo "           Hilo = $i" >> RESULT.txt
      time=$( TIMEFORMAT="%R";{ time ./blur-effect-omp 1080.png 1080ompk15.png 15 $i 2; } 2>&1 );
      echo $i$'\t'${time} >>  romp/1080k15.txt
        echo "" >> RESULT.txt
    done



    echo "" >> RESULT.txt
    echo "Desde 1 hilo hasta 16 - IMAGEN 4k - kernel 3" >> RESULT.txt
    echo "" >> RESULT.txt

    for (( i = 1; i < 17; i += 1 )); do
    	echo "           Hilo = $i" >> RESULT.txt
      time=$( TIMEFORMAT="%R";{ time ./blur-effect-omp 4k.png 4kompk3.png 3 $i 1; } 2>&1 );
      echo $i$'\t'${time}  >> romp/4kk3.txt
        echo "" >> RESULT.txt
    done
    echo "" >> RESULT.txt
    echo "Desde 1 hilo hasta 16 - IMAGEN 4k - kernel 5" >> RESULT.txt
    echo "" >> RESULT.txt

    for (( i = 1; i < 17; i += 1 )); do
    	echo "           Hilo = $i" >> RESULT.txt
      time=$( TIMEFORMAT="%R";{ time ./blur-effect-omp 4k.png 4kompk5.png 5 $i 1;}  2>&1 );
      echo $i$'\t'${time}  >> romp/4kk5.txt
        echo "" >> RESULT.txt
    done

    echo "" >> RESULT.txt
    echo "Desde 1 hilo hasta 16 - IMAGEN 4k - kernel 7" >> RESULT.txt

    echo "" >> RESULT.txt

    for (( i = 1; i < 17; i += 1 )); do
    	echo "           Hilo = $i" >> RESULT.txt
      time=$( TIMEFORMAT="%R";{ time ./blur-effect-omp 4k.png 4kompk7.png 7 $i 1; }  2>&1 );
      echo $i$'\t'${time}  >>  romp/4kk7.txt
        echo "" >> RESULT.txt
    done

    echo "" >> RESULT.txt
    echo "Desde 1 hilo hasta 16 - IMAGEN 4k - kernel 9" >> RESULT.txt
    echo "" >> RESULT.txt

    for (( i = 1; i < 17; i += 1 )); do
      echo "           Hilo = $i" >> RESULT.txt
      time=$( TIMEFORMAT="%R";  { time ./blur-effect-omp 4k.png 4kompk9.png 9 $i 1; } 2>&1 );
      echo $i$'\t'${time} >> romp/4kk9.txt
        echo "" >> RESULT.txt
    done

    echo "" >> RESULT.txt
    echo "Desde 1 hilo hasta 16 - IMAGEN 4k - kernel 11" >> RESULT.txt
    echo "" >> RESULT.txt

    for (( i = 1; i < 17; i += 1 )); do
      echo "           Hilo = $i" >> RESULT.txt
      time=$( TIMEFORMAT="%R";{ time ./blur-effect-omp 4k.png 4kompk11.png 11 $i 1; } 2>&1 );
      echo $i$'\t'${time}  >> romp/4kk11.txt
        echo "" >> RESULT.txt
    done

    echo "" >> RESULT.txt
    echo "Desde 1 hilo hasta 16 - IMAGEN 4k - kernel 13" >> RESULT.txt
    echo "" >> RESULT.txt

    for (( i = 1; i < 17; i += 1 )); do
      echo "           Hilo = $i" >> RESULT.txt
      time=$( TIMEFORMAT="%R";  { time ./blur-effect-omp 4k.png 4kompk13.png 13 $i 1; } 2>&1 );
      echo $i$'\t'${time} >> romp/4kk13.txt
        echo "" >> RESULT.txt
    done

    echo "" >> RESULT.txt
    echo "Desde 1 hilo hasta 16 - IMAGEN 4k - kernel 15" >> RESULT.txt
    echo "" >> RESULT.txt

    for (( i = 1; i < 17; i += 1 )); do
      echo "           Hilo = $i" >> RESULT.txt
      time=$( TIMEFORMAT="%R";  { time ./blur-effect-omp 4k.png 4kompk15.png 15 $i 1; }  2>&1 );
      echo $i$'\t'${time}  >> romp/4kk15.txt
        echo "" >> RESULT.txt
    done


    gcc speedupomp.c  -o speedupomp
    echo "COMPILACIÓN Speedup EXITOSA"
    ./speedupomp
