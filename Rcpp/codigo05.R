## Programa para uso de funcoes C\C++ em R
## Data: 23/10/2019
## Prof. Marcelo A Costa

 rm(list=ls(all=TRUE))

 require(Rcpp)
 require(RcppArmadillo)

 a <- matrix(c(0.5, 0.1, 0.1, 0.5), nrow=2)
 u <- matrix(rnorm(20), ncol=2)

 ## Let's start with the R version
 rSim <- function(coeff, errors){
    simdata <- matrix(0, nrow(errors), ncol(errors))
    for(row in 2:nrow(errors)) {
       simdata[row,] = coeff%*%simdata[(row-1),] + errors[row,]
    }
    return(simdata)
 }

 rData <- rSim(a,u)

 ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ## Compile C++ code on the fly
 codigo <- '
   arma::mat RcppSim(arma::mat coef, arma::mat error) {

   int m = error.n_rows;
   int n = error.n_cols;
   arma::mat simdata(m,n);
   // Zera a primeira linha (indice 0) da matriz "simdata"
   simdata.row(0) = arma::zeros<arma::mat>(1,n);
   for(int row=1; row<m; row++){
     simdata.row(row) = simdata.row(row-1)*trans(coef)
                        + error.row(row);
   }

   return(simdata);
 }
 '

 ## create the compiled function
 cppFunction(depends = "RcppArmadillo", code=codigo)

 ## Testando ...
 rcppData <- RcppSim(a,u)

 ## Checking results
 cbind(rData, rcppData)
 all.equal(rData, rcppData)

