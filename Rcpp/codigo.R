## Ajustes de curva de temperatura
## 31/05/2016, revisado em 07/06/2016
## Marcelo Azevedo Costa

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
 nsim   <- 10000
 passos <- 34


 ## A SER IMPLEMENTADO EM RCPP.
 ## simulacoes <- function(passos, nsim, betas){ . }
 saidas <- matrix(0, nrow=passos, ncol=nsim)
 for(s in 1:nsim){
   ## Predicoes futuras via simulacao
   saidas[1,s] <- betas[1] + betas[2]*inicio + rnorm(1, sd=sigma)

   for(cont in 2:passos){
      saidas[cont,s] <- betas[1] + betas[2]*saidas[cont-1,s] + rnorm(1, sd=sigma)
   }
 }


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


 