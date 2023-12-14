library(tidyverse)
library(gt)
library(janitor)

# Data --------------------------------------------------------------------

tabela1 <- read_csv("data/tabela1.csv")
tabela2 <- read_csv("data/tabela2.csv")
tabela3 <- read_csv("data/tabela3.csv")

# function ----------------------------------------------------------------

fix_percentage <- function(perc_character) {
  as.numeric(gsub(",", ".", gsub("%", "", perc_character))) / 100
}

# arrange -----------------------------------------------------------------

tab1_fix <- tabela1 |>
  clean_names() |>
  mutate(
    cv = fix_percentage(cv),
    x2018 = as.numeric(x2018),
    regiao = case_match(
      uf_ano,
      c("AC", "AM", "AP", "PA", "RO", "RR", "TO") ~ "Norte",
      c("AL", "BA", "CE", "MA", "PB", "PE", "PI", "RN", "SE") ~ "Nordeste",
      c("DF", "GO", "MT", "MS") ~ "Centro-oeste",
      c("ES", "MG", "RJ", "SP") ~ "Sudeste",
      c("PR", "RS", "SC") ~ "Sul",
      .default = "Total"
    )
  )

tab2_fix <- tabela2 |>
  clean_names() |>
  mutate(
    across(-uf, fix_percentage),
    regiao = case_match(
      uf,
      c("AC", "AM", "AP", "PA", "RO", "RR", "TO") ~ "Norte",
      c("AL", "BA", "CE", "MA", "PB", "PE", "PI", "RN", "SE") ~ "Nordeste",
      c("DF", "GO", "MT", "MS") ~ "Centro-oeste",
      c("ES", "MG", "RJ", "SP") ~ "Sudeste",
      c("PR", "RS", "SC") ~ "Sul",
      .default = "Total"
    )
  )

tab3_fix <- tabela3 |>
  clean_names() |>
  mutate(
    across(-uf_var, fix_percentage),
    regiao = case_match(
      uf_var,
      c("AC", "AM", "AP", "PA", "RO", "RR", "TO") ~ "Norte",
      c("AL", "BA", "CE", "MA", "PB", "PE", "PI", "RN", "SE") ~ "Nordeste",
      c("DF", "GO", "MT", "MS") ~ "Centro-oeste",
      c("ES", "MG", "RJ", "SP") ~ "Sudeste",
      c("PR", "RS", "SC") ~ "Sul",
      .default = "Total"
    ),
    faixa_idade = if_else(is.na(faixa_idade), 0.0728, faixa_idade)
  )

# gt ----------------------------------------------------------------------

gt_tab1 <- tab1_fix |>
  gt(rowname_col = "uf_ano", groupname_col = "regiao") |>
  fmt_number(
    columns = x2018:x2022,
    sep_mark = ".",
    dec_mark = ",",
    decimals = 0
  ) |>
  fmt_percent(
    columns = cv,
    dec_mark = ",",
    sep_mark = "."
  ) |>
  sub_missing(missing_text = "-") |>
  cols_label(
    x2018 = "2018",
    x2019 = "2019",
    x2020 = "2020",
    x2021 = "2021",
    x2022 = "2022",
    cv = "CV"
  ) |>
  cols_width(
    uf_ano ~ px(50),
    everything() ~ px(80)
  ) |>
  data_color(
    columns = cv,
    palette = "Blues"
  ) |>
  tab_footnote(
    locations = cells_column_labels(columns = cv),
    footnote = "Na ausência de dados, o CV considera o valor 'zero'"
  )

gt_tab2 <- tab2_fix |>
  gt(
    rowname_col = "uf",
    groupname_col = "regiao"
  ) |>
  fmt_percent(
    columns = lim_velocidade:media_geral_uf,
    dec_mark = ",",
    sep_mark = "."
  ) |>
  cols_label(
    lim_velocidade = "lim_<br>velocidade",
    cep_acidente = "cep_<br>acidente",
    longitude_acidente = "long_<br>acidente",
    latitude_acidente = "lat_<br>acidente",
    cond_pista = "cond_<br>pista",
    tp_pavimento = "tp_pav",
    cond_metereologica = "cond_<br>metereo",
    bairro_acidente = "bairro_<br>acidente",
    media_geral_uf = "Média",
    .fn = md
  ) |>
  cols_width(
    lim_velocidade:media_geral_uf ~ px(75)
  ) |>
  data_color(
    columns = -uf,
    palette = "Blues",
    domain = c(0, 1)
  )

gt_tab3 <- tab3_fix |>
  gt(
    rowname_col = "uf_var",
    groupname_col = "regiao"
  ) |>
  fmt_percent(
    columns = equip_seguranca:media_uf,
    dec_mark = ",",
    sep_mark = "."
  ) |>
  cols_label(
    equip_seguranca = "equip_<br>seguranca",
    susp_alcool = "susp_<br>alcool",
    gravidade_lesao = "gravidade_<br>lesao",
    faixa_idade = "faixa_<br>idade",
    tp_envolvido = "tp_<br>envolvido",
    media_uf = "Média",
    .fn = md
  ) |>
  cols_width(equip_seguranca:media_uf ~ px(75)) |>
  data_color(
    columns = -uf_var,
    palette = "Blues",
    domain = c(0, 1)
  )

# export ------------------------------------------------------------------

gt_tables <- list(
  gt_tab1,
  gt_tab2,
  gt_tab3
)

walk2(
  gt_tables,
  glue::glue("plot/tab{seq(1,3,1)}.png"),
  gtsave,
  vwidth = 1800,
  vheight = 2400
)
