# setup -------------------------------------------------------------------

library(tidyverse)
library(showtext)
library(gghighlight)

source("R/01_organizacao_dados.R")
source("R/02_tabelas_perc_nas.R")
source("R/03_graficos_pna_sinistros_cv.R")
source("R/04_export.R")

font_add_google(name = "Fira Sans", family = "firasans")
showtext_auto()

# load --------------------------------------------------------------------

load("data/acidentes.rda")
load("data/vitimas.rda")

# arrange -----------------------------------------------------------------
acidentes_rod <- arrange_acidentes_rod(acidentes)

acidentes <- arrange_acidentes()
vitimas <- arrange_vitimas()

# table -------------------------------------------------------------------

lista_uf <- unique(acidentes$uf_acidente) # Lista dos UF

acidentes_na_rod <- calc_na(acidentes_rod)
acidentes_na_uf <- map(c("BR", lista_uf), ~calc_na(acidentes, .x))
vitimas_na_uf <- map(c("BR", lista_uf), ~calc_na(vitimas, .x))

acidentes_cv <- map(lista_uf, ~calc_cv(acidentes, .x))
acidentes_cv_br <- calc_cv(acidentes)

total_cv <- join_cv(acidentes_cv, acidentes_cv_br)

pna_mean_acidentes <- calc_mean_pna(acidentes_na_uf)
pna_mean_vitimas <- calc_mean_pna(vitimas_na_uf)

tabela_colisao <- calc_tabela_colisao()

# plot --------------------------------------------------------------------

grafico_pna_acidentes_uf <- map(acidentes_na_uf, plot_pna)
grafico_pna_acidentes_rod <- plot_pna(acidentes_na_rod)

grafico_pna_vitimas_uf <- map(vitimas_na_uf, plot_pna)

grafico_cv <- map(acidentes_cv, plot_cv_sinistros)

grafico_cv_total <- plot_cv_total(total_cv)

grafico_pna_acidentes_mean <- plot_pna_mean(pna_mean_acidentes)
grafico_pna_vitimas_mean <- plot_pna_mean(pna_mean_vitimas)

grafico_pna_colisao <- plot_pna_colisao(tabela_colisao)


# export ------------------------------------------------------------------

export_plots("pna_acidentes", grafico_pna_acidentes_uf)
export_plots("pna_vitimas", grafico_pna_vitimas_uf)
export_plots("cv_acidentes", grafico_cv)

ggsave(
  "plot/pna_acidentes_rod.png",
  grafico_pna_acidentes_rod,
  dpi = 300,
  width = 6,
  height = 4
)

ggsave(
  "plot/cv_acidentes_total.png",
  grafico_cv_total,
  dpi = 300,
  width = 6,
  height = 3.5
)

ggsave(
  "plot/pna_acidentes_mean.png",
  grafico_pna_acidentes_mean,
  dpi = 300,
  width = 6,
  height = 3.5
)

ggsave(
  "plot/pna_vitimas_mean.png",
  grafico_pna_vitimas_mean,
  dpi = 300,
  width = 6,
  height = 3.5
)

ggsave(
  "plot/pna_colisoes.png",
  grafico_pna_colisao,
  dpi = 300,
  width = 6,
  height = 3.5
)

# Tabelas -----------------------------------------------------------------

total_cv_tab <- total_cv |>
  unnest(acidentes)

acidentes_na_tab <- acidentes_na_uf |>
  reduce(bind_rows)

vitimas_na_tab <- vitimas_na_uf |>
  reduce(bind_rows)

write_csv(total_cv_tab, "data/tabela1.csv")
write_csv(acidentes_na_tab, "data/tabela2.csv")
write_csv(vitimas_na_tab, "data/tabela3.csv")
