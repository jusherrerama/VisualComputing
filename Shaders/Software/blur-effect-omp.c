#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <pthread.h>
#include <png.h>
#include <omp.h>
#include <time.h>

void abort_(const char * s, ...)
{
        va_list args;
        va_start(args, s);
        vfprintf(stderr, s, args);
        fprintf(stderr, "\n");
        va_end(args);
        abort();
}


int x, y;
int width, height;
png_byte color_type;
png_byte bit_depth;
png_structp png;
png_infop info;
int number_of_passes;
png_bytep * rowPointer;



void read_png_file(char* file_name){
        char header[8];
        FILE *fp = fopen(file_name, "rb");
        if (!fp)
                abort_("[read_png_file] File %s could not be opened for reading", file_name);
        fread(header, 1, 8, fp);
        if (png_sig_cmp(header, 0, 8))
                abort_("[read_png_file] File %s is not recognized as a PNG file", file_name);

        png = png_create_read_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);

        if (!png)
                abort_("[read_png_file] png_create_read_struct failed");

        info = png_create_info_struct(png);
        if (!info)
                abort_("[read_png_file] png_create_info_struct failed");

        if (setjmp(png_jmpbuf(png)))
                abort_("[read_png_file] Error during init_io");


        png_init_io(png, fp);
        png_set_sig_bytes(png, 8);
        png_read_info(png, info);
        width = png_get_image_width(png, info);
        height = png_get_image_height(png, info);
        color_type = png_get_color_type(png, info);
        bit_depth = png_get_bit_depth(png, info);
        number_of_passes = png_set_interlace_handling(png);
        png_read_update_info(png, info);

        if (setjmp(png_jmpbuf(png)))
                abort_("[read_png_file] Error during read_image");

        rowPointer = (png_bytep*) malloc(sizeof(png_bytep) * height);
        for (y=0; y<height; y++)
                rowPointer[y] = (png_byte*) malloc(png_get_rowbytes(png,info));

        png_read_image(png, rowPointer);
        fclose(fp);}

void write_png_file(char* file_name)
{
        FILE *fp = fopen(file_name, "wb");
        if (!fp)
                abort_("[write_png_file] File %s could not be opened for writing", file_name);

        png = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);

        if (!png)
                abort_("[write_png_file] png_create_write_struct failed");

        info = png_create_info_struct(png);
        if (!info)
                abort_("[write_png_file] png_create_info_struct failed");

        if (setjmp(png_jmpbuf(png)))
                abort_("[write_png_file] Error during init_io");

        png_init_io(png, fp);

        if (setjmp(png_jmpbuf(png)))
                abort_("[write_png_file] Error during writing header");

        png_set_IHDR(png, info, width, height,
                     bit_depth, color_type, PNG_INTERLACE_NONE,
                     PNG_COMPRESSION_TYPE_BASE, PNG_FILTER_TYPE_BASE);

        png_write_info(png, info);

        if (setjmp(png_jmpbuf(png)))
                abort_("[write_png_file] Error during writing bytes");

        png_write_image(png, rowPointer);

        if (setjmp(png_jmpbuf(png)))
                abort_("[write_png_file] Error during end of write");

        png_write_end(png, NULL);

        for (y=0; y<height; y++)
                free(rowPointer[y]);

        free(rowPointer);
        fclose(fp);
}
int main(int argc, char *argv[]) {

  time_t tiempo_inicio, tiempo_final;
  double segundos;
  tiempo_inicio = time(0);
  if(sizeof(*argv) < 5){
    printf("Por favor ingresar datos así: nombreimagen.png nuevaimagen.png #kernel #hilos #resolucion de imagen {1->4k , 2->1080, 3->720}\n");
    exit(0);}

 
  int nrows = atoi(argv[3]);
  int hilos = atoi(argv[4]); 
  int divi, begin, end, begin2, end2,tnum,id, p,fin;

  char * res = malloc(30);




  read_png_file(argv[1]);

  divi = (height/hilos) ;
  float rest = height%hilos;
	//printf("divi %i  rest %f height %i \n", divi,rest,height);
	end2 = divi;
  if (nrows == 3){
    p = 1;
     
  }
  if(nrows == 5){begin2 = 2;
        p = 2;
         
    }
  if(nrows == 7){begin2= 3;
          p = 3;
          
  }
  if(nrows == 9){begin2= 4;

          p = 4;
          
  }
  if(nrows == 11){begin2= 5;
          p = 5;
           
  }
  if(nrows == 13){begin2= 6;
          p = 6;
           
  }
  if(nrows == 15){
					begin2= 7;
          p = 7; 	
  }
 fin = begin2;
 if (hilos == 	1 ){
	 end2 = end2 - 7;
 }


 omp_set_num_threads(hilos);

 #pragma omp parallel
 {
   int i, id,nthrds;
   double x;
   id = omp_get_thread_num();
   nthrds = omp_get_num_threads();

     int  istart,iend;
     nthrds = omp_get_num_threads();


      if ( id != 0 ) {
        istart = id * height / nthrds;
        iend = (id+1) * height / nthrds;
        if (iend + p >= height){
          iend = height-p ;
        }
      }else {
        istart =begin2;
        iend = end2;
      }
  //   printf("id %i  inicio %i  final %i  \n" ,id, istart,iend);
     if(nrows == 3 || nrows == 7 || nrows == 5 || nrows == 9 || nrows == 11 || nrows == 13 || nrows == 15){
	int m,w2; 
        for( m = istart; m <  iend; m++){
            png_byte* rowBefore = rowPointer[m - 1];
            png_byte* rowBefore2 = rowPointer[m - 2];
            png_byte* rowBefore3 = rowPointer[m - 3];
            png_byte* rowBefore4 = rowPointer[m - 4];
            png_byte* rowBefore5 = rowPointer[m - 5];
            png_byte* rowBefore6 = rowPointer[m - 6];
            png_byte* rowBefore7 = rowPointer[m - 7];
            png_byte* row = rowPointer[m];
            png_byte* rowAfter = rowPointer[m + 1];
            png_byte* rowAfter2 = rowPointer[m + 2];
            png_byte* rowAfter3 = rowPointer[m + 3];
            png_byte* rowAfter4 = rowPointer[m + 4];
            png_byte* rowAfter5 = rowPointer[m + 5];
            png_byte* rowAfter6 = rowPointer[m + 6];
            png_byte* rowAfter7 = rowPointer[m + 7];

           for ( w2= 1 ; w2 < width ; w2++) {
             png_byte* pix1 = &(rowBefore[(w2 - 1) * 4]);
             png_byte* pix2 = &(rowBefore[w2*4]);
             png_byte* pix3 = &(rowBefore[(w2 + 1 ) * 4]);
             png_byte* pix4 = &(row[(w2 - 1) * 4]);
             png_byte* pix5 = &(row[w2*4]); //centro
             png_byte* pix6 = &(row[( w2 + 1 ) * 4]);
             png_byte* pix7 = &(rowAfter[( w2 - 1 ) * 4]);
             png_byte* pix8 = &(rowAfter[w2*4]);
             png_byte* pix9 = &(rowAfter[( w2 + 1 ) * 4]);
             if(  nrows == 3){
               pix5[0] = (double)((pix1[0]  + pix2[0] +pix3[0]  + pix4[0] + pix5[0] + pix6[0] + pix7[0] +  pix8[0] +
                   pix9[0])/9);
               pix5[1] = (double)( (pix1[1] + pix2[1] + pix3[1]  + pix4[1] + pix5[1]  + pix6[1]  + pix7[1] +   pix8[1]  +
                  pix9[1] )/9);
               pix5[2] = (double)((pix1[2] + pix2[2]  + pix3[2]  + pix4[2]+ pix5[2]  +  pix6[2]  + pix7[2] +   pix8[2]  +
                   pix9[2] )/9);
             }else{
               png_byte* pix10 = &(rowAfter2[( w2 - 2 ) * 4]);
               png_byte* pix11 = &(rowAfter2[( w2 - 1) * 4]);
               png_byte* pix12 = &(rowAfter2[w2 * 4]);
               png_byte* pix13 = &(rowAfter2[(w2 + 1 )* 4]);
               png_byte* pix14 = &(rowAfter2[(w2 + 2 )* 4]);
               png_byte* pix15 = &(rowAfter[( w2 + 2 ) * 4]);
               png_byte* pix16 = &(rowAfter[( w2 - 2 ) * 4]);
               png_byte* pix17 = &(rowBefore[( w2 - 2  ) * 4]);
               png_byte* pix18 = &(rowBefore[( w2 + 2 ) * 4]);
               png_byte* pix19= &(row[( w2 - 2 ) * 4]);
               png_byte* pix20 = &(row[( w2 + 2 ) * 4]);
               png_byte* pix21 = &(rowBefore2[( w2 - 2 ) * 4]);
               png_byte* pix22  = &(rowBefore2[( w2 - 1 ) * 4]);
               png_byte* pix23 = &(rowBefore2[w2 * 4]);
               png_byte* pix24 = &(rowBefore2[( w2 + 1 ) * 4]);
               png_byte* pix25 = &(rowBefore2[( w2 + 2 ) * 4]);
               if(  nrows == 5){
                 pix5[0] = (double)(( pix1[0] +pix2[0] + pix3[0] + pix4[0] + pix5[0] + pix6[0] + pix7[0] + pix8[0] + pix9[0] +
                               pix10[0] +pix11[0] + pix12[0] + pix13[0] + pix14[0] + pix15[0] + pix16[0] + pix17[0] + pix18[0] +
                               pix19[0] +pix20[0] + pix21[0] + pix22[0] + pix23[0] + pix24[0]+ pix25[0]) / (25));

                 pix5[1] = (double) ((pix1[1] +pix2[1] + pix3[1] + pix4[1] + pix5[1] + pix6[1] + pix7[1] + pix8[1] + pix9[1] +
                              pix10[1] +pix11[1] + pix12[1] + pix13[1] + pix14[1] + pix15[1] + pix16[1] + pix17[1] + pix18[1] +
                              pix19[1] +pix20[1] + pix21[1] + pix22[1] + pix23[1] + pix24[1]+ pix25[1])/ (25));

                 pix5[2] = (double)( (pix1[2] + pix2[2] + pix3[2] + pix4[2] + pix5[2] + pix6[2] + pix7[2] + pix8[2] +
                               pix9[2] + pix10[2] + pix11[2] + pix12[2] + pix13[2] + pix14[2]  + pix15[2]  + pix16[2]  +
                               pix17[2] + pix18[2] + pix19[2] + pix20[2] + pix21[2] + pix22[2] + pix23[2] +   pix24[2] +
                               pix25[2] )/ (25));
               }else{

                 png_byte* pix26 = &(rowBefore3[(w2 - 2 )* 4]);
                 png_byte* pix27 = &(rowBefore3[(w2 - 1 )* 4]);
                 png_byte* pix28 = &(rowBefore3[w2* 4]);
                 png_byte* pix29 = &(rowBefore3[(w2 + 3 )* 4]);
                 png_byte* pix30 = &(rowBefore3[(w2 + 2 )* 4]);
                 png_byte* pix31 = &(rowBefore3[(w2 + 1  )* 4]);
                 png_byte* pix32 = &(rowAfter3[(w2 - 3 )* 4]);
                 png_byte* pix33 = &(rowAfter3[(w2 - 2 )* 4]);
                 png_byte* pix34 = &(rowAfter3[(w2 - 1 )* 4]);
                 png_byte* pix35 = &(rowAfter3[w2* 4]);
                 png_byte* pix36 = &(rowAfter3[(w2 + 3 )* 4]);
                 png_byte* pix37 = &(rowAfter3[(w2 + 2 )* 4]);
                 png_byte* pix38 = &(rowAfter3[(w2 + 1 )* 4]);
                 png_byte* pix39 = &(rowBefore3[(w2 - 3 )* 4]);
                 png_byte* pix40 = &(rowAfter[( w2 + 3 ) * 4]);
                 png_byte* pix41 = &(rowAfter[( w2 - 3 ) * 4]);
                 png_byte* pix42 = &(rowBefore[( w2 - 3  ) * 4]);
                 png_byte* pix43 = &(rowBefore[( w2 + 3 ) * 4]);
                 png_byte* pix44= &(row[( w2 - 3 ) * 4]);
                 png_byte* pix45 = &(row[( w2 + 3 ) * 4]);
                 png_byte* pix46 = &(rowBefore2[( w2 - 3 ) * 4]);
                 png_byte* pix47 = &(rowBefore2[( w2 + 3 ) * 4]);
                 png_byte* pix48 = &(rowAfter2[( w2 - 3) * 4]);
                 png_byte* pix49 = &(rowAfter2[( w2 + 3) * 4]);
                 if(  nrows == 7){
                   pix5[0] = (double)(( pix1[0] +pix2[0] + pix3[0] + pix4[0] + pix5[0] + pix6[0] + pix7[0] + pix8[0] + pix9[0] +
                               pix10[0] +pix11[0] + pix12[0] + pix13[0] + pix14[0] + pix15[0] + pix16[0] + pix17[0] + pix18[0] +
                               pix19[0] +pix20[0] + pix21[0] + pix22[0] + pix23[0] + pix24[0]+ pix25[0] + pix26[0] + pix27[0] +
                               pix28[0] + pix29[0] + pix30[0]+ pix31[0] + pix32[0] +pix33[0] + pix34[0] + pix35[0] + pix36[0] +
                               pix37[0]+ pix38[0] + pix39[0] + pix40[0] + pix41[0] + pix42[0] + pix43[0] + pix44[0] + pix45[0] +
                               pix46[0]+ pix47[0]+ pix48[0]+ pix49[0] ) / 49);
                   pix5[1] = (double)(( pix1[1] +pix2[1] + pix3[1] + pix4[1] + pix5[1] + pix6[1] + pix7[1] + pix8[1] + pix9[1] +
                               pix10[1] +pix11[1] + pix12[1] + pix13[1] + pix14[1] + pix15[1] + pix16[1] + pix17[1] + pix18[1] +
                               pix19[1] +pix20[1] + pix21[1] + pix22[1] + pix23[1] + pix24[1]+ pix25[1] + pix26[1] + pix27[1] +
                               pix28[1] + pix29[1] + pix30[1]+ pix31[1] + pix32[1] +pix33[1] + pix34[1] + pix35[1] + pix36[1] +
                               pix37[1]+ pix38[1] + pix39[1] + pix40[1] + pix41[1] + pix42[1] + pix43[1] + pix44[1] + pix45[1] +
                               pix46[1]+ pix47[1]+ pix48[1]+ pix49[1] ) / 49);
                   pix5[2] = (double)(( pix1[2] +pix2[2] + pix3[2] + pix4[2] + pix5[2] + pix6[2] + pix7[2] + pix8[2] + pix9[2] +
                               pix10[2] +pix11[2] + pix12[2] + pix13[2] + pix14[2] + pix15[2] + pix16[2] + pix17[2] + pix18[2] +
                               pix19[2] +pix20[2] + pix21[2] + pix22[2] + pix23[2] + pix24[2]+ pix25[2] + pix26[2] + pix27[2] +
                               pix28[2] + pix29[2] + pix30[2]+ pix31[2] + pix32[2] +pix33[2] + pix34[2] + pix35[2] + pix36[2] +
                               pix37[2]+ pix38[2] + pix39[2] + pix40[2] + pix41[2] + pix42[2] + pix43[2] + pix44[2] + pix45[2] +
                               pix46[2]+ pix47[2]+ pix48[2]+ pix49[2] ) / 49);
                 }else{
                   png_byte* pix50 = &(rowBefore4[(w2 + 2 )* 4]);
                   png_byte* pix51 = &(rowBefore4[(w2 + 1  )* 4]);
                   png_byte* pix52 = &(rowAfter4[(w2 - 4 )* 4]);
                   png_byte* pix53 = &(rowAfter4[(w2 - 3 )* 4]);
                   png_byte* pix54 = &(rowAfter4[(w2 - 2 )* 4]);
                   png_byte* pix55 = &(rowAfter4[(w2 - 1 )* 4]);
                   png_byte* pix56 = &(rowAfter4[w2* 4]);
                   png_byte* pix57 = &(rowAfter4[(w2 + 4 )* 4]);
                   png_byte* pix58 = &(rowAfter4[(w2 + 3 )* 4]);
                   png_byte* pix59 = &(rowAfter4[(w2 + 2 )* 4]);
                   png_byte* pix60 = &(rowAfter4[(w2 + 1 )* 4]);
                   png_byte* pix61 = &(rowBefore3[(w2 - 4 )* 4]);
                   png_byte* pix62 = &(rowBefore3[(w2 + 4 )* 4]);
                   png_byte* pix63 = &(rowAfter2[( w2 - 4 ) * 4]);
                   png_byte* pix64 = &(rowAfter2[( w2 + 4 ) * 4]);
                   png_byte* pix65 = &(rowAfter[( w2 + 4 ) * 4]);
                   png_byte* pix66 = &(rowAfter[( w2 - 4 ) * 4]);
                   png_byte* pix67 = &(row[( w2 + 4 ) * 4]);
                   png_byte* pix68 = &(row[( w2 - 4 ) * 4]);
                   png_byte* pix69 = &(rowBefore[( w2 + 4 ) * 4] );
                   png_byte* pix70 = &(rowBefore[( w2 - 4 ) * 4] );
                   png_byte* pix71 = &(rowAfter2[(w2 + 4 )* 4]);
                   png_byte* pix72 = &(rowAfter2[(w2 - 4 )* 4]);
                   png_byte* pix73 = &(rowBefore3[(w2 + 4 )* 4]);
                   png_byte* pix74 = &(rowBefore3[(w2 - 4 )* 4]);
                   png_byte* pix75 = &(rowBefore4[(w2 - 4 )* 4]);
                   png_byte* pix76 = &(rowBefore4[(w2 - 3 )* 4]);
                   png_byte* pix77 = &(rowBefore4[(w2 - 2 )* 4]);
                   png_byte* pix78 = &(rowBefore4[(w2 - 1 )* 4]);
                   png_byte* pix79 = &(rowBefore4[w2* 4]);
                   png_byte* pix80 = &(rowBefore4[(w2 + 4 )* 4]);
                   png_byte* pix81 = &(rowBefore4[(w2 + 3 )* 4]);
                   if(  nrows == 9){

                     pix5[0] = (double)(( pix1[0] +pix2[0] + pix3[0] + pix4[0] + pix5[0] + pix6[0] + pix7[0] + pix8[0] + pix9[0] +
                           pix10[0] +pix11[0] + pix12[0] + pix13[0] + pix14[0] + pix15[0] + pix16[0] + pix17[0] + pix18[0] +
                           pix19[0] +pix20[0] + pix21[0] + pix22[0] + pix23[0] + pix24[0]+ pix25[0] + pix26[0] + pix27[0] +
                           pix28[0] + pix29[0] + pix30[0]+ pix31[0] + pix32[0] +pix33[0] + pix34[0] + pix35[0] + pix36[0] +
                           pix37[0]+ pix38[0] + pix39[0] + pix40[0] + pix41[0] + pix42[0] + pix43[0]+ pix44[0] + pix45[0] +
                           pix46[0] + pix47[0] + pix48[0] + pix49[0]+ pix50[0] + pix51[0] +pix52[0] + pix53[0] + pix54[0] +
                           pix55[0] +  pix56[0]+ pix57[0] + pix58[0] + pix59[0] + pix60[0] + pix61[0]  +pix62[0] + pix63[0] +
                           pix64[0] + pix65[0] +  pix66[0]+ pix67[0] + pix68[0] + pix69[0] + pix70[0] + pix71[0]   +pix72[0] +
                           pix73[0] + pix74[0]+ pix75[0] +  pix76[0]+ pix77[0] + pix78[0] + pix79[0] + pix80[0] + pix81[0] ) / 81);
                     pix5[1] = (double)(( pix1[1] +pix2[1] + pix3[1] + pix4[1] + pix5[1] + pix6[1] + pix7[1] + pix8[1] + pix9[1] +
                           pix10[1] +pix11[1] + pix12[1] + pix13[1] + pix14[1] + pix15[1] + pix16[1] + pix17[1] + pix18[1] +
                           pix19[1] +pix20[1] + pix21[1] + pix22[1] + pix23[1] + pix24[1]+ pix25[1] + pix26[1] + pix27[1] +
                           pix28[1] + pix29[1] + pix30[1]+ pix31[1] + pix32[1] +pix33[1] + pix34[1] + pix35[1] + pix36[1] +
                           pix37[1]+ pix38[1] + pix39[1] + pix40[1] + pix41[1] + pix42[1] + pix43[1]+ pix44[1] + pix45[1] +
                           pix46[1] + pix47[1] + pix48[1] + pix49[1]+ pix50[1] + pix51[1] +pix52[1] + pix53[1] + pix54[1] +
                           pix55[1] +  pix56[1]+ pix57[1] + pix58[1] + pix59[1] + pix60[1] + pix61[1]  +pix62[1] + pix63[1] +
                           pix64[1] + pix65[1] +  pix66[1]+ pix67[1] + pix68[1] + pix69[1] + pix70[1] + pix71[1]   +pix72[1] +
                           pix73[1] + pix74[1]+ pix75[1] +  pix76[1]+ pix77[1] + pix78[1] + pix79[1] + pix80[1] + pix81[1] ) / 81);
                     pix5[2] = (double)(( pix1[2] +pix2[2] + pix3[2] + pix4[2] + pix5[2] + pix6[2] + pix7[2] + pix8[2] + pix9[2] +
                           pix10[2] +pix11[2] + pix12[2] + pix13[2] + pix14[2] + pix15[2] + pix16[2] + pix17[2] + pix18[2] +
                           pix19[2] +pix20[2] + pix21[2] + pix22[2] + pix23[2] + pix24[2]+ pix25[2] + pix26[2] + pix27[2] +
                           pix28[2] + pix29[2] + pix30[2]+ pix31[2] + pix32[2] +pix33[2] + pix34[2] + pix35[2] + pix36[2] +
                           pix37[2]+ pix38[2] + pix39[2] + pix40[2] + pix41[2] + pix42[2] + pix43[2]+ pix44[2] + pix45[2] +
                           pix46[2] + pix47[2] + pix48[2] + pix49[2]+ pix50[2] + pix51[2] +pix52[2] + pix53[2] + pix54[2] +
                           pix55[2] +  pix56[2]+ pix57[2] + pix58[2] + pix59[2] + pix60[2] + pix61[2]  +pix62[2] + pix63[2] +
                           pix64[2] + pix65[2] +  pix66[2]+ pix67[2] + pix68[2] + pix69[2] + pix70[2] + pix71[2]   +pix72[2] +
                           pix73[2] + pix74[2]+ pix75[2] +  pix76[2]+ pix77[2] + pix78[2] + pix79[2] + pix80[2] + pix81[2] ) / 81);
                   }else{
                     png_byte* pix81 = &(rowBefore5[(w2 + 5 )* 4]);
                     png_byte* pix82 = &(rowBefore5[(w2 + 4 )* 4]);
                     png_byte* pix83 = &(rowBefore5[(w2 + 3 )* 4]);
                     png_byte* pix84 = &(rowBefore5[(w2 + 2 )* 4]);
                     png_byte* pix85 = &(rowBefore5[(w2 + 1  )* 4]);
                     png_byte* pix86 = &(rowAfter5[(w2 - 5 )* 4]);
                     png_byte* pix87 = &(rowAfter5[(w2 - 4 )* 4]);
                     png_byte* pix88 = &(rowAfter5[(w2 - 3 )* 4]);
                     png_byte* pix89 = &(rowAfter5[(w2 - 2 )* 4]);
                     png_byte* pix90 = &(rowAfter5[(w2 - 1 )* 4]);
                     png_byte* pix91 = &(rowAfter5[w2* 4]);
                     png_byte* pix92 = &(rowAfter5[(w2 + 5 )* 4]);
                     png_byte* pix93 = &(rowAfter5[(w2 + 4 )* 4]);
                     png_byte* pix94 = &(rowAfter5[(w2 + 3 )* 4]);
                     png_byte* pix95 = &(rowAfter5[(w2 + 2 )* 4]);
                     png_byte* pix96 = &(rowAfter5[(w2 + 1 )* 4]);
                     png_byte* pix97 = &(rowAfter3[(w2 - 5 )* 4]);
                     png_byte* pix98 = &(rowAfter3[(w2 + 5 )* 4]);
                     png_byte* pix99 = &(rowAfter2[( w2 - 5 ) * 4]);
                     png_byte* pix100 = &(rowAfter2[( w2 + 5 ) * 4]);
                     png_byte* pix101 = &(rowAfter[( w2 + 5 ) * 4]);
                     png_byte* pix102 = &(rowAfter[( w2 - 5 ) * 4]);
                     png_byte* pix103 = &(row[( w2 + 5 ) * 4]);
                     png_byte* pix104 = &(row[( w2 - 5 ) * 4]);
                     png_byte* pix105 = &(rowBefore[( w2 + 5 ) * 4] );
                     png_byte* pix106 = &(rowBefore[( w2 - 5 ) * 4] );
                     png_byte* pix107 = &(rowBefore2[(w2 + 5 )* 4]);
                     png_byte* pix108 = &(rowBefore2[(w2 - 5 )* 4]);
                     png_byte* pix109 = &(rowBefore3[(w2 + 5 )* 4]);
                     png_byte* pix110 = &(rowBefore3[(w2 - 5 )* 4]);
                     png_byte* pix111 = &(rowBefore5[(w2 - 5 )* 4]);
                     png_byte* pix112 = &(rowBefore5[(w2 - 4 )* 4]);
                     png_byte* pix113 = &(rowBefore5[(w2 - 3 )* 4]);
                     png_byte* pix114 = &(rowBefore5[(w2 - 2 )* 4]);
                     png_byte* pix115 = &(rowBefore5[(w2 - 1 )* 4]);
                     png_byte* pix116 = &(rowBefore5[w2* 4]);
                     png_byte* pix117 = &(rowBefore4[(w2 - 5 )* 4]);
                     png_byte* pix118 = &(rowBefore4[(w2 - 5 )* 4]);
                     png_byte* pix119 = &(rowAfter4[(w2 - 5 )* 4]);
                     png_byte* pix120 = &(rowAfter4[(w2 - 5 )* 4]);
                     png_byte* pix121 = &(rowBefore5[(w2 - 2 )* 4]);

                     if(  nrows == 11){
                       pix5[0] = (double)(( pix1[0] +pix2[0] + pix3[0] + pix4[0] + pix5[0] + pix6[0] + pix7[0] + pix8[0] + pix9[0] +
                             pix10[0] +pix11[0] + pix12[0] + pix13[0] + pix14[0] + pix15[0] + pix16[0] + pix17[0] + pix18[0] +
                             pix19[0] +pix20[0] + pix21[0] + pix22[0] + pix23[0] + pix24[0]+ pix25[0] + pix26[0] + pix27[0] +
                             pix28[0] + pix29[0] + pix30[0]+ pix31[0] + pix32[0] +pix33[0] + pix34[0] + pix35[0] + pix36[0] +
                             pix37[0]+ pix38[0] + pix39[0] + pix40[0] + pix41[0] + pix42[0] + pix43[0]+ pix44[0] + pix45[0] +
                             pix46[0] + pix47[0] + pix48[0] + pix49[0]+ pix50[0] + pix51[0] +pix52[0] + pix53[0] + pix54[0] +
                             pix55[0] +  pix56[0]+ pix57[0] + pix58[0] + pix59[0] + pix60[0] + pix61[0]  +pix62[0] + pix63[0] +
                             pix64[0] + pix65[0] +  pix66[0]+ pix67[0] + pix68[0] + pix69[0] + pix70[0] + pix71[0]   +pix72[0] +
                             pix73[0] + pix74[0]+ pix75[0] +  pix76[0]+ pix77[0] + pix78[0] + pix79[0] + pix80[0] + pix81[0] +
                             pix82[0] + pix83[0]+ pix84[0] + pix85[0] + pix86[0] + pix87[0] + pix88[0] + pix89[0]+ pix90[0] +
                             pix91[0] +pix92[0] + pix93[0] + pix94[0] + pix95[0] +  pix96[0]+ pix97[0] + pix98[0] + pix99[0] +
                             pix100[0] + pix101[0]  +pix102[0] + pix103[0] + pix104[0] + pix105[0] +  pix106[0]+ pix107[0] + pix108[0] +
                             pix109[0] + pix110[0] + pix111[0]   +pix112[0] + pix113[0] + pix114[0]+ pix115[0] +  pix116[0]+ pix117[0] +
                             pix118[0] + pix119[0] + pix120[0] + pix121[0] ) / 121);
                       pix5[1] = (double)(( pix1[1] +pix2[1] + pix3[1] + pix4[1] + pix5[1] + pix6[1] + pix7[1] + pix8[1] + pix9[1] +
                             pix10[1] +pix11[1] + pix12[1] + pix13[1] + pix14[1] + pix15[1] + pix16[1] + pix17[1] + pix18[1] +
                             pix19[1] +pix20[1] + pix21[1] + pix22[1] + pix23[1] + pix24[1]+ pix25[1] + pix26[1] + pix27[1] +
                             pix28[1] + pix29[1] + pix30[1]+ pix31[1] + pix32[1] +pix33[1] + pix34[1] + pix35[1] + pix36[1] +
                             pix37[1]+ pix38[1] + pix39[1] + pix40[1] + pix41[1] + pix42[1] + pix43[1]+ pix44[1] + pix45[1] +
                             pix46[1] + pix47[1] + pix48[1] + pix49[1]+ pix50[1] + pix51[1] +pix52[1] + pix53[1] + pix54[1] +
                             pix55[1] +  pix56[1]+ pix57[1] + pix58[1] + pix59[1] + pix60[1] + pix61[1]  +pix62[1] + pix63[1] +
                             pix64[1] + pix65[1] +  pix66[1]+ pix67[1] + pix68[1] + pix69[1] + pix70[1] + pix71[1]   +pix72[1] +
                             pix73[1] + pix74[1]+ pix75[1] +  pix76[1]+ pix77[1] + pix78[1] + pix79[1] + pix80[1] + pix81[1] +
                             pix82[1] + pix83[1]+ pix84[1] + pix85[1] + pix86[1] + pix87[1] + pix88[1] + pix89[1]+ pix90[1] +
                             pix91[1] +pix92[1] + pix93[1] + pix94[1] + pix95[1] +  pix96[1]+ pix97[1] + pix98[1] + pix99[1] +
                             pix100[1] + pix101[1]  +pix102[1] + pix103[1] + pix104[1] + pix105[1] +  pix106[1]+ pix107[1] + pix108[1] +
                             pix109[1] + pix110[1] + pix111[1]   +pix112[1] + pix113[1] + pix114[1]+ pix115[1] +  pix116[1]+ pix117[1] +
                             pix118[1] + pix119[1] + pix120[1] + pix121[1] ) / 121);
                       pix5[2] = (double)(( pix1[2] +pix2[2] + pix3[2] + pix4[2] + pix5[2] + pix6[2] + pix7[2] + pix8[2] + pix9[2] +
                             pix10[2] +pix11[2] + pix12[2] + pix13[2] + pix14[2] + pix15[2] + pix16[2] + pix17[2] + pix18[2] +
                             pix19[2] +pix20[2] + pix21[2] + pix22[2] + pix23[2] + pix24[2]+ pix25[2] + pix26[2] + pix27[2] +
                             pix28[2] + pix29[2] + pix30[2]+ pix31[2] + pix32[2] +pix33[2] + pix34[2] + pix35[2] + pix36[2] +
                             pix37[2]+ pix38[2] + pix39[2] + pix40[2] + pix41[2] + pix42[2] + pix43[2]+ pix44[2] + pix45[2] +
                             pix46[2] + pix47[2] + pix48[2] + pix49[2]+ pix50[2] + pix51[2] +pix52[2] + pix53[2] + pix54[2] +
                             pix55[2] +  pix56[2]+ pix57[2] + pix58[2] + pix59[2] + pix60[2] + pix61[2]  +pix62[2] + pix63[2] +
                             pix64[2] + pix65[2] +  pix66[2]+ pix67[2] + pix68[2] + pix69[2] + pix70[2] + pix71[2]   +pix72[2] +
                             pix73[2] + pix74[2]+ pix75[2] +  pix76[2]+ pix77[2] + pix78[2] + pix79[2] + pix80[2] + pix81[2] +
                             pix82[2] + pix83[2]+ pix84[2] + pix85[2] + pix86[2] + pix87[2] + pix88[2] + pix89[2]+ pix90[2] +
                             pix91[2] +pix92[2] + pix93[2] + pix94[2] + pix95[2] +  pix96[2]+ pix97[2] + pix98[2] + pix99[2] +
                             pix100[2] + pix101[2]  +pix102[2] + pix103[2] + pix104[2] + pix105[2] +  pix106[2]+ pix107[2] + pix108[2] +
                             pix109[2] + pix110[2] + pix111[2]   +pix112[2] + pix113[2] + pix114[2]+ pix115[2] +  pix116[2]+ pix117[2] +
                             pix118[2] + pix119[2] + pix120[2] + pix121[2] ) / 121);
                     }else{
                       png_byte* pix122 = &(rowBefore6[(w2 + 6 )* 4]);
                       png_byte* pix123 = &(rowBefore6[(w2 + 5 )* 4]);
                       png_byte* pix124 = &(rowBefore6[(w2 + 4 )* 4]);
                       png_byte* pix125 = &(rowBefore6[(w2 + 3 )* 4]);
                       png_byte* pix126 = &(rowBefore6[(w2 + 2 )* 4]);
                       png_byte* pix127 = &(rowBefore6[(w2 + 1  )* 4]);
                       png_byte* pix128 = &(rowBefore6[(w2 - 6 )* 4]);
                       png_byte* pix129 = &(rowBefore6[(w2 - 5 )* 4]);
                       png_byte* pix130 = &(rowBefore6[(w2 - 4 )* 4]);
                       png_byte* pix131 = &(rowBefore6[(w2 - 3 )* 4]);
                       png_byte* pix132 = &(rowBefore6[(w2 - 2 )* 4]);
                       png_byte* pix133 = &(rowBefore6[(w2 - 1 )* 4]);
                       png_byte* pix134 = &(rowBefore6[w2* 4]);
                       png_byte* pix135= &(rowAfter6[(w2 - 6 )* 4]);
                       png_byte* pix136 = &(rowAfter6[(w2 - 5 )* 4]);
                       png_byte* pix137 = &(rowAfter6[(w2 - 4 )* 4]);
                       png_byte* pix138 = &(rowAfter6[(w2 - 3 )* 4]);
                       png_byte* pix139 = &(rowAfter6[(w2 - 2 )* 4]);
                       png_byte* pix140 = &(rowAfter6[(w2 - 1 )* 4]);
                       png_byte* pix141 = &(rowAfter6[w2* 4]);
                       png_byte* pix142 = &(rowAfter6[(w2 + 6 )* 4]);
                       png_byte* pix143 = &(rowAfter6[(w2 + 5 )* 4]);
                       png_byte* pix144 = &(rowAfter6[(w2 + 4 )* 4]);
                       png_byte* pix145 = &(rowAfter6[(w2 + 3 )* 4]);
                       png_byte* pix146= &(rowAfter6[(w2 + 2 )* 4]);
                       png_byte* pix147 = &(rowAfter6[(w2 + 1 )* 4]);

                       png_byte* pix148 = &(rowAfter3[(w2 + 6 )* 4]);
                       png_byte* pix149= &(rowAfter2[( w2 - 6 ) * 4]);
                       png_byte* pix150 = &(rowAfter2[( w2 + 6 ) * 4]);
                       png_byte* pix151 = &(rowAfter[( w2 + 6 ) * 4]);
                       png_byte* pix152 = &(rowAfter[( w2 - 6 ) * 4]);
                       png_byte* pix153 = &(row[( w2 + 6 ) * 4]);
                       png_byte* pix154 = &(row[( w2 - 6 ) * 4]);
                       png_byte* pix155 = &(rowBefore[( w2 + 6 ) * 4] );
                       png_byte* pix156 = &(rowBefore[( w2 - 6 ) * 4] );
                       png_byte* pix157 = &(rowBefore2[(w2 + 6 )* 4]);
                       png_byte* pix158 = &(rowBefore2[(w2 - 6 )* 4]);
                       png_byte* pix159 = &(rowBefore3[(w2 + 6 )* 4]);
                       png_byte* pix160 = &(rowBefore3[(w2 - 6 )* 4]);
                       png_byte* pix161 = &(rowBefore4[(w2 - 6 )* 4]);
                       png_byte* pix162 = &(rowBefore4[(w2 - 6 )* 4]);
                       png_byte* pix163 = &(rowAfter4[(w2 - 6)* 4]);
                       png_byte* pix164 = &(rowAfter4[(w2 - 6 )* 4]);
                       png_byte* pix165 = &(rowBefore5[(w2 - 6 )* 4]);
                       png_byte* pix166 = &(rowBefore5[(w2 + 6 )* 4]);
                       png_byte* pix167 = &(rowAfter3[(w2 - 6 )* 4]);
                       png_byte* pix168 = &(rowAfter[( w2 + 6 ) * 4]);
                       png_byte* pix169 = &(rowAfter[( w2 - 6 ) * 4]);

                         if(  nrows == 13){
                           pix5[0] = (double)(( pix1[0] +pix2[0] + pix3[0] + pix4[0] + pix5[0] + pix6[0] + pix7[0] + pix8[0] + pix9[0] +
                               pix10[0] +pix11[0] + pix12[0] + pix13[0] + pix14[0] + pix15[0] + pix16[0] + pix17[0] + pix18[0] +
                               pix19[0] +pix20[0] + pix21[0] + pix22[0] + pix23[0] + pix24[0]+ pix25[0] + pix26[0] + pix27[0] +
                               pix28[0] + pix29[0] + pix30[0]+ pix31[0] + pix32[0] +pix33[0] + pix34[0] + pix35[0] + pix36[0] +
                               pix37[0]+ pix38[0] + pix39[0] + pix40[0] + pix41[0] + pix42[0] + pix43[0]+ pix44[0] + pix45[0] +
                               pix46[0] + pix47[0] + pix48[0] + pix49[0]+ pix50[0] + pix51[0] +pix52[0] + pix53[0] + pix54[0] +
                               pix55[0] +  pix56[0]+ pix57[0] + pix58[0] + pix59[0] + pix60[0] + pix61[0]  +pix62[0] + pix63[0] +
                               pix64[0] + pix65[0] +  pix66[0]+ pix67[0] + pix68[0] + pix69[0] + pix70[0] + pix71[0]   +pix72[0] +
                               pix73[0] + pix74[0]+ pix75[0] +  pix76[0]+ pix77[0] + pix78[0] + pix79[0] + pix80[0] + pix81[0] +
                               pix82[0] + pix83[0]+ pix84[0] + pix85[0] + pix86[0] + pix87[0] + pix88[0] + pix89[0]+ pix90[0] +
                               pix91[0] +pix92[0] + pix93[0] + pix94[0] + pix95[0] +  pix96[0]+ pix97[0] + pix98[0] + pix99[0] +
                               pix100[0] + pix101[0]  +pix102[0] + pix103[0] + pix104[0] + pix105[0] +  pix106[0]+ pix107[0] + pix108[0] +
                               pix109[0] + pix110[0] + pix111[0]   +pix112[0] + pix113[0] + pix114[0]+ pix115[0] +  pix116[0]+ pix117[0] +
                               pix118[0] + pix119[0] + pix120[0] + pix121[0] + pix122[0] + pix123[0] + pix124[0]  +pix125[0] + pix126[0] +
                               pix127[0] + pix128[0] +  pix129[0]+ pix130[0] + pix131[0] + pix132[0] + pix133[0] + pix134[0]   +pix135[0] +
                               pix136[0] + pix137[0]+ pix138[0] +  pix139[0]+ pix140[0] + pix141[0] + pix142[0] + pix143[0] + pix144[0] +
                               pix145[0] + pix146[0]+ pix147[0] + pix148[0] + pix149[0] + pix150[0] + pix151[0] + pix152[0]+ pix153[0] +
                               pix154[0] +pix155[0] + pix156[0] + pix157[0] + pix158[0] +  pix159[0]+ pix160[0] + pix161[0] + pix162[0] +
                               pix163[0] + pix164[0]  +pix165[0] + pix166[0] + pix167[0] + pix168[0] +  pix169[0]) / 169);
                         pix5[1] = (double)(( pix1[1] +pix2[1] + pix3[1] + pix4[1] + pix5[1] + pix6[1] + pix7[1] + pix8[1] + pix9[1] +
                               pix10[1] +pix11[1] + pix12[1] + pix13[1] + pix14[1] + pix15[1] + pix16[1] + pix17[1] + pix18[1] +
                               pix19[1] +pix20[1] + pix21[1] + pix22[1] + pix23[1] + pix24[1]+ pix25[1] + pix26[1] + pix27[1] +
                               pix28[1] + pix29[1] + pix30[1]+ pix31[1] + pix32[1] +pix33[1] + pix34[1] + pix35[1] + pix36[1] +
                               pix37[1]+ pix38[1] + pix39[1] + pix40[1] + pix41[1] + pix42[1] + pix43[1]+ pix44[1] + pix45[1] +
                               pix46[1] + pix47[1] + pix48[1] + pix49[1]+ pix50[1] + pix51[1] +pix52[1] + pix53[1] + pix54[1] +
                               pix55[1] +  pix56[1]+ pix57[1] + pix58[1] + pix59[1] + pix60[1] + pix61[1]  +pix62[1] + pix63[1] +
                               pix64[1] + pix65[1] +  pix66[1]+ pix67[1] + pix68[1] + pix69[1] + pix70[1] + pix71[1]   +pix72[1] +
                               pix73[1] + pix74[1]+ pix75[1] +  pix76[1]+ pix77[1] + pix78[1] + pix79[1] + pix80[1] + pix81[1] +
                               pix82[1] + pix83[1]+ pix84[1] + pix85[1] + pix86[1] + pix87[1] + pix88[1] + pix89[1]+ pix90[1] +
                               pix91[1] +pix92[1] + pix93[1] + pix94[1] + pix95[1] +  pix96[1]+ pix97[1] + pix98[1] + pix99[1] +
                               pix100[1] + pix101[1]  +pix102[1] + pix103[1] + pix104[1] + pix105[1] +  pix106[1]+ pix107[1] + pix108[1] +
                               pix109[1] + pix110[1] + pix111[1]   +pix112[1] + pix113[1] + pix114[1]+ pix115[1] +  pix116[1]+ pix117[1] +
                               pix118[1] + pix119[1] + pix120[1] + pix121[1] + pix122[1] + pix123[1] + pix124[1]  +pix125[1] + pix126[1] +
                               pix127[1] + pix128[1] +  pix129[1]+ pix130[1] + pix131[1] + pix132[1] + pix133[1] + pix134[1]   +pix135[1] +
                               pix136[1] + pix137[1]+ pix138[1] +  pix139[1]+ pix140[1] + pix141[1] + pix142[1] + pix143[1] + pix144[1] +
                               pix145[1] + pix146[1]+ pix147[1] + pix148[1] + pix149[1] + pix150[1] + pix151[1] + pix152[1]+ pix153[1] +
                               pix154[1] +pix155[1] + pix156[1] + pix157[1] + pix158[1] +  pix159[1]+ pix160[1] + pix161[1] + pix162[1] +
                               pix163[1] + pix164[1]  +pix165[1] + pix166[1] + pix167[1] + pix168[1] +  pix169[1]) / 169);
                         pix5[2] = (double)(( pix1[2] +pix2[2] + pix3[2] + pix4[2] + pix5[2] + pix6[2] + pix7[2] + pix8[2] + pix9[2] +
                               pix10[2] +pix11[2] + pix12[2] + pix13[2] + pix14[2] + pix15[2] + pix16[2] + pix17[2] + pix18[2] +
                               pix19[2] +pix20[2] + pix21[2] + pix22[2] + pix23[2] + pix24[2]+ pix25[2] + pix26[2] + pix27[2] +
                               pix28[2] + pix29[2] + pix30[2]+ pix31[2] + pix32[2] +pix33[2] + pix34[2] + pix35[2] + pix36[2] +
                               pix37[2]+ pix38[2] + pix39[2] + pix40[2] + pix41[2] + pix42[2] + pix43[2]+ pix44[2] + pix45[2] +
                               pix46[2] + pix47[2] + pix48[2] + pix49[2]+ pix50[2] + pix51[2] +pix52[2] + pix53[2] + pix54[2] +
                               pix55[2] +  pix56[2]+ pix57[2] + pix58[2] + pix59[2] + pix60[2] + pix61[2]  +pix62[2] + pix63[2] +
                               pix64[2] + pix65[2] +  pix66[2]+ pix67[2] + pix68[2] + pix69[2] + pix70[2] + pix71[2]   +pix72[2] +
                               pix73[2] + pix74[2]+ pix75[2] +  pix76[2]+ pix77[2] + pix78[2] + pix79[2] + pix80[2] + pix81[2] +
                               pix82[2] + pix83[2]+ pix84[2] + pix85[2] + pix86[2] + pix87[2] + pix88[2] + pix89[2]+ pix90[2] +
                               pix91[2] +pix92[2] + pix93[2] + pix94[2] + pix95[2] +  pix96[2]+ pix97[2] + pix98[2] + pix99[2] +
                               pix100[2] + pix101[2]  +pix102[2] + pix103[2] + pix104[2] + pix105[2] +  pix106[2]+ pix107[2] + pix108[2] +
                               pix109[2] + pix110[2] + pix111[2]   +pix112[2] + pix113[2] + pix114[2]+ pix115[2] +  pix116[2]+ pix117[2] +
                               pix118[2] + pix119[2] + pix120[2] + pix121[2]  + pix122[2] + pix123[2] + pix124[2]  +pix125[2] + pix126[2] +
                               pix127[2] + pix128[2] +  pix129[2]+ pix130[2] + pix131[2] + pix132[2] + pix133[2] + pix134[2]   +pix135[2] +
                               pix136[2] + pix137[2]+ pix138[2] +  pix139[2]+ pix140[2] + pix141[2] + pix142[2] + pix143[2] + pix144[2] +
                               pix145[2] + pix146[2]+ pix147[2] + pix148[2] + pix149[2] + pix150[2] + pix151[2] + pix152[2]+ pix153[2] +
                               pix154[2] +pix155[2] + pix156[2] + pix157[2] + pix158[2] +  pix159[2]+ pix160[2] + pix161[2] + pix162[2] +
                               pix163[2] + pix164[2]  +pix165[2] + pix166[2] + pix167[2] + pix168[2] +  pix169[2]) / 169);
                       }else{
                         png_byte* pix170 = &(rowBefore7[(w2 - 7 )* 4]);
                         png_byte* pix171 = &(rowBefore7[(w2 + 7 )* 4]);
                         png_byte* pix172 = &(rowBefore7[(w2 + 6 )* 4]);
                         png_byte* pix173 = &(rowBefore7[(w2 + 5 )* 4]);
                         png_byte* pix174 = &(rowBefore7[(w2 + 4 )* 4]);
                         png_byte* pix175 = &(rowBefore7[(w2 + 3 )* 4]);
                         png_byte* pix176 = &(rowBefore7[(w2 + 2 )* 4]);
                         png_byte* pix177 = &(rowBefore7[(w2 + 1  )* 4]);
                         png_byte* pix178 = &(rowBefore7[(w2 - 6 )* 4]);
                         png_byte* pix179 = &(rowBefore7[(w2 - 5 )* 4]);
                         png_byte* pix180 = &(rowBefore7[(w2 - 4 )* 4]);
                         png_byte* pix181 = &(rowBefore7[(w2 - 3 )* 4]);
                         png_byte* pix182 = &(rowBefore7[(w2 - 2 )* 4]);
                         png_byte* pix183 = &(rowBefore7[(w2 - 1 )* 4]);
                         png_byte* pix184 = &(rowBefore7[w2* 4]);
                         png_byte* pix185= &(rowAfter7[(w2 - 6 )* 4]);
                         png_byte* pix186 = &(rowAfter7[(w2 - 5 )* 4]);
                         png_byte* pix187 = &(rowAfter7[(w2 - 4 )* 4]);
                         png_byte* pix188 = &(rowAfter7[(w2 - 3 )* 4]);
                         png_byte* pix189 = &(rowAfter7[(w2 - 2 )* 4]);
                         png_byte* pix190 = &(rowAfter7[(w2 - 1 )* 4]);
                         png_byte* pix191 = &(rowAfter7[w2* 4]);
                         png_byte* pix192 = &(rowAfter7[(w2 + 6 )* 4]);
                         png_byte* pix193 = &(rowAfter7[(w2 + 5 )* 4]);
                         png_byte* pix194 = &(rowAfter7[(w2 + 4 )* 4]);
                         png_byte* pix195 = &(rowAfter7[(w2 + 3 )* 4]);
                         png_byte* pix196= &(rowAfter7[(w2 + 2 )* 4]);
                         png_byte* pix197 = &(rowAfter7[(w2 + 1 )* 4]);
                         png_byte* pix198 = &(rowAfter3[(w2 + 7 )* 4]);
                         png_byte* pix199= &(rowAfter2[( w2 - 7 ) * 4]);
                         png_byte* pix200 = &(rowAfter2[( w2 + 7 ) * 4]);
                         png_byte* pix201 = &(rowAfter[( w2 + 7 ) * 4]);
                         png_byte* pix202 = &(rowAfter[( w2 - 7 ) * 4]);
                         png_byte* pix203 = &(row[( w2 + 7 ) * 4]);
                         png_byte* pix204 = &(row[( w2 - 7 ) * 4]);
                         png_byte* pix205 = &(rowBefore[( w2 + 7 ) * 4] );
                         png_byte* pix206 = &(rowBefore[( w2 - 7 ) * 4] );
                         png_byte* pix207 = &(rowBefore2[(w2 + 7 )* 4]);
                         png_byte* pix208 = &(rowBefore2[(w2 - 7 )* 4]);
                         png_byte* pix209 = &(rowBefore3[(w2 + 7 )* 4]);
                         png_byte* pix210 = &(rowBefore3[(w2 - 7 )* 4]);
                         png_byte* pix211 = &(rowBefore4[(w2 - 7 )* 4]);
                         png_byte* pix212 = &(rowBefore4[(w2 - 7 )* 4]);
                         png_byte* pix213 = &(rowAfter4[(w2 - 7)* 4]);
                         png_byte* pix214 = &(rowAfter4[(w2 - 7 )* 4]);
                         png_byte* pix215 = &(rowBefore5[(w2 - 7 )* 4]);
                         png_byte* pix216 = &(rowBefore5[(w2 + 7 )* 4]);
                         png_byte* pix217 = &(rowAfter3[(w2 - 7 )* 4]);
                         png_byte* pix218 = &(rowAfter[( w2 + 7 ) * 4]);
                         png_byte* pix219 = &(rowAfter[( w2 - 7 ) * 4]);
                         png_byte* pix220= &(rowAfter7[(w2 - 7 )* 4]);
                         png_byte* pix221 = &(rowAfter7[(w2 + 7 )* 4]);
                         png_byte* pix222 = &(rowBefore7[(w2 - 7 )* 4]);
                         png_byte* pix223 = &(rowBefore7[(w2 + 7 )* 4]);
                         png_byte* pix224 = &(rowBefore6[(w2 - 7 )* 4]);
                         png_byte* pix225 = &(rowBefore6[(w2 + 7 )* 4]);
                         if(  nrows == 15){
                           pix5[0] = (double)(( pix1[0] +pix2[0] + pix3[0] + pix4[0] + pix5[0] + pix6[0] + pix7[0] + pix8[0] + pix9[0] +
                               pix10[0] +pix11[0] + pix12[0] + pix13[0] + pix14[0] + pix15[0] + pix16[0] + pix17[0] + pix18[0] +
                               pix19[0] +pix20[0] + pix21[0] + pix22[0] + pix23[0] + pix24[0]+ pix25[0] + pix26[0] + pix27[0] +
                               pix28[0] + pix29[0] + pix30[0]+ pix31[0] + pix32[0] +pix33[0] + pix34[0] + pix35[0] + pix36[0] +
                               pix37[0]+ pix38[0] + pix39[0] + pix40[0] + pix41[0] + pix42[0] + pix43[0]+ pix44[0] + pix45[0] +
                               pix46[0] + pix47[0] + pix48[0] + pix49[0]+ pix50[0] + pix51[0] +pix52[0] + pix53[0] + pix54[0] +
                               pix55[0] +  pix56[0]+ pix57[0] + pix58[0] + pix59[0] + pix60[0] + pix61[0]  +pix62[0] + pix63[0] +
                               pix64[0] + pix65[0] +  pix66[0]+ pix67[0] + pix68[0] + pix69[0] + pix70[0] + pix71[0]   +pix72[0] +
                               pix73[0] + pix74[0]+ pix75[0] +  pix76[0]+ pix77[0] + pix78[0] + pix79[0] + pix80[0] + pix81[0] +
                               pix82[0] + pix83[0]+ pix84[0] + pix85[0] + pix86[0] + pix87[0] + pix88[0] + pix89[0]+ pix90[0] +
                               pix91[0] +pix92[0] + pix93[0] + pix94[0] + pix95[0] +  pix96[0]+ pix97[0] + pix98[0] + pix99[0] +
                               pix100[0] + pix101[0]  +pix102[0] + pix103[0] + pix104[0] + pix105[0] +  pix106[0]+ pix107[0] + pix108[0] +
                               pix109[0] + pix110[0] + pix111[0]   +pix112[0] + pix113[0] + pix114[0]+ pix115[0] +  pix116[0]+ pix117[0] +
                               pix118[0] + pix119[0] + pix120[0] + pix121[0] + pix122[0] + pix123[0] + pix124[0]  +pix125[0] + pix126[0] +
                               pix127[0] + pix128[0] +  pix129[0]+ pix130[0] + pix131[0] + pix132[0] + pix133[0] + pix134[0]   +pix135[0] +
                               pix136[0] + pix137[0]+ pix138[0] +  pix139[0]+ pix140[0] + pix141[0] + pix142[0] + pix143[0] + pix144[0] +
                               pix145[0] + pix146[0]+ pix147[0] + pix148[0] + pix149[0] + pix150[0] + pix151[0] + pix152[0]+ pix153[0] +
                               pix154[0] +pix155[0] + pix156[0] + pix157[0] + pix158[0] +  pix159[0]+ pix160[0] + pix161[0] + pix162[0] +
                               pix163[0] + pix164[0]  +pix165[0] + pix166[0] + pix167[0] + pix168[0] +  pix169[0] +
                               pix170[0] + pix171[0]  +pix172[0] + pix173[0] + pix174[0] + pix175[0] +  pix176[0]+ pix177[0] + pix178[0] +
                               pix179[0] + pix180[0] + pix181[0]   +pix182[0] + pix183[0] + pix184[0]+ pix185[0] +  pix186[0]+ pix187[0] +
                               pix188[0] + pix189[0] + pix190[0] + pix191[0] + pix192[0] + pix193[0] + pix194[0]  +pix195[0] + pix196[0] +
                               pix197[0] + pix198[0] +  pix199[0]+ pix200[0] + pix201[0] + pix202[0] + pix203[0] + pix204[0]   +pix205[0] +
                               pix206[0] + pix207[0]+ pix208[0] +  pix209[0]+ pix210[0] + pix211[0] + pix212[0] + pix213[0] + pix214[0] +
                               pix215[0] + pix216[0] + pix217[0] + pix218[0] + pix219[0] + pix220[0] + pix221[0] + pix222[0]+ pix223[0] +
                               pix224[0] +pix225[0] ) / 225);
                         pix5[1] = (double)(( pix1[1] +pix2[1] + pix3[1] + pix4[1] + pix5[1] + pix6[1] + pix7[1] + pix8[1] + pix9[1] +
                               pix10[1] +pix11[1] + pix12[1] + pix13[1] + pix14[1] + pix15[1] + pix16[1] + pix17[1] + pix18[1] +
                               pix19[1] +pix20[1] + pix21[1] + pix22[1] + pix23[1] + pix24[1]+ pix25[1] + pix26[1] + pix27[1] +
                               pix28[1] + pix29[1] + pix30[1]+ pix31[1] + pix32[1] +pix33[1] + pix34[1] + pix35[1] + pix36[1] +
                               pix37[1]+ pix38[1] + pix39[1] + pix40[1] + pix41[1] + pix42[1] + pix43[1]+ pix44[1] + pix45[1] +
                               pix46[1] + pix47[1] + pix48[1] + pix49[1]+ pix50[1] + pix51[1] +pix52[1] + pix53[1] + pix54[1] +
                               pix55[1] +  pix56[1]+ pix57[1] + pix58[1] + pix59[1] + pix60[1] + pix61[1]  +pix62[1] + pix63[1] +
                               pix64[1] + pix65[1] +  pix66[1]+ pix67[1] + pix68[1] + pix69[1] + pix70[1] + pix71[1]   +pix72[1] +
                               pix73[1] + pix74[1]+ pix75[1] +  pix76[1]+ pix77[1] + pix78[1] + pix79[1] + pix80[1] + pix81[1] +
                               pix82[1] + pix83[1]+ pix84[1] + pix85[1] + pix86[1] + pix87[1] + pix88[1] + pix89[1]+ pix90[1] +
                               pix91[1] +pix92[1] + pix93[1] + pix94[1] + pix95[1] +  pix96[1]+ pix97[1] + pix98[1] + pix99[1] +
                               pix100[1] + pix101[1]  +pix102[1] + pix103[1] + pix104[1] + pix105[1] +  pix106[1]+ pix107[1] + pix108[1] +
                               pix109[1] + pix110[1] + pix111[1]   +pix112[1] + pix113[1] + pix114[1]+ pix115[1] +  pix116[1]+ pix117[1] +
                               pix118[1] + pix119[1] + pix120[1] + pix121[1] + pix122[1] + pix123[1] + pix124[1]  +pix125[1] + pix126[1] +
                               pix127[1] + pix128[1] +  pix129[1]+ pix130[1] + pix131[1] + pix132[1] + pix133[1] + pix134[1]   +pix135[1] +
                               pix136[1] + pix137[1]+ pix138[1] +  pix139[1]+ pix140[1] + pix141[1] + pix142[1] + pix143[1] + pix144[1] +
                               pix145[1] + pix146[1]+ pix147[1] + pix148[1] + pix149[1] + pix150[1] + pix151[1] + pix152[1]+ pix153[1] +
                               pix154[1] +pix155[1] + pix156[1] + pix157[1] + pix158[1] +  pix159[1]+ pix160[1] + pix161[1] + pix162[1] +
                               pix163[1] + pix164[1]  +pix165[1] + pix166[1] + pix167[1] + pix168[1] +  pix169[1]+
                               pix170[1] + pix171[1]  +pix172[1] + pix173[1] + pix174[1] + pix175[1] +  pix176[1]+ pix177[1] + pix178[1] +
                               pix179[1] + pix180[1] + pix181[1]   +pix182[1] + pix183[1] + pix184[1]+ pix185[1] +  pix186[1]+ pix187[1] +
                               pix188[1] + pix189[1] + pix190[1] + pix191[1] + pix192[1] + pix193[1] + pix194[1]  +pix195[1] + pix196[1] +
                               pix197[1] + pix198[1] +  pix199[1]+ pix200[1] + pix201[1] + pix202[1] + pix203[1] + pix204[1]   +pix205[1] +
                               pix206[1] + pix207[1]+ pix208[1] +  pix209[1]+ pix210[1] + pix211[1] + pix212[1] + pix213[1] + pix214[1] +
                               pix215[1] + pix216[1] + pix217[1] + pix218[1] + pix219[1] + pix220[1] + pix221[1] + pix222[1]+ pix223[1] +
                               pix224[1] +pix225[1] ) / 225);
                         pix5[2] = (double)(( pix1[2] +pix2[2] + pix3[2] + pix4[2] + pix5[2] + pix6[2] + pix7[2] + pix8[2] + pix9[2] +
                               pix10[2] +pix11[2] + pix12[2] + pix13[2] + pix14[2] + pix15[2] + pix16[2] + pix17[2] + pix18[2] +
                               pix19[2] +pix20[2] + pix21[2] + pix22[2] + pix23[2] + pix24[2]+ pix25[2] + pix26[2] + pix27[2] +
                               pix28[2] + pix29[2] + pix30[2]+ pix31[2] + pix32[2] +pix33[2] + pix34[2] + pix35[2] + pix36[2] +
                               pix37[2]+ pix38[2] + pix39[2] + pix40[2] + pix41[2] + pix42[2] + pix43[2]+ pix44[2] + pix45[2] +
                               pix46[2] + pix47[2] + pix48[2] + pix49[2]+ pix50[2] + pix51[2] +pix52[2] + pix53[2] + pix54[2] +
                               pix55[2] +  pix56[2]+ pix57[2] + pix58[2] + pix59[2] + pix60[2] + pix61[2]  +pix62[2] + pix63[2] +
                               pix64[2] + pix65[2] +  pix66[2]+ pix67[2] + pix68[2] + pix69[2] + pix70[2] + pix71[2]   +pix72[2] +
                               pix73[2] + pix74[2]+ pix75[2] +  pix76[2]+ pix77[2] + pix78[2] + pix79[2] + pix80[2] + pix81[2] +
                               pix82[2] + pix83[2]+ pix84[2] + pix85[2] + pix86[2] + pix87[2] + pix88[2] + pix89[2]+ pix90[2] +
                               pix91[2] +pix92[2] + pix93[2] + pix94[2] + pix95[2] +  pix96[2]+ pix97[2] + pix98[2] + pix99[2] +
                               pix100[2] + pix101[2]  +pix102[2] + pix103[2] + pix104[2] + pix105[2] +  pix106[2]+ pix107[2] + pix108[2] +
                               pix109[2] + pix110[2] + pix111[2]   +pix112[2] + pix113[2] + pix114[2]+ pix115[2] +  pix116[2]+ pix117[2] +
                               pix118[2] + pix119[2] + pix120[2] + pix121[2]  + pix122[2] + pix123[2] + pix124[2]  +pix125[2] + pix126[2] +
                               pix127[2] + pix128[2] +  pix129[2]+ pix130[2] + pix131[2] + pix132[2] + pix133[2] + pix134[2]   +pix135[2] +
                               pix136[2] + pix137[2]+ pix138[2] +  pix139[2]+ pix140[2] + pix141[2] + pix142[2] + pix143[2] + pix144[2] +
                               pix145[2] + pix146[2]+ pix147[2] + pix148[2] + pix149[2] + pix150[2] + pix151[2] + pix152[2]+ pix153[2] +
                               pix154[2] +pix155[2] + pix156[2] + pix157[2] + pix158[2] +  pix159[2]+ pix160[2] + pix161[2] + pix162[2] +
                               pix163[2] + pix164[2]  +pix165[2] + pix166[2] + pix167[2] + pix168[2] +  pix169[2]+
                               pix170[2] + pix171[2]  +pix172[2] + pix173[2] + pix174[2] + pix175[2] +  pix176[2]+ pix177[2] + pix178[2] +
                               pix179[2] + pix180[2] + pix181[2]   +pix182[2] + pix183[2] + pix184[2]+ pix185[2] +  pix186[2]+ pix187[2] +
                               pix188[2] + pix189[2] + pix190[2] + pix191[2] + pix192[2] + pix193[2] + pix194[2]  +pix195[2] + pix196[2] +
                               pix197[2] + pix198[2] +  pix199[2]+ pix200[2] + pix201[2] + pix202[2] + pix203[2] + pix204[2]   +pix205[2] +
                               pix206[2] + pix207[2]+ pix208[2] +  pix209[2]+ pix210[2] + pix211[2] + pix212[2] + pix213[2] + pix214[2] +
                               pix215[2] + pix216[2] + pix217[2] + pix218[2] + pix219[2] + pix220[2] + pix221[2] + pix222[2]+ pix223[2] +
                               pix224[2] +pix225[2] ) / 225);
                       }
                       }
                     }

                   }





                 }

               }

             }




     }}



   }
//acaba

//  printf("FINNN id %i  inicio %i  final %i  \n" ,id, istart,iend);

 }

      write_png_file(argv[2]);



        free(res);
        return 0;
}
