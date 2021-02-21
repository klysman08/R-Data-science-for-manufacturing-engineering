# Meu primeiro codigo R
# Klysman Rezende
# 04/12/2020

# Comando basico: atribuicao
a <- 5
a = 5
a < - 5

# Criacao de vetores
v <- c(4, 7, 9)
length(v)  # Comprimento do vetor
v[2]       # acessando uma posicao

v <- c('a', 'h', 'covid', 1) 
v[3]

letters[1:5]
LETTERS[1:10] 
LETTERS

b <- c(a, 9, 11)

b <- paste("fig", a, sep="_")
b <- 1:7
b <- seq(1, 7, by=0.01)
b <- seq(1, 7, length=49)

# Vetor com variaveis aleatorias
V <- rexp(10)
v <- rnorm(10, mean = 5, sd = 3)
# acessando elementos via manipulacao condicional
v <- v[v < 4.5]

v <- c(1, 4, 7)
v < 5

# detalhes
v <- rnorm(10)
v[1:3]       # soh acessando
v[c(1,3,8)]  # soh acessando

# Criacao e Manipulacao de Matrizes
m <- matrix(1:6, 3, 3, byrow = TRUE)
m <- matrix(data = 1:9, nrow = 3, ncol = 3)

v <- c(1:6, NA, 8:9)
m <- matrix(v, nrow=3, byrow=TRUE)

matrix(v, nrow=3, byrow=TRUE)
matrix(v, nrow=3, byrow=FALSE)
matrix(NA, nrow=5, ncol=4)

# Tome cuidado com esse comando
v <- c(1:6, 'NA', 8:9)
m <- matrix(v, nrow=3, byrow=TRUE)
class(m)   # identificando o tipo do objeto
class(v)
v <- 1:10
class(v)

# Manipulacao dos elementos da matriz
v <- c(1:9)
m <- matrix(v, 3, 7)
dim(m)  # dimensao - linhas e colunas
nrow(m) # numero de linhas
ncol(m) # numero de colunas

# Acessando diretamente linhas e colunas
m[2,1] # m[numero da linha, numero da coluna]
m[1,]  # todos os elementos daquela linha
m[,2]  # todos os elementos daquela coluna
m[,c(3,6)] # todos as linhas das colunas 3 e 6

# Curiosidade: matriz com tres dimensoes
M <- array(NA, dim=c(3,3,3))

# Data Frame
dados <- data.frame(numeros = 1:9,
                    letras  = letters[1:9])
dim(dados)
nrow(dados) 
ncol(dados)
names(dados) # Nomes das colunas
dados[,1]    # todos os elementos da primeira coluna
dados[,"numeros"] # acessando como se fosse uma matrix
dados$numeros     # acessando diretamente pelo nome da coluna

# Criando Data Frames a partir de um arquivo externo
dados <- read.csv2("dadosARSAE.csv")
class(dados)
names(dados) 
summary(dados)

# Salvar o banco de dados como um arquivo excell
require(openxlsx)
#library(openxlsx)
write.xlsx(dados, "dadosARSAE.xlsx")