## Programa para uso de funcoes do R no Rcpp
## Data: 30/05/2016
## Prof. Marcelo A Costa

 require(Rcpp)
 require(RcppArmadillo)

 ## pnorm(q, mean = 0, sd = 1, lower.tail = TRUE, log.p = FALSE)
 pnorm(1, 0, 1, 1, 0)
 dnorm(1, 0, 1, 0)


 codigo <- '
   NumericVector RcppAleat(const double media){

   #include<math.h>

   Rcpp::NumericVector b(3);
   b[0] = R::pnorm(media, 0, 1, 1, 0);
   b[1] = R::dnorm(media, 0, 1, 0);
   b[2] = R::rnorm(0, 1);

   return b;
   }
 '

 ## create the compiled function
 cppFunction(depends = "Rcpp", code=codigo)


 RcppAleat(1.5)

