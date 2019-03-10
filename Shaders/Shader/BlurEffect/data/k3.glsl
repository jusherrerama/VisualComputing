#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif
uniform sampler2D texture;
uniform vec2 texOffset;
varying vec4 vertColor;
varying vec4 vertTexCoord;
const vec4 lumcoeff = vec4(0.299, 0.587, 0.114, 0);
void main() {
const int kernel =3;
const int ndata = kernel *kernel;
vec2 tc[ndata];
vec4 col[ndata];
int aux = 0;
int l1 =  int(-floor(kernel));
int l2 =  int(floor(kernel));
for(int i = l1	 ;i <= l2	;i++)
	{
		for(int j = l1	 ; j <= l2	;j++)
		{
			tc[aux] = vertTexCoord.st + vec2(i*texOffset.s, j*texOffset.t);
			aux  = aux + 1;
		}
	}
for(int i = 0	 ;i < kernel*kernel	;i++)
	{
	col[i] = texture2D(texture, tc[i]);
	}
vec4 sum;
for(int i = 0	 ;i < kernel*kernel	;i++)
	{
	sum =  sum + col[i];
	}
sum =  sum/ndata;
  gl_FragColor = vec4(sum.rgb, 1.0) * vertColor;
}
