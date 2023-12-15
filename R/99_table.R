library(tidyverse)
library(gt)
library(janitor)

# Data --------------------------------------------------------------------

tabela1 <- read_csv("data/tabela1.csv")
tabela2 <- read_csv("data/tabela2.csv")
tabela3 <- read_csv("data/tabela3.csv")

# arrange -----------------------------------------------------------------

tab1_fix <- tabela1 |>
  select(-media) |>
  pivot_wider(names_from = ano_acidente, values_from = n) |>
  janitor::clean_names() |>
  mutate(regiao = case_match(
    uf_acidente,
    c("AC", "AM", "AP", "PA", "RO", "RR", "TO") ~ "Norte",
    c("AL", "BA", "CE", "MA", "PB", "PE", "PI", "RN", "SE") ~ "Nordeste",
    c("DF", "GO", "MT", "MS") ~ "Centro-oeste",
    c("ES", "MG", "RJ", "SP") ~ "Sudeste",
    c("PR", "RS", "SC") ~ "Sul",
    .default = "Total"
  ))


tab2_fix <- tabela2 |>
  filter(
    var %in% c(
      "lim_velocidade",
      "cep_acidente",
      "longitude_acidente",
      "latitude_acidente",
      "cond_pista",
      "tp_pavimento",
      "cond_meteorologica",
      "bairro_acidente"
    )
  ) |>
  select(-na_qtde) |>
  group_by(uf) |>
  pivot_wider(names_from = var, values_from = pna) |>
  mutate(
    regiao = case_match(
      uf,
      c("AC", "AM", "AP", "PA", "RO", "RR", "TO") ~ "Norte",
      c("AL", "BA", "CE", "MA", "PB", "PE", "PI", "RN", "SE") ~ "Nordeste",
      c("DF", "GO", "MT", "MS") ~ "Centro-oeste",
      c("ES", "MG", "RJ", "SP") ~ "Sudeste",
      c("PR", "RS", "SC") ~ "Sul",
      .default = "Total"
    )
  ) |>
  rowwise() |>
  mutate(
    media = mean(
      c(
        cep_acidente,
        bairro_acidente,
        latitude_acidente,
        longitude_acidente,
        cond_pista,
        tp_pavimento,
        lim_velocidade,
        cond_meteorologica
      )
    )
  ) |>
  ungroup()

tab3_fix <- tabela3 |>
  filter(
    var %in% c(
      "equip_seguranca",
      "susp_alcool",
      "gravidade_lesao",
      "faixa_idade",
      "tp_envolvido",
      "genero"
    )
  ) |>
  select(-na_qtde) |>
  group_by(uf) |>
  pivot_wider(names_from = var, values_from = pna) |>
  mutate(
    regiao = case_match(
      uf,
      c("AC", "AM", "AP", "PA", "RO", "RR", "TO") ~ "Norte",
      c("AL", "BA", "CE", "MA", "PB", "PE", "PI", "RN", "SE") ~ "Nordeste",
      c("DF", "GO", "MT", "MS") ~ "Centro-oeste",
      c("ES", "MG", "RJ", "SP") ~ "Sudeste",
      c("PR", "RS", "SC") ~ "Sul",
      .default = "Total"
    )
  ) |>
  rowwise() |>
  mutate(
    media = mean(
      c(
        faixa_idade,
        genero,
        tp_envolvido,
        gravidade_lesao,
        equip_seguranca,
        susp_alcool
      )
    )
  ) |>
  ungroup()

# gt ----------------------------------------------------------------------

gt_tab1 <-
  tab1_fix |>
  select(regiao, uf_acidente, x2018:x2022, cv) |>
  gt(rowname_col = "uf_acidente", groupname_col = "regiao") |>
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
    uf_acidente ~ px(50),
    everything() ~ px(80)
  ) |>
  data_color(
    columns = cv,
    palette = "Blues"
  ) |>
  tab_footnote(
    locations = cells_column_labels(columns = cv),
    footnote = "Na ausência de dados, o CV considera o valor 'zero', ocorrido em 2018 no Amapá"
  )

gt_tab2 <- tab2_fix |>
  bind_rows(slice_head(tab2_fix)) |>
  slice(-1) |>
  gt(
    rowname_col = "uf",
    groupname_col = "regiao"
  ) |>
  fmt_percent(
    columns = cond_meteorologica:media,
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
    cond_meteorologica = "cond_<br>metereo",
    bairro_acidente = "bairro_<br>acidente",
    media = "Média",
    .fn = md
  ) |>
  cols_width(
    lim_velocidade:media ~ px(75)
  ) |>
  data_color(
    columns = -uf,
    palette = "Blues",
    domain = c(0, 1)
  )

gt_tab3 <-
  tab3_fix |>
  bind_rows(slice_head(tab3_fix)) |>
  slice(-1) |>
  gt(
    rowname_col = "uf",
    groupname_col = "regiao"
  ) |>
  fmt_percent(
    columns = faixa_idade:media,
    dec_mark = ",",
    sep_mark = "."
  ) |>
  cols_label(
    equip_seguranca = "equip_<br>seguranca",
    susp_alcool = "susp_<br>alcool",
    gravidade_lesao = "gravidade_<br>lesao",
    faixa_idade = "faixa_<br>idade",
    tp_envolvido = "tp_<br>envolvido",
    media = "Média",
    .fn = md
  ) |>
  cols_width(equip_seguranca:media ~ px(75)) |>
  data_color(
    columns = -uf,
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
