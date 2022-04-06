#### Bibliotecas ----

# Manipulação dos dados
library(readxl)
library(tidyverse)

# Manipulação de dados e gráficos espaciais com os dados do IBGE
library(sidrar)

# Só utilizar se for a primeira vez que for usar o geobr
#utils::remove.packages('geobr')
#devtools::install_github("ipeaGIT/geobr", subdir = "r-package")

library(geobr)

library(crul)
library(sf)
library(ggspatial)

# Mapa com marcadores
library(leaflet)

# Ambiente de trabalho
setwd("C:/Users/Macaubas/Desktop/Python/Labimec/Aluguel PB/Mapas")


#### Importando os dados ----
##### a) Aluguel João Pessoa ----
aluguel_jp = read_xlsx("Dados/aluguel_jp.xlsx")

##### b) Bairros - Rendimento médio Censo Demográfico 2010 ----
bairros = read_xlsx("Dados/bairros.xlsx")
bairros = bairros %>% rename(bairro = name_neighborhood) # Renomeando nome dos bairros para português

##### c) Dados espaciais dos bairros de joão pessoa (Geometry) ----
geom_bairros <- geobr::read_neighborhood(year = 2010) %>%
  filter(code_muni == 2507507) %>%  # código de João Pessoa
  rename(bairro = name_neighborhood) %>%  # Renomeando nome dos bairros para português
  select(bairro, geom) # Colunas de interesse para análise


#### Limpeza dos dados ----

##### a) Colocando bairros em letras maiúsculas ----
aluguel_jp = data.frame(lapply(aluguel_jp, function(v) {
  if (is.character(v)) return(toupper(v))
  else return(v)
}))

bairros = data.frame(lapply(bairros, function(v) {
  if (is.character(v)) return(toupper(v))
  else return(v)
}))

geom_bairros = data.frame(lapply(geom_bairros, function(v) {
  if (is.character(v)) return(toupper(v))
  else return(v)
}))

##### b) Ajuste manual da grafia de alguns bairros ----
bairros = bairros %>% mutate(bairro = case_when(
  bairro == 'MUÇUMAGRO' ~ 'MUCUMAGO',
  bairro == 'PLANALTO BOA ESPERANÇA' ~ 'PLANALTO DA BOA ESPERANÇA',
  bairro == 'VALENTINA DE FIGUEIREDO' ~ 'VALENTINA',
  bairro == 'JOSÉ AMÉRICO DE ALMEIDA' ~ 'JOSÉ AMÉRICO',
  TRUE ~ bairro
))

aluguel_jp = aluguel_jp %>% mutate(bairro = case_when(
  bairro == 'MUÇUMAGRO' ~ 'MUCUMAGO',
  bairro == 'PLANALTO BOA ESPERANÇA' ~ 'PLANALTO DA BOA ESPERANÇA',
  bairro == 'VALENTINA DE FIGUEIREDO' ~ 'VALENTINA',
  bairro == 'MANDACARU' ~ 'MANDACARÚ',
  bairro == 'JOSÉ AMÉRICO DE ALMEIDA' ~ 'JOSÉ AMÉRICO',
  TRUE ~ bairro
))

#### Merging dos dados ----

dados_completos = full_join(bairros, geom_bairros, 
                             by = c("bairro"))

dados_completos = dados_completos %>% full_join(aluguel_jp, by = 'bairro')

# Removendo do ambiente de trabalho bases não utilizadas
rm(aluguel_jp, bairros, geom_bairros)

#### Transformação da base de dados ----

##### a) Proporção Cesta Básica / Rendimento Médio ----

dados_completos = dados_completos %>% mutate(cesta = 550.54*100/corrigido)


#### DataViz ----

# Remove eixos e grid
no_axis <- theme(axis.title=element_blank(),
                 axis.text=element_blank(),
                 axis.ticks=element_blank(),
                 panel.grid.major = element_blank(),
                 panel.grid.minor = element_blank(),
                 panel.border = element_blank(),
                 panel.background = element_blank())


##### a) Mapa dos aluguéis ----
graf_aluguel = ggplot() +
  geom_sf(data=dados_completos, aes(geometry = geometry, fill=aluguel), color= "black", size=0.15) +
  scale_fill_viridis_c(option = "mako", begin = 0.3, direction = -1) + 
  labs(fill = "Aluguel (R$)",
       title = "A região da praia apresenta os maiores valores de aluguel",
       caption = "Fonte: Elaboração com dados próprios e do IBGE") +
  theme_minimal() +
  no_axis +
  theme(legend.position='left',
        legend.margin=margin(0, -35, 0, 0))

# Salvando gráfico
ggsave("Imagens/mapa_alguel.jpg",  # jpg, png, eps, tex, etc.
       plot = graf_aluguel, # Usar lastplot() quando não quiser referenciar o objeto ggplot direto
       width = 7, height = 5, 
       units = "in", #  Outras opções c("in", "cm", "mm")
       dpi = 300)

##### b) Mapa da cesta básica ----
graf_cesta_basica = ggplot() +
  geom_sf(data=dados_completos, aes(geometry = geometry, fill=cesta), color= "black", size=0.15) +
  scale_fill_viridis_c(option = "rocket", begin = 0.3, direction = -1) + 
  labs(fill = "Proporção (%)",
       title = "A cesta básica representa cerca de 30% da renda média dos 
       bairros mais pobres de João Pessoa",
       caption = "Fonte: Elaboração com dados próprios e do IBGE") +
  theme_minimal() +
  no_axis

# Salvando gráfico
ggsave("Imagens/mapa_cesta_basica.jpg",  # jpg, png, eps, tex, etc.
       plot = graf_cesta_basica, # Usar lastplot() quando não quiser referenciar o objeto ggplot direto
       width = 7, height = 5, 
       units = "in", #  Outras opções c("in", "cm", "mm")
       dpi = 300)

##### c) Mapa da renda ----
graf_renda = ggplot() +
  geom_sf(data=dados_completos, aes(geometry = geometry, fill=corrigido), color= "black", size=0.15) +
  scale_fill_viridis_c(option = "rocket", begin = 0.3, direction = -1) + 
  labs(fill = "Renda média (R$)",
       title = "A região da praia apresenta maior renda média 
       entre os bairros de João Pessoa",
       caption = "Fonte: Elaboração com dados próprios e do IBGE") +
  theme_minimal() +
  no_axis +
  theme(legend.position='left',
        legend.margin=margin(0, -40, 0, 0)); graf_renda



# Salvando gráfico
ggsave("Imagens/mapa_renda.jpg",  # jpg, png, eps, tex, etc.
       plot = graf_renda, # Usar lastplot() quando não quiser referenciar o objeto ggplot direto
       width = 7, height = 5, 
       units = "in", # Outras opções c("in", "cm", "mm")
       dpi = 300)


dados_completos %>% arrange(desc(aluguel)) %>% head(6)
