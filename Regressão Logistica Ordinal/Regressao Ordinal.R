
######################### Regressão Logística Ordinal #########################

# Passo 1: Carregar os pacotes que serão usados

if(!require(pacman)) install.packages("pacman")
library(pacman)

pacman::p_load(dplyr, car, MASS, lmtest,
               gtsummary, reshape2, ggplot2)


# Passo 2: Carregar o banco de dados
# Banco adaptado do pacote carData:
# World Values Surveys 1995-1997 for Australia, Norway, Sweden, and the United States
# Mais informações: ?carData::WVS

# Importante: selecionar o diretório de trabalho (working directory)
# Isso pode ser feito manualmente: Session > Set Working Directory > Choose Directory

dados <- read.csv2('Dados_Ordinal.csv', stringsAsFactors = TRUE)

View(dados)                                 # Visualização dos dados em janela separada
glimpse(dados)                              # Visualização de um resumo dos dados



# Passo 3: Ajustar os tipos de variáveis

dados$Pobreza <- factor(dados$Pobreza, levels = c("Pouco", "Adequado", "Muito"),
                        ordered = T)



# Passo 4: Checagem dos pressupostos

## 1. Variável dependente ordinal
## 2. Independência das observações (sem medidas repetidas)


## 3. Ausência de multicolinearidade
m <- lm(as.numeric(Pobreza) ~ Genero + Idade + Religiao, dados)
car::vif(m)
### Multicolinearidade: VIF > 10


## Construção do modelo ordinal:

mod <- MASS::polr(Pobreza ~ Genero + Idade + Religiao,
                  data = dados, Hess = T)



## 4. Proportional odds (parallel lines)

car::poTest(mod)




# Passo 5: Análise do modelo

## Overall effects

car::Anova(mod, type = "II", test = "Wald")


## Efeitos específicos

summary(mod)

ctable <- coef(summary(mod))
p <- pnorm(abs(ctable[, "t value"]), lower.tail = FALSE) * 2
ctable <- as.data.frame(round(cbind(ctable, "p value" = p), 4))
ctable


## Ou:
lmtest::coeftest(mod)


## Obtenção das razões de chance com IC 95% (usando log-likelihood)

exp(cbind(OR = coef(mod), confint(mod)))



## Obtenção de uma tabela-resumo completa

gtsummary::tbl_regression(mod, exponentiate = TRUE,
                          estimate_fun = purrr::partial(style_ratio, digits = 3)) %>% 
  gtsummary::add_global_p()





####### Como modificar as categorias de referência? ########

levels(dados$Genero)

dados$Genero <- relevel(dados$Genero, ref = "M")


### ATENÇÃO: é necessário rodar o modelo novamente!



# Passo 6 (opcional) - Representação gráfica
# (https://stats.oarc.ucla.edu/r/dae/ordinal-logistic-regression/)

dadosnovos <- data.frame(
  Genero = factor(rep(c("F", "M"), 300)),
  Religiao = factor(rep(c("Sim", "Nao"), each = 300)),
  Idade = rep(18:92)
)

dadosnovos <- cbind(dadosnovos, predict(mod, dadosnovos, type = "probs"))


dadosnovosl <- reshape2::melt(dadosnovos, id.vars = c("Genero", "Religiao", "Idade"),
                              variable.name = "Categoria", value.name = "Probabilidade")


ggplot(dadosnovosl, aes(x = Idade, y = Probabilidade, color = Categoria)) +
  geom_line() +
  facet_grid(Genero ~ Religiao, labeller = "label_both") +
  scale_y_continuous(labels = scales::number_format(decimal.mark = ",",
                                                    accuracy = 0.1)) +
  labs(color = "Enfrentamento\na pobreza", x = "Idade (anos)") +
  theme_bw()


dados %>% 
  group_by(Religiao, Genero) %>% 
  count(Pobreza) %>% 
  mutate(porc = n/sum(n)) %>% 
  ggplot(aes(x = Genero, fill = forcats::fct_rev(Pobreza), y = porc)) +
  geom_col() +
  geom_text(aes(label = scales::percent(porc, accuracy = 1)),
                size = 3, position = position_stack(vjust = 0.5)) +
  facet_wrap(~ paste("Religião =", Religiao)) +
  scale_fill_brewer(palette = "Dark2") +
  scale_y_continuous(expand = expansion(mult = c(0, 0.035)),
                     labels = scales::percent_format()) +
  labs(x = "Gênero", y = "Frequência (%)", fill = "Enfrentamento\napobreza") +
  theme_bw()



ggplot(dados, aes(x = Pobreza, y = Idade, fill = Genero)) +
  geom_errorbar(stat = "boxplot",
                position = position_dodge(width = 0.75),
                width = 0.3) +
  geom_boxplot(outlier.shape = 1) +
  geom_point(stat = "summary", fun = "mean", shape = 8,
             position = position_dodge(width = 0.75),
             show.legend = F) +
  theme_classic()
