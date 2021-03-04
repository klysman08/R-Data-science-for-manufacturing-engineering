## Programa para uso de funcoes C\C++ em R
## Data: 06/11/2013
## Prof. Marcelo A Costa
## Exemplo pg. 26

 rm(list=ls(all=TRUE))

 require(Rcpp)

 codigo <- '
 NumericVector RcppDist(double x0, double y0, NumericVector vx, NumericVector vy){
  
   Rcpp::NumericVector dist( vx.size() );

   for(int i=0; i<vx.size(); i++)
      dist[i] = sqrt( (x0-vx[i])*(x0-vx[i]) + (y0-vy[i])*(y0-vy[i]) );
   return (dist);
 }
 '

 cppFunction(depends = "Rcpp", code=codigo)

 ## Teste da funcao
 RcppDist(0, 1, c(1,2,3,4), c(7,5,9,3))
 distancias <- RcppDist(0, 1, c(1,2,3,4), c(7,5,9,3))

