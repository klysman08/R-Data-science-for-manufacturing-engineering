# Lista 9
# Klysman Rezende Alves Vieira

# 04/03/2021

## MODELO ORIGINAL: "codigo.R"

rm(list=ls(all=TRUE))

dados <- read.csv("dadosTemp.csv")
dados <- subset(dados, tempo < 18) 
dados <- aggregate(temperatura ~ tempo, data=dados, FUN=mean)

dados$x <- c(NA, dados$temperatura[-dim(dados)[1]])

## Retira um ponto "discrepante"
dados <- dados[-2,]

plot(temperatura ~ tempo, data=dados, pch=19, col="blue")
plot(temperatura ~ x, data=dados, pch=19, col="blue", xlab="temperatura(t-1)")

modelo <- lm(temperatura ~ x, data=dados)
summary(modelo) ## Adjusted R-squared:  0.9983

## PARAMETROS DAS SIMULACOES
betas  <- coefficients(modelo)
sigma  <- sqrt( anova(modelo)["Residuals","Mean Sq"] )
inicio <- dados[17, "temperatura"] ## Ultima temperatura medida
nsim   <- 50000
passos <- 34

#==============================================================================
#==============================================================================

## VESÃO R A SER IMPLEMENTADO EM RCPP.
## simulacoes <- function(passos, nsim, betas){ . }


#simulacoes_R <- function(passos, nsim, betas, sigma, inicio){
  
  
saidas <- matrix(0, nrow=passos, ncol=nsim)

tempoInicialR <- Sys.time()
for(s in 1:nsim){
  ## Predicoes futuras via simulacao
  saidas[1,s] <- betas[1] + betas[2]*inicio + rnorm(1, sd=sigma)
  
  for(cont in 2:passos){
    saidas[cont,s] <- betas[1] + betas[2]*saidas[cont-1,s] + rnorm(1, sd=sigma)
  }
}

return(saidas)




fit   <- apply(saidas, 1, mean)
lwr   <- apply(saidas, 1, function(x) quantile(x, probs=0.025))
upr   <- apply(saidas, 1, function(x) quantile(x, probs=0.975))
tempo <- 18:(17+passos)

plot(temperatura ~ tempo, data=dados, pch=19, col="blue", ylim=c(0, 700),
     xlim=c(0, 17+passos) ); grid()
lines(fit ~ tempo, col="red", lwd=2)
lines(lwr ~ tempo, col="blue", lty=2)
lines(upr ~ tempo, col="blue", lty=2)
abline(v=46, lty=3, col="black")

dt <- as.data.frame(cbind(tempo,fit,lwr,upr))

tempoFinalR <- Sys.time()
tempo_gasto_em_R <- tempoFinalR - tempoInicialR
tempo_gasto_em_R

# teste_saidas <- simulacoes_R(34,10000,betas, 2.792, 242.65)

#==============================================================================
#==============================================================================

# QUESTÃO 1 
# Como deve ser a função
# RcppSimulações (passos, nsim, betas, sigma, inicio)

require(Rcpp)

## PARAMETROS DAS SIMULACOES
betas  <- coefficients(modelo)
sigma  <- sqrt( anova(modelo)["Residuals","Mean Sq"] )
inicio <- dados[17, "temperatura"] ## Ultima temperatura medida
nsim   <- 50000
passos <- 34


tempoInicialC <- Sys.time()

#simulacoes_RCPP <- function(passos, nsim, betas, sigma, inicio){


codigo <- '
 NumericMatrix RcppSimulacoes( NumericVector betas, double sigma, double inicio, int passos, int nsim ){
 
 #include<math.h>

	NumericMatrix saidas(passos,nsim);
	
	## Predicoes futuras via simulacao

  for(int s = 1; s < nsim; s++)
  {
    saidas[1,s] = betas[1] + betas[2]*inicio + R::rnorm(1,sigma);
    
    for(int cont = 1; cont < passos; cont++)
      {
        saidas[cont,s] <- betas[1] + betas[2]*saidas[cont-1,s] + rnorm(1, sd=sigma)
      }
   }

	return(saidas);

 }

'
cppFunction (depends = "Rcpp", code = codigo)

fit   <- apply(saidas, 1, mean)
lwr   <- apply(saidas, 1, function(x) quantile(x, probs=0.025))
upr   <- apply(saidas, 1, function(x) quantile(x, probs=0.975))
tempo <- 18:(17+passos)

plot(temperatura ~ tempo, data=dados, pch=19, col="blue", ylim=c(0, 700),
     xlim=c(0, 17+passos) ); grid()
lines(fit ~ tempo, col="red", lwd=2)
lines(lwr ~ tempo, col="blue", lty=2)
lines(upr ~ tempo, col="blue", lty=2)
abline(v=46, lty=3, col="black")

dt <- as.data.frame(cbind(tempo,fit,lwr,upr))

tempoFinalC <- Sys.time()
tempo_gasto_em_RCPP <- tempoFinalC - tempoInicialC
tempo_gasto_em_RCPP

#==============================================================================
#==============================================================================

# QUESTÃO 2

#========= Tempo em código R:

tempo_gasto_em_R

#========= Tempo usando Rcpp em código C:

tempo_gasto_em_RCPP
