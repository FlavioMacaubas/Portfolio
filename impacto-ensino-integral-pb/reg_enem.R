# Flávio Macaúbas Torres Filho e Wisley Costa

# Importação dos pacotes para análise

library('tidyverse') 
require('dplyr') # Para os pipes
library('ggplot2') # Para gráficos
library('data.table') # Para usar o fread
library('xlsx') # Para ler arquivos .xlsx (necessário instalação do Java)
require('readxl')
library(stargazer)
library(ggplot2)
library(plm)
library(WeightIt)
library(twang)
library(cobalt)
require(kableExtra)


##### Preparando ambiente de trabalho -----
setwd('D:/Enem/DADOS')

enem_pb <- as_tibble(read.csv(file="enem_pb_2013_2019.csv", sep =',', encoding = 'Latin-1'))
escolas <- as_tibble(read_excel("escolas_cidadas.xlsx"))

#### Ajustes necessários e dummies de controle -----

# Filtrando apenas pra estaduais
enem_pb <- enem_pb %>% filter(TP_DEPENDENCIA_ADM_ESC == 2 | ID_DEPENDENCIA_ADM_ESC == 2)


# Ajustando gerencias 

#COesc_Muni = enem_pb %>% 
# filter(NU_ANO %in% c(2015,2016,2017,2018) ) %>% 
# select(CO_ESCOLA, CO_MUNICIPIO_ESC) %>% unique()

# Salvando arquivo para tratamento no Python
#write.table(COesc_Muni, file = 'COesc_Muni.csv', row.names = F, sep = ';')

# Criando dummies de tratamento
escolas <- escolas %>% select(CO_ESCOLA, ano_implatacao) %>% 
  rename(ano_impla = ano_implatacao)

# Código das escolas tratadas
cod_inep_tratada <- escolas$CO_ESCOLA

# Colocando ano de implantação
enem_pb <- enem_pb %>% 
  mutate(tratada = ifelse(CO_ESCOLA %in% cod_inep_tratada , 1, 0)) %>% 
  merge(escolas, by= 'CO_ESCOLA', all=T) %>% 
  mutate(ano_impla = ifelse(is.na(ano_impla), 0, ano_impla))

enem_pb$ano_impla %>% unique()



# Apenas concluintes - filtragem de confirmação
enem_pb <- enem_pb %>% filter(TP_ST_CONCLUSAO == 2 | ST_CONCLUSAO == 2)

length((enem_pb %>% filter(NU_ANO == 2018) %>% select(CO_ESCOLA) %>% unique())$CO_ESCOLA)

#### Trajetórias paralelas -----
# Adicionando Nota Final
enem_pb <- enem_pb %>%
  mutate(NOTA_FINAL =   ifelse( NU_ANO >= 2015, (NU_NOTA_CN + 
                         NU_NOTA_CH + 
                         NU_NOTA_LC +
                         NU_NOTA_MT +
                         NU_NOTA_REDACAO)/5,
                         (NOTA_CN + 
                          NOTA_CH + 
                          NOTA_LC +
                          NOTA_MT +
                          NU_NOTA_REDACAO)/5)) %>% 
  mutate(NOTA_FINAL = ifelse(is.na(NOTA_FINAL), 1, NOTA_FINAL))



###### Gráfico média das escolas tratadas e não tratadas ----
controle = enem_pb %>% group_by(NU_ANO, tratada) %>% 
  summarise(media = mean(NOTA_FINAL, na.rm = T)) %>% 
  filter(NU_ANO < 2019 & tratada == 0) 

tratado = enem_pb %>% group_by(NU_ANO, tratada) %>% 
  summarise(media = mean(NOTA_FINAL, na.rm = T)) %>% 
  filter(NU_ANO < 2019 & tratada == 1) 


graf = ggplot()+
  geom_line(data=controle,aes(y=media,x= NU_ANO,colour="Controle"), size=1, linetype=2 )+
  geom_line(data=tratado,aes(y=media,x= NU_ANO,colour="Tratada"),size=1)  +
  scale_color_manual(values = c("firebrick", "darkblue")) + 
  labs(y = 'Média', x = 'Ano', colour = '') +
  theme_minimal() +
  theme(legend.position = "bottom") 

graf

ggsave(filename = 'trajetorias_paralelas.png', graf,
       width = 5, height = 3, dpi = 300, device = 'png')

###### Gráfico tratados e não tratados por ano de implantação ----

tratados_ano_implantacao = enem_pb %>% group_by(NU_ANO, ano_impla) %>% 
  summarise(media = mean(NOTA_FINAL, na.rm = T)); tratados_ano_implantacao


sem_impla = tratados_ano_implantacao %>% filter(ano_impla == 0& NU_ANO < 2019) 

impla_2016 = tratados_ano_implantacao %>% filter(ano_impla == 2016& NU_ANO < 2019) 

impla_2017 = tratados_ano_implantacao %>% filter(ano_impla == 2017 & NU_ANO < 2019) 
  
impla_2018 = tratados_ano_implantacao %>% filter(ano_impla == 2018& NU_ANO < 2019) %>% drop_na()



ggplot()+
  geom_line(data=sem_impla,aes(y=media,x= NU_ANO,colour="Sem implantação"), size=1, linetype=1 )+
  geom_line(data=impla_2016 ,aes(y=media,x= NU_ANO,colour="Implantação 2016"), size=1, linetype=1 )+
  geom_line(data=impla_2017,aes(y=media,x= NU_ANO,colour="Implantação 2017"), size=1, linetype=1 )+
  geom_line(data=impla_2018,aes(y=media,x= NU_ANO,colour="Implantação 2018"),size=1, linetype = 1)  +
  scale_color_manual(values = c("firebrick", "darkblue", 'green', 'cyan')) + 
  labs(y = 'Média', x = 'Ano', colour = '') +
  theme(legend.position = "bottom") +
  theme_minimal()


#### Diferenças em Diferenças ----

# Criando objeto para estimação

# Número de inscrições por escola e por ano
inscricoes = enem_pb %>% 
  filter(NU_ANO %in% c(2015,2016,2017,2018) ) %>% 
  group_by(CO_ESCOLA, NU_ANO) %>% 
  summarise(inscricoes = n())

# INSTRUCÕES DO PROFESSOR
df = enem_pb %>% 
  filter(NU_ANO %in% c(2015,2016,2017,2018) ) %>% 
  group_by(CO_ESCOLA, NU_ANO) %>% 
  summarise(MEDIA = mean(NOTA_FINAL, na.rm=T)) %>% 
  arrange(CO_ESCOLA, NU_ANO) %>% 
  left_join(escolas, by= 'CO_ESCOLA') %>% 
  mutate(ano_impla = ifelse(is.na(ano_impla), 999999, ano_impla),
         ano_novo = ifelse(NU_ANO >= ano_impla, 1, 0),
         tratada = ifelse(CO_ESCOLA %in% cod_inep_tratada , 1, 0),
         tempo = case_when(NU_ANO == 2015 ~ 0,
                           NU_ANO == 2016 ~ 1,
                           NU_ANO == 2017 ~ 2,
                           NU_ANO == 2018 ~ 3)) %>% 
  group_by(CO_ESCOLA) %>% 
  mutate(categoria = cumsum(ano_novo)) %>% 
  ungroup() %>% 
  mutate(log_media = log(MEDIA)) %>% 
  left_join(inscricoes, by = c('CO_ESCOLA', 'NU_ANO')) %>% 
  ungroup()

# Lendo arquivos ajustado no Python
gerencias =  as_tibble(read_excel("GER_REGIONAL.xls"))

# Complemetando base com meso regiões
df = df %>% left_join(gerencias, by = 'CO_ESCOLA')

# Complemetando base com anos
df = df %>% 
  mutate(tempo_meso = tempo*GER_REGIONAL) %>% 
  mutate(ano_1 = ifelse(NU_ANO == ano_impla, 1, 0),
         ano_2 = ifelse((NU_ANO - ano_impla) == 1, 1, 0),
         ano_3 = ifelse((NU_ANO - ano_impla) == 2, 1, 0)) %>% 
  group_by(CO_ESCOLA) %>% 
  mutate(OCORRENCIAS = n())

# Teste tirando aqueles q não ocorreram 4x - UTILIZADO PRA TESTAR SE MUDA A ESTIMAÇÃO
df = df %>% filter(OCORRENCIAS == 4)


###### Estatística descritivas ----

tabela = df %>% 
  group_by(NU_ANO, tratada) %>% 
  summarise(media = mean(MEDIA),
            desvio_padrao = sd(MEDIA),
            LI = t.test(MEDIA, tratada)$conf.int[1],
            LS = t.test(MEDIA, tratada)$conf.int[2]); tabela


###### Diferença de médias ----
t.test(df$MEDIA, df$tratada)

###### Estimativas de impacto ----

###### a) Regressão sem controles ----

reg = lm(data = df, log_media ~ as.factor(tratada))

summary(reg)
# Painel: Pooling (MQO agrupado)
m1 = lm(data = df,
        log_media ~ ano_1 + ano_2 + ano_3 + as.factor(tempo) )

summary(m1)

###### b) Regressão com controles ----

# Criando número de matrículas

# Painel: Pooling (MQO agrupado)
m2 = lm(data = df,
        log_media ~ ano_1 + ano_2 + ano_3 + as.factor(tempo)*as.factor(GER_REGIONAL))

summary(m2)

# Comparação de resultados

# Criando controle para número de matrículas

stargazer(m1, m2, type = "latex", 
          covariate.labels = "ATT",
          decimal.mark = ",", digits = 4)

###### c) EF ---- 

# Sem covariadas + EF
m3 = plm(data = df,
         log_media ~ ano_1 + ano_2 + ano_3 +  as.factor(tempo) ,
         index = c("CO_ESCOLA", "tempo"), model = "within")

summary(m3)

# Com covariadas + EF
m4 = plm(data = df,
         MEDIA ~ ano_1 + ano_2 + ano_3 + as.factor(tempo)*as.factor(GER_REGIONAL),
         index = c("CO_ESCOLA", "tempo"), model = "within")

summary(m4)

# Comparação de resultados
stargazer(m1, m2, m3, m4,  type = "text", 
          keep.stat = "n",
          decimal.mark = ",", digits = 4)


#### Gráficos ----
require(lubridate)
require(gridExtra)
anos = c(2016,2017,2018)

estimadores_1 = c(m1$coefficients[2],m1$coefficients[3],m1$coefficients[4]); estimadores_1
estimadores_2 = c(m2$coefficients[2],m2$coefficients[3],m2$coefficients[4]); estimadores_1


ggplot()+
  geom_line(aes(y=estimadores_1,x= anos,colour="Modelo 1"), size=1, linetype=2 )+
  geom_point(aes(y=estimadores_1,x= anos,colour="Modelo 1"), size=2, linetype=2)+
  geom_line(aes(y=estimadores_2,x= anos,colour="Modelo 2"),size=1)  +
  geom_point(aes(y=estimadores_2,x= anos,colour="Modelo 2"), size=2, linetype=2)+
  scale_color_manual(values = c("firebrick", "darkblue")) +
  scale_x_continuous(breaks = c(2016,2017,2018)) + 
  labs(y = 'Impacto', x = 'Ano', colour = '') +
  ylim(0, 0.20) +
  theme_minimal() +
  theme(legend.position = "bottom")


