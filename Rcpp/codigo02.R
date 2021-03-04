## Programa para uso de funcoes C\C++ em R
## Data: 22/10/2019
## Prof. Marcelo A Costa

 rm(list=ls(all=TRUE))

 require(Rcpp)

 sourceCpp(code='
   #include <Rcpp.h>
   #include <math.h>
   // [[Rcpp::export]]
   double distancia(const double x0, const double y0,
                    const double x1, const double y1) {
         double d;
         d  = (x0-x1)*(x0-x1);
         d += (y0-y1)*(y0-y1);
         d  = sqrt(d);
         return(d);
   }'
 )

 ## - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ## Outra opcao
 codigo <-'
      double fdist(double x0, double y0, double x1, double y1){
      #include <math.h>

      double d;

      d  = (x0-x1)*(x0-x1);
      d += (y0-y1)*(y0-y1);
      d  = sqrt(d);

      return d;
      }'

 cppFunction(depends = "Rcpp", code=codigo)

 ## - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ## Distancia em graus decimais
 sourceCpp(code='
   #include <Rcpp.H>
   #include <math.h>
   // [[Rcpp::export]]
   double distLatLong(double lambda1, double phi1,
                      double lambda2, double phi2) {

         lambda1 *= 0.01745329;
         phi1    *= 0.01745329;
         lambda2 *= 0.01745329;
         phi2    *= 0.01745329;

         double d    = 2*6378.14;
         double aux  = 0;
         double aux2 = 0;

         aux  = sin( (phi2 - phi1)/2 );
         aux *= aux;
         aux2 = sin( (lambda2 - lambda1)/2 );
         aux2 *= aux2;
         aux += cos(phi1)*cos(phi2)*aux2;
         d *= asin( sqrt(aux) );

         return(d);
   }'
 )

