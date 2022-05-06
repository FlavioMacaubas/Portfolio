# Flávio Macaúbas Torres Filho - Estatística

# Importação dos pacotes para análise

library('tidyverse') 
require('dplyr') # Para os pipes

library('ggplot2') # Para gráficos
library('data.table') # Para usar o fread

library('xlsx') # Para ler arquivos .xlsx (necessário instalação do Java)

require('ff') # Pacote permite trabalhar com base de dados de tamanho médio (2gb - 10gb)

# Preparando ambiente de trabalho
setwd('D:/Enem/DADOS')

# Leitura da base de dados

for (ano in c("2013","2014","2015","2016","2017","2018")){
  path = paste0("MICRODADOS_ENEM_",ano,".csv")
  
  enem <- as_tibble(read.csv.ffdf(file=path, sep =';'))
  
  A <- enem %>% filter(CO_UF_ESC == 25)
  
  arquivo <- paste0("enem_pb_", ano, ".csv")
    
  write_csv(x=A, file=arquivo)
  
}


### Preparando base junta
e_2013 <- as_tibble(read.csv(file="enem_pb_2013.csv", sep =','))
e_2014 <- as_tibble(read.csv(file="enem_pb_2014.csv", sep =','))
e_2015 <- as_tibble(read.csv(file="enem_pb_2015.csv", sep =','))
e_2016 <- as_tibble(read.csv(file="enem_pb_2016.csv", sep =','))
e_2017 <- as_tibble(read.csv(file="enem_pb_2017.csv", sep =','))
e_2018 <- as_tibble(read.csv(file="enem_pb_2018.csv", sep =','))


# Juntado as bases
enem_pb <- (e_2013 %>% select(-starts_with('Q')) %>% rename(CO_ESCOLA = COD_ESCOLA)) %>% 
  bind_rows(e_2014 %>% select(-starts_with('Q')) %>% rename(CO_ESCOLA = COD_ESCOLA)) %>% 
  bind_rows(e_2015 %>% select(-starts_with('Q'))) %>% 
  bind_rows(e_2016 %>% select(-starts_with('Q'))) %>% 
  bind_rows(e_2017 %>% select(-starts_with('Q'))) %>% 
  bind_rows(e_2018 %>% select(-starts_with('Q'))) %>%
  bind_rows(e_2019%>% select(-starts_with('Q')))


write_csv(x=enem_pb, file="enem_pb_2013_2019.csv")







