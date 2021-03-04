## Programa para uso de funcoes C\C++ em R
## Data: 22/10/2019
## Prof. Marcelo A Costa

 rm(list=ls(all=TRUE))

 require(Rcpp)

 codigo <- '
 NumericVector RcppFun(NumericVector xa, NumericVector xb) {
 
 int n_xa = xa.size();
 int n_xb = xb.size();

 Rcpp::NumericVector xab(n_xa + n_xb - 1);
 for(int i=0; i<n_xa; i++)
   for(int j=0; j<n_xb; j++)
     xab[i+j] += xa[i] * xb[j];

 return xab;
 }'

 cppFunction(depends = "Rcpp", code=codigo)


 ## Teste da funcao
 RcppFun(1:4, 2:5)

 a <- rnorm(4)
 b <- rnorm(4) 
 RcppFun(a,b)



