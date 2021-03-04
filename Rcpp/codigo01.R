## R e C/C++
## Data: 22/10/2019
## Prof. Marcelo Azevedo Costa

## Please download and install the appropriate version of Rtools:
## http://cran.r-project.org/bin/windows/Rtools/

 fibR <- function(n){
    if(n==0) return(0)
    if(n==1) return(1)
    return(fibR(n-1) + fibR(n-2))
 }

 ## Utilizando o pacote "Rcpp"
 require(Rcpp)
  
 ## C\C++ function 
 incltxt <- '
   #include <Rcpp.h>
 
   // [[Rcpp::export]]
   int fibonacci(const int x) {
     if (x == 0) return(0);
     if (x == 1) return(1);
     return (fibonacci(x - 1)) + fibonacci(x - 2);
   }'

 sourceCpp(code=incltxt)

 system.time( fibR(30) )
 system.time( fibonacci(30) )

 fibR(27)
 fibonacci(27)
