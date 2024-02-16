#include "01-folha_de_rosto.typ"

#set page(
  paper: "a4",
  margin: (x: 25mm, y: 30mm),
  footer: [
    #stack(
      spacing: 0.5em,
      line(length: 100%, stroke: (paint: rgb("#333333"), thickness: 0.5pt)),
      block(
        [
          #set text(10pt, rgb("#333333"))
          _onsv.org.br_
          #h(1fr)
          #counter(page).display("1")
        ]
      )
    )
  ],
  header: [
    #stack(
      spacing: 0.5em,
      grid(
        columns: (1fr, 1fr, 1fr),
        [
          #set align(left)
          #image("/icon/onsv_logo_header.png", width: 75%)
        ],
        " ",
        [
          #set align(right)
          #image("/icon/obs2030.png", width: 35%)
        ]
      ),
      line(length: 100%, stroke: (paint: rgb("#333333"), thickness: 0.5pt))
    )
  ]
)

#set par(justify: true)

#set text(
  size: 11pt,
  font: "Open Sans",
  fill: rgb("#1a1a1a"),
  lang: "pt",
  hyphenate: false
)

#set heading(numbering: "1.1")

#show heading: set text(rgb("#00496d"))

#show link: underline

#show figure.caption: emph

#show figure.caption: it => [
  #text(
    10pt,
    fill: rgb("#00496d"),
    style: "italic",
    [#it.supplement #it.counter.display(it.numbering): #it.body]
  )
]

#set figure.caption(position: top, )

#let fonte(term) = {
  align(
    center, 
    text(
      10pt,
      fill: rgb("#00496d"))[Fonte: #term]
  )
}

#include "02-expediente.typ"
#include "03-metadados.typ"
#include "04-sumario.typ"

//---------------------------------------------------------------

= INTRODUÇÃO

O Registro Nacional de Acidentes e Estatísticas de Trânsito (RENAEST) é uma base de dados nacional que busca integrar registros de sinistros de trânsito de todas as 27 unidades federativas do Brasil. Criado em 2006 pela Resolução nº 208 do Conselho Nacional de Trânsito - CONTRAN @contranResolucao208262006, o registro apresenta dados para a caracterização da ocorrência, do(s) veículo(s) envolvido(s) e da(s) vítima(s) envolvida(s) nos sinistros de trânsito. De acordo com a Resolução CONTRAN nº 808 de 2020, o RENAEST é “o sistema de registro, gestão e controle de dados e informações sobre acidentes e estatísticas de trânsito coletados pelos órgãos que compõem o Sistema Nacional de Trânsito (SNT)” @contranResolucaoCONTRANNo2020.

Atualmente, o RENAEST disponibiliza bases de dados para o período 2018-2023, sendo que a última atualização do RENAEST foi em 12 de setembro de 2023, com dados de sinistros de trânsito de janeiro de 2018 a maio de 2023. O sistema encontra-se em fase de implantação, de modo que ainda dispõe de um conjunto de dados incompleto. De acordo com informações disponibilizadas no próprio portal do RENAEST, onde são disponibilizados os arquivos .csv e .csv2 para download dos dados, “não constam dados de rodovias federais” e há “dados incompletos para algumas unidades da federação no período de 2018 a 2021” @ministeriodostransportesRegistroNacionalAcidentes2023a.

Neste contexto, o objetivo do presente trabalho é apresentar uma análise preliminar dos dados disponibilizados no RENAEST levando em consideração a completude dos registros e as limitações de análise decorrentes. O documento é composto das seguintes partes: Histórico do RENAEST; Avaliação da completudo dos dados; e Conclusões.

Para a realização da análise proposta, foi utilizada a linguagem de programação R @rcoreteam2021, com as bibliotecas do Tidyverse @wickhamWelcomeTidyverse2019. Os códigos em R utilizados na produção desse relatório estão disponíveis no github do Observatório Nacional de Segurança Viária: https://github.com/ONSV/analise_renaest. 

A terminologia adotada no presente documento está em conformidade com a terminologia para estudos de sinistros de trânsito da Associação Brasileira de Normas Técnicas - ABNT NBR 10697:2020 @abntNBR10697Pesquisa2020.

#pagebreak()

= HISTÓRICO DO RENAEST

Os itens a seguir descrevem um resgate histórico das tentativas de sistematização dos dados de sinistros de trânsito no Brasil, desde a instituição do Sistema Nacional de Estatísticas de Trânsito (SINET), até a efetiva implementação do atual RENAEST. 

*1994*: surge o Sistema Nacional de Estatísticas de Trânsito (SINET), instituído pela portaria nº 2, de 28 de janeiro de 1994, publicada no Diário Oficial da União, conforme indicado na @fig-portaria #cite(<denatranPortariaNo281994>).

\
#figure(
  image("img/portaria2.png"),
  caption: [Portaria nº 2, de 28 de janeiro de 1994, que instituiu o Sistema Nacional de Estatísticas de Trânsito (SINET).],
) <fig-portaria>

#fonte(cite(<denatranPortariaNo281994>, prose: true))

*1997*: Surge o Código de Trânsito Brasileiro (CTB), pela Lei nº 9.503, de 23 de setembro de 1997 @brasilLeiNo5031997a. Em particular, os incisos X e XI do Art. 19 expressam as obrigações relacionadas à organização e padronização dos registros de sinistros de trânsito:

#block(
  width: 80%,
  inset: 8pt,
  fill: silver,
  [
    Art. 19. Compete ao órgão máximo executivo de trânsito da União:
    
    X - organizar a estatística geral de trânsito no território nacional, definindo os dados a serem fornecidos pelos demais órgãos e promover sua divulgação;
    
    XI - estabelecer modelo padrão de coleta de informações sobre as ocorrências de acidentes de trânsito e as estatísticas do trânsito; 
  ]
)

*2000*: Criação do comitê de gestão do SINET e instituição do manual de procedimentos 2000-2001 do SINET, por meio da Portaria nº 59, de 15 de setembro de 2000 @denatranPortariaNo592000.

*2006*: Criação do RENAEST a partir da Resolução nº 208/06 do CONTRAN, como o "sistema de registro, gestão e controle de dados estatísticos sobre acidentalidade no trânsito, integrado ao sistema de Registro Nacional de Veículos Automotores - RENAVAM, ao Registro Nacional de Condutores Habilitados - RENACH e ao Registro Nacional de Infrações - RENAINF" @contranResolucao208262006. Nesse ano, o RENAEST substituiu o SINET.

*2016*: Publicação da Resolução CONTRAN nº 607, de 24 de maio de 2016, acrescentando novas providências ao RENAEST. Entre elas, possibilita que o Corpo de Bombeiros, Ministério da Saúde, Secretarias de Saúde dos estados e Distrito Federal e o Seguro Obrigatório de Danos Pessoais Causados por Veículos Automotores de Vias Terrestres, ou por sua Carga, a Pessoas Transportadas ou Não (DPVAT) integrem o RENAEST, desde que formalizado convênio com os órgãos de trânsito dos estados, municípios e Distrito Federal. Além disso, especifica que os dados deverão ser coletados a partir do Boletim de Ocorrência de Acidente de Trânsito (BOAT) @contranResolucao607242016.

*2018*: Criado o Plano Nacional de Redução de Mortes e Lesões no Trânsito (PNATRANS), pela Lei n 13.614/18 #cite(<brasilCriaPlanoNacional2018>), que orienta gestores de trânsito a implementarem ações com objetivo de reduzir mortes e lesões no trânsito.

*2018*: Acréscimo no CTB do procedimento de tratamento e consolidação dos dados estatísticos de sinistros de trânsito, conforme #cite(<brasilCriaPlanoNacional2018>, form: "prose"):

#block(
  width: 80%,
  inset: 8pt,
  fill: silver,
  [
    § 9º Os dados estatísticos coletados em cada Estado e no Distrito Federal serão tratados e consolidados pelo respectivo órgão ou entidade executivos de trânsito, que os repassará ao órgão máximo executivo de trânsito da União até o dia 1º de março, por meio do sistema de registro nacional de acidentes e estatísticas de trânsito. 
  ]
)

*2020*: Publicação da Resolução CONTRAN nº 808, de 15 de dezembro de 2020, dispondo a respeito do RENAEST em sua totalidade. Trata-se da resolução mais atual no que diz respeito à coleta e gestão dos dados de sinistros de trânsito do RENAEST @contranResolucaoCONTRANNo2020.

*2022*: A Resolução CONTRAN nº 907 de 2022 revogou a Resolução CONTRAN nº 019 de 1998 e passou a tratar das competências para nomeação dos coordenadores do RENAVAM (Registro Nacional de Veículos Automotores) e do RENACH (Registro Nacional de Carteiras de Habilitação). Essa resolução incluiu o RENAINF (Registro Nacional de Infrações de Trânsito) e o RENAEST (Registro Nacional de Acidentes e Estatísticas de Trânsito) @contranResolucaoCONTRANNo2022.

Na @fig-historico a seguir é apresentada uma linha do tempo das principais ações relacionadas à organização e sistematização dos registros de sinistros de trânsito no Brasil. 

\
#figure(
  image("img/historico.png"),
  caption: [Linha do tempo com alguns elementos históricos do RENAEST],
) <fig-historico>

#fonte(
  [
    Os autores (2023), com base em #cite(<denatranPortariaNo281994>, form: "prose"), #cite(<brasilLeiNo5031997a>, form: "prose"), #cite(<denatranPortariaNo592000>, form: "prose"), #cite(<contranResolucao208262006>, form: "prose"), #cite(<contranResolucao607242016>, form: "prose"), #cite(<brasilCriaPlanoNacional2018>, form: "prose"), #cite(<contranResolucaoCONTRANNo2020>, form: "prose") e #cite(<contranResolucaoCONTRANNo2022>, form: "prose")
  ]
)

#pagebreak()

= AVALIAÇÃO DA COMPLETUDE DOS DADOS

A avaliação da completude dos dados foi conduzida a partir de duas abordagens. A primeira delas teve como objetivo obter um diagnóstico geral acerca dos campos sem dados informados nos registros, ou seja, preenchidos como “não informados”. A partir desta análise, é possível avaliar, ainda que indiretamente, o nível de padronização dos registros, tendo em vista que um campo pode constar como “não informado” no RENAEST por dois motivos principais:

+ O campo não existe no modelo de boletim de ocorrência utilizado;
+ O campo não foi preenchido pelo agente responsável pelo registro da ocorrência.

A segunda abordagem teve por objetivo obter um diagnóstico específico do nível de completude dos dados considerados como essenciais para o registro de um sinistro de trânsito. Esta análise foi necessária devido ao fato de que alguns campos são específicos de determinados tipos de ocorrência. Por exemplo: sinistros registrados em rodovias demandam a utilização de campos específicos, diferentemente das ocorrências registradas em vias urbanas. 

A avaliação da completude dos dados foi realizada considerando três das quatro bases de dados disponibilizados pelo RENAEST: Acidentes, Veículos e Vítimas. Para a base de dados agrupados por “Localidade”, esta análise não se aplica, pois trata-se de uma agregação dos dados para uma mesma unidade geográfica (município), não sendo possível identificar o nível de completude no preenchimento de cada campo do boletim de ocorrência. 

Além das análises considerando a totalidade dos dados disponibilizados pelo RENAEST, foram conduzidas análises desagregadas por unidade da federação. 

== Dados Não Informados

Na base de dados de "Acidentes" há 35 campos e mais de 4,6 milhões de observações. No entanto, boa parte dos campos apresenta um nível baixo de completude, tais como o tipo de rodovia, limite de velocidade e condições meteorológicas. Nesses casos, os campos foram preenchidos como “não informado”, configurando como dados não disponíveis. A @plot-pna-acidentes contém o percentual dos dados “não informados” para cada campo do registro do sinistro. Observa-se, portanto, que o campo “lim_velocidade”, correspondente ao limite de velocidade da via onde o sinistro ocorreu, é o campo mais incompleto, constando como “não informado” em 97,83% dos registros. 

#figure(
  image("plot/pna_acidentes_rod.png", width: 100%),
  caption: [
    Percentual de dados não disponíveis em cada variável do conjunto "Acidentes"
  ],
) <plot-pna-acidentes>

#fonte(
  [
    Os autores (2023), baseado em #cite(<ministeriodostransportesRegistroNacionalAcidentes2023a>, form: "prose")
  ]
)

As únicas variáveis que estão 100% informadas são: ano_acidente, chv_localidade, codigo_ibge, data_acidente, dia_semana, km_via_acidente, mês_acidente, mês_ano_acidente, num_acidente, qtde_acid_com_obitos, qtde_acidente, qtde_envolvidos, qtde_feridosilesos, qtde_obitos e uf_acidente. Os demais campos apresentam algum nível de incompletude: fase_dia (1,03%), hora_acidente (1,31%), tp_acidente (3,30%), end_acidente (3,21%), bairro_acidente (39,26%), cond_meteorologica (52,02%), tp_pavimento (66,56%), num_end_acidente (68,72%), cond_pista (70,61%), tp_rodovia (69,76%), tp_cruzamento (71,32%), ind_acostamento (72,52%), latitude_acidente (73,88%), longitude_acidente (73,89%), tp_curva (81,34%), ind_cantcentral (84,62%), ind_guardrail (90,16%), tp_pista (92,21%), cep_acidente (96,73%) e lim_velocidade (97,83%).

Nas bases de dados relacionados às Vítimas também foram identificados diversos campos “não informados”, tais como `genero`, `tp_envolvido`, Faixa de Idade, Gravidade da Lesão, Suspeita de Álcool, Equipamento de segurança. As informações mais detalhadas a esse respeito podem ser verificadas na @fig-pna-vitimas.

#figure(
  image("plot/pna_vitimas_BR.png", width: 100%),
  caption: [
    Percentual de dados não informados na base de dados "Vítimas"
  ],
) <fig-pna-vitimas>

#fonte(
  [
    Os autores (2023), baseado em #cite(<ministeriodostransportesRegistroNacionalAcidentes2023a>, form: "prose")
  ]
)

Destacam-se os seguintes percentuais de dados “não informados” para os respectivos campos: genero (12,66%), tp_envolvido (15,89%), faixa_idade (29,64%), gravidade_lesao (40,83%), susp_alcool (78,77%), equip_seguranca (82,75%).

== Dados Não Informados Comuns a Todas as ocorrências

Nesta segunda abordagem foram considerados apenas aqueles campos comuns a qualquer registro de sinistro, independentemente de sua ocorrência em área urbana ou rodovia. Dessa forma, a presença de dados “não informados” nestes casos representa efetivamente alguma deficiência no processo de registro (campo não preenchido pelo agente) ou alguma deficiência no modelo de boletim de ocorrência que não contém um campo que deveria conter. A falta desses dados pode comprometer consideravelmente a qualidade das análises conduzidas a partir dos dados disponibilizados no RENAEST.

Para essa análise, foram considerados como campos não comuns os seguintes campos presentes na base “Acidentes”: num_end_acidente, km_via_acidente, p_rodovia, tp_cruzamento, tp_curva, tp_pista, ind_guardrail, ind_cantcentral, ind_acostamento. A @fig-pna-acidentes-br apresenta apenas os campos comuns.

Para as bases de dados “Vítimas” e “Veículos”, todos os campos foram considerados comuns a todas as ocorrências. contém os percentuais de campos comuns a todas as ocorrências preenchidos como “não informados”.

#figure(
  image("plot/pna_acidentes_BR.png", width: 100%),
  caption: [
    Percentual de campos comuns não informados no conjunto de dados "Acidentes".
  ],
) <fig-pna-acidentes-br>

#fonte(
  [
    Os autores (2023), baseado em #cite(<ministeriodostransportesRegistroNacionalAcidentes2023a>, form: "prose")
  ]
)

== Análise da Evolução do Número de Sinistros por UF

Esta seção tem por objetivo analisar a evolução do número anual de sinistros de trânsito ao longo do período 2018-2022 (anos com 12 meses concluídos) por unidade da federação, a fim de avaliar a variabilidade desses valores e identificar dados faltantes (não enviados e, portanto, não consolidados no RENAEST). Esta análise não tem por objetivo avaliar o desempenho em termos do aumento ou redução do número de sinistros em cada unidade da federação ao longo do tempo.

O coeficiente de variação calculado para cada unidade da federação representa a medida de variabilidade utilizada. O cálculo do coeficiente de variação (CV) é dado pela @eq-cv. Na equação, o $sigma$ é o desvio padrão da amostra, e o $accent(x, macron)$ é a média da amostra.

#set math.equation(numbering: "(1)")

$ C V = sigma / accent(x, macron) $ <eq-cv>

O CV expressa, portanto, o valor do desvio padrão em relação à média, ou seja, um CV igual a 50%, por exemplo, significa que o valor do desvio padrão corresponde a 50% do valor da média. Quanto maior o valor do CV, maior a variabilidade dos dados de cada unidade da federação e, portanto, maior a possibilidade de alguma deficiência na consolidação dos dados. Unidades da federação com valor elevado de CV podem:

- Estar com dados faltantes em um ou mais meses do ano;
- Apresentarem, de fato, variação nos últimos 5 anos (porém, quanto maior for esta variação, maior a probabilidade de que não seja natural).

A maioria das unidades da federação resultou com um elevado CV. Como no próprio portal do RENAEST é informado que há dados faltantes, é excluída a possibilidade de análise real do número de sinistros por unidade da federação. Isso porque não é possível afirmar que o número de sinistros indicado na base de dados do RENAEST corresponde à totalidade dos registros efetivamente realizados na unidade da federação. O Apêndice II contém os gráficos com o número de sinistros por ano para cada unidade da federação e os valores do CV, em conjunto com o número médio anual considerando o período 2018-2022 a partir dos dados disponibilizados no RENAEST.

A partir da mesma base de dados, foi elaborada uma tabela resumo, contendo o número de sinistros registrados segundo o RENAEST e o coeficiente de variação (CV) calculado para cada unidade da federação (ver @tbl-cv-uf). Assim, foi possível observar algumas evidências de descontinuidade no fornecimento dos dados para o RENAEST como, por exemplo:

- A falta de dados no estado do Amapá em 2018;
- O estado do Amazonas constar com apenas 6 registros em 2022;
- O estado de São Paulo ter apenas 4.868 acidentes em 2018 (menos que Tocantins) e, em 2019 subir para 188.536;
- Estados com valores muito distintos entre os anos (elevado coeficiente de variação), seja decrescendo ou aumentando muito o número de acidentes ano a ano.

#figure(
  table(
    image("plot/tab1.png"),
    stroke: none
  ),
  caption: [Número de acidentes anuais por unidade federativa e CV por UF]
) <tbl-cv-uf> 

#fonte(
  [
    Os autores (2023), baseado em #cite(<ministeriodostransportesRegistroNacionalAcidentes2023a>, form: "prose")
  ]
)

A @fig-cv-acidentes-total apresenta, em ordem crescente, o coeficiente de variação (CV) de cada unidade federativa.

\
#figure(
  image("plot/cv_acidentes_total.png"),
  caption: [
    Coeficiente da Variação por UF, considerando dados até dezembro de 2022
  ]
) <fig-cv-acidentes-total>

#fonte(
  [
    Os autores (2023), baseado em #cite(<ministeriodostransportesRegistroNacionalAcidentes2023a>, form: "prose")
  ]
)

As unidades da federação com menor CV foram: 
- 1º) Goiás, com 2,69%;
- 2º) Rio Grande do Sul, com 4,94%;
- 3º) Minas Gerais, com 6,79%;
- 4º) Parará, com 8,39%;
- 5º) Pará, com 8,75%.

As unidades da federação com maior CV foram: 
- 27º) Amazonas, com 133,65%;
- 26º) Maranhão, com 108,17%;
- 25º) Alagoas, com 92,65%;
- 24º) Distrito Federal, com 69,26%;
- 23º) Espirito Santo, com 58,91%.

== Dados Não Informados Comuns a Todas as Ocorrências - Análise por Unidade da Federação

Analisar a ocorrência de dados “não informados” em campos comuns a todas as ocorrências, considerando os dados do próprio sinistro, das vítimas e dos veículos por unidade da federação. Por este motivo, nos casos da ocorrência foram excluídos os campos num_end_acidente, km_via_acidente, tp_rodovia, tp_cruzamento, tp_curva, tp_pista, ind_guardrail, ind_cantcentral, ind_acostamento. No caso das vítimas e tipos de veículo, não houve exclusão de campos na análise.

Cada coluna do conjunto de dados possui algum valor que indica dado faltante. Na maioria, o dado faltante é indicado como “não informado”. Assim, calculou-se a taxa de dados não informados, ou seja, dados faltantes, de cada coluna (campo) para cada unidade da federação.

Todos as unidades da federação apresentaram algum percentual de dados não informados em algum dos conjuntos de dados, conforme pode ser observado a partir da análise dos gráficos no Apêndice III. A @tbl-pna-uf e a @tbl-pna-vitimas contêm um resumo dos dados apresentados nos gráficos, com a média geral de cada UF considerando apenas os campos campos comuns a todos os boletins de ocorrência.

#figure(
  table(
    image("plot/tab2.png"),
    stroke: none
  ),
  caption: [Percentual de campos não informados para as 8 variáveis menos informadas por UF e BR, no conjunto "Acidentes"]
) <tbl-pna-uf> 

#fonte(
  [
    Os autores (2023), baseado em #cite(<ministeriodostransportesRegistroNacionalAcidentes2023a>, form: "prose")
  ]
)

Em relação à base de dados “Acidentes”, em média, o campo do boletim de ocorrência que apresenta maior percentual de “não informado” foi o limite de velocidade, não sendo informado em 96,73% das ocorrências, seguido do CEP do local do acidente. Os campos correspondentes às coordenadas geográficas latitude e longitude também apresentaram um elevado percentual de “não informado”, com 73,89% dos registros sem esta informação essencial para a realização de estudos sobre locais críticos de sinistros de trânsito.

A figura @fig-pna-acidentes-uf apresenta o percentual de dados comuns não informados por unidade da federação e do Brasil. É possível perceber que, apesar de alguns campos (variáveis) possuírem falta de dados maior que 50%, todos os estados e Distrito Federal mantém uma proporção de falta de dados total menor que 50%, ou seja, mais da metade dos campos de todos as unidades federativas ao longo dos 5 anos de dados do RENAEST estão preenchidas.

\
#figure(
  image("plot/pna_acidentes_mean.png", width: 100%),
  caption: [
    Percentual de campos comuns não informados por UF e Brasil no conjunto de dados "Acidentes"
  ]
) <fig-pna-acidentes-uf>

#fonte(
  [
    Os autores (2023), baseado em #cite(<ministeriodostransportesRegistroNacionalAcidentes2023a>, form: "prose")
  ]
)

As unidades da federação que apresentaram os melhores níveis de completude para esta base de dados foram:

- 1º) Acre, com 14,24% de campos não informados;
- 2º) Goiás, com 14,58% de campos não informados;
- 3º) Mato Grosso do Sul, com 14,58% de campos não informados;
- 4º) São Paulo, com 15,42% de campos não informados;
- 5º) Distrito Federal, com 15,89% de campos não informados.

Em contrapartida, as unidades da federação que apresentaram os piores níveis de completude para esta base de dados foram:

- 27º) Pernambuco, com 31,64% de campos não informados;
- 26º) Amazonas: 31,04% de campos não informados;
- 25º) Santa Catarina: 30,76% de campos não informados;
- 24º) Piauí: 29,29% de campos não informados;
- 23º) Tocantins: 29,07% de campos não informados.

#figure(
  table(
    image("plot/tab3.png"),
    stroke: none
  ),
  caption: [Percentual de campos não informados no conjunto "Vítimas"]
) <tbl-pna-vitimas> 

#fonte(
  [
    Os autores (2023), baseado em #cite(<ministeriodostransportesRegistroNacionalAcidentes2023a>, form: "prose")
  ]
)

Em relação à base de dados “Vítimas”, em média, o campo do boletim de ocorrência que apresenta maior percentual de “não informado” foi o uso de equipamento de segurança, não sendo informado em 82,75% das ocorrências, seguido da informação sobre suspeita de álcool, com 78,78% dos casos não informados. A @fig-pna-vitimas-uf apresenta o percentual de campos comuns não informados no conjunto “Vítimas”.

\
#figure(
  image("plot/pna_vitimas_mean.png", width: 100%),
  caption: [
    Percentual de campos comuns não informados por UF e Brasil no conjunto de dados "Vítimas"
  ]
) <fig-pna-vitimas-uf>

#fonte(
  [
    Os autores (2023), baseado em #cite(<ministeriodostransportesRegistroNacionalAcidentes2023a>, form: "prose")
  ]
)

Nesse gráfico, é possível perceber que o Brasil tem um percentual de dados não informados menor que no conjunto de dados de “Acidentes” e tem mais unidades federativas com mais falta de dados.

As unidades da federação que apresentaram os melhores níveis de completude para a base de dados Vítimas foram:

- 1º) Distrito Federal, com 8,51% de campos não informados;
- 2º) Rondônia, com 9,98% de campos não informados;
- 3º) Paraná, com 10,16% de campos não informados;
- 4º) Alagoas, com 10,53 % de campos não informados;
- 5º) Tocantins, com 12,17% de campos não informados.

Em contrapartida, as unidades da federação que apresentaram os piores níveis de completude para esta base de dados foram:

- 27º) Pernambuco, com 29,52% de campos não informados;
- 26º) Piauí, com 26,48 % de campos não informados;
- 25º) Pará, com 26,38% de campos não informados;
- 24º) Amapá, com 23,72% de campos não informados;
- 23º) Ceará, com 20,76% de campos não informados.

== Classificação da Tipologia dos Sinistros - Análise por Unidade da Federação

Em relação à tipologia dos sinistros de trânsito, foi observada a nomenclatura utilizada para as colisões entre veículos. Esta análise justifica-se pela elevada proporção de sinistros classificados genericamente como colisão, sem a especificação do tipo de colisão, conforme estabelece a Associação Brasileira de Normas Técnicas - ABNT NBR 10697:2020 @abntNBR10697Pesquisa2020. Na variável “tp_acidente”, onde estão as classificações de tipos de sinistros, incluindo as colisões, dois estados brasileiros (Pernambuco e Piauí) apresentaram zero sinistros classificados como qualquer tipo de colisão, de modo que foram excluídos da análise devido a este forte indício de inconsistência na base. A @fig-prop-colisao apresenta o percentual de colisões não especificadas em cada unidade federativa na base “acidentes”.

Em seis unidades da federação (AC, AM, GO, PA, RJ e SC) nenhum dos sinistros classificados como “colisão” teve sua especificação quanto ao tipo de colisão. Por outro lado, MG, PR, RO e SE apresentam 100% das colisões devidamente classificadas. Nacionalmente, 35,88% das colisões não foram especificadas.

\
#figure(
  image("plot/grafico_prop_colisao.png", width: 100%),
  caption: [
    Proporção de colisões não especificadas, na variável "tp_acidente", em "Acidentes"
  ]
) <fig-prop-colisao>

#fonte(
  [
    Os autores (2023), baseado em #cite(<ministeriodostransportesRegistroNacionalAcidentes2023a>, form: "prose")
  ]
)

#pagebreak()

= CONCLUSÃO

Esse trabalho consistiu em uma avaliação do nível de completude das informações disponibilizadas no RENAEST considerando a sua mais recente atualização (de 12 de setembro de 2023). Este tipo de avaliação é fundamental antes da realização de qualquer análise de desempenho da segurança viária a partir dos dados do RENAEST, seja para a realização de comparações entre unidades da federação ou mesmo para o acompanhamento da evolução da sinistralidade viária ao longo de uma série histórica.

O fato de o RENAEST ainda estar em fase de implantação, com a adesão gradual dos órgãos estaduais e do Distrito Federal, foi evidenciado pelos resultados das análises que mostram alto grau de incompletude das informações. Isso reforça a importância de ampliar a articulação nas diferentes regiões do país para que o fornecimento de dados ao sistema nacional ocorra de maneira sistematizada, com regularidade no tempo e total cobertura geográfica.

Ainda não é possível conhecer o número total de sinistros de trânsito registrados no Brasil. A consolidação dos dados atuais do RENAEST no período de 2018 a 2022, acrescida da informação do número de ocorrências registradas pela Polícia Rodoviária Federal @PRF2021a no mesmo período conduzem a um valor mínimo de 5 milhões de sinistros de trânsito registrados no país (4,67 milhões do RENAEST + 0,33 milhão da PRF), o equivalente a no mínimo 1 milhão de sinistros por ano, em média.

Outro desafio evidente a partir da análise do nível de completude dos registros é a falta de padronização dos campos constantes nos boletins de ocorrência, de modo que grande parte dos dados “não informados” se deve à inexistência desse campo no modelo de boletim de ocorrência utilizado pelo órgão estadual. Neste sentido, a competência atribuída ao órgão máximo executivo de trânsito da União de “estabelecer modelo padrão de coleta de informações sobre as ocorrências de acidentes de trânsito e as estatísticas do trânsito”, disposta no Art. 19 do CTB, em seu inciso XI @brasilLeiNo5031997a, deve ser efetivamente implementada como uma estratégia para a adequada gestão das informações sobre sinistros de trânsito no Brasil e sua plena utilização na formulação e/ou aprimoramento de políticas públicas voltadas à segurança viária. 

Pesquisas futuras tratarão de análises mais detalhadas acerca da terminologia utilizada nos registros disponibilizados pelo RENAEST, principalmente no que diz respeito ao tipo de sinistro, e de estimativas sobre o número total de sinistros registrados no Brasil considerando todas as fontes de informações.

#pagebreak()

#bibliography(
  "refs.bib",
  style: "associacao-brasileira-de-normas-tecnicas",
  title: "REFERÊNCIAS BIBLIOGRÁFICAS"
)

#pagebreak()

#heading(
  [APÊNDICE I: ESPECIFICAÇÃO DOS CAMPOS],
  outlined: true,
  numbering: none
)

*Campos do conjunto de dados “Acidentes”:*

- \*num_acidente: Número do sinistro; 
- \*chv_localidade: Código de localidade; 
- \*data_acidente: Data do sinistro;
- \*uf_acidente: Unidade federativa do sinistro; 
- \*ano_acidente: Ano de ocorrência do sinistro; 
- \*mes_acidente: Mês de ocorrência do sinistro; 
- \*mes_ano_acidente: Mês e ano de ocorrência do sinistro; 
- codigo_ibge: Código do IBGE;
- dia_semana: Dia da semana (segunda-feira, terça-feira etc.);
- fase_dia: Fase do dia (Manhã, tarde, noite ou madrugada);
- tp_acidente: Tipo de sinistro;
- cond_meteorologica: Condições meteorológicas;
- end_acidente: Endereço do sinistro;
- num_end_acidente: Número de endereço do sinistro;
- cep_acidente: CEP de ocorrência do sinistro;
- bairro_acidente: Bairro de ocorrência do sinistro;
- km_via_acidente: Km via do sinistro;
- latitude_acidente: Latitude do sinistro;
- longitude_acidente: Longitude do sinistro;
- hora_acidente: Hora de ocorrência do sinistro;
- tp_rodovia: Tipo de rodovia;
- cond_pista: Condição da pista;
- tp_cruzamento: Tipo de cruzamento;
- tp_pavimento: Tipo de pavimento;
- tp_curva: Tipo de curva;
- lim_velocidade: Limite de velocidade;
- tp_pista: Tipo de pista;
- ind_guardrail: Havia guardrail? (Sim/Não);
- ind_cantcentral: Havia canteiro central? (Sim/Não);
- ind_acostamento: Havia acostamento? (Sim/Não);
- qtde_acidente: Quantidade de sinistros;
- qtde_acid_com_obitos: Quantidade de sinistros com óbitos;
- \*qtde_envolvidos: Quantidade de envolvidos; 
- \*qtde_feridosilesos: Quantidade de feridos ilesos; 
- \*qtde_obitos: Quantidade de óbitos. 

\*Campos também contido no conjunto de dados “Vítimas”.

*Campos exclusivos do conjunto de dados “Vítimas”:*

- faixa_idade: Faixa de idade;
- genero: Gênero;
- tp_envolvido: Tipo de envolvido;
- gravidade_lesao: Gravidade da lesão;
- equip_seguranca: Equipamento de Segurança
- ind_motorista: desconhecido (Sim/Não)
- susp_alcool: Suspeita de álcool (Sim/Não)

#pagebreak()

#heading(
  [APÊNDICE II: COEFICIENTE DE VARIAÇÃO EM CADA UNIDADE],
  outlined: true,
  numbering: none
)

#let cv_plots = (
  "plot/cv_acidentes_AC.png": "Acre",
  "plot/cv_acidentes_AL.png": "Alagoas",
  "plot/cv_acidentes_AM.png": "Amazonas",
  "plot/cv_acidentes_AP.png": "Amapá",
  "plot/cv_acidentes_BA.png": "Bahia",
  "plot/cv_acidentes_CE.png": "Ceará",
  "plot/cv_acidentes_DF.png": "Distrito Federal",
  "plot/cv_acidentes_ES.png": "Espírito Santo",
  "plot/cv_acidentes_GO.png": "Goiás",
  "plot/cv_acidentes_MA.png": "Maranhão",
  "plot/cv_acidentes_MG.png": "Minas Gerais",
  "plot/cv_acidentes_MS.png": "Mato Grosso do Sul",
  "plot/cv_acidentes_MT.png": "Mato Grosso",
  "plot/cv_acidentes_PA.png": "Pará",
  "plot/cv_acidentes_PB.png": "Paraíba",
  "plot/cv_acidentes_PE.png": "Pernambuco",
  "plot/cv_acidentes_PI.png": "Piauí",
  "plot/cv_acidentes_PR.png": "Paraná",
  "plot/cv_acidentes_RJ.png": "Rio de Janeiro",
  "plot/cv_acidentes_RN.png": "Rio Grande do Norte",
  "plot/cv_acidentes_RO.png": "Rondônia",
  "plot/cv_acidentes_RR.png": "Roraima",
  "plot/cv_acidentes_RS.png": "Rio Grande do Sul",
  "plot/cv_acidentes_SC.png": "Santa Catarina",
  "plot/cv_acidentes_SE.png": "Sergipe",
  "plot/cv_acidentes_SP.png": "São Paulo",
  "plot/cv_acidentes_TO.png": "Tocantins"
)

#for (path, uf) in cv_plots {
  figure(
    image(path, width: 100%),
    caption: [Número de sinistros registrados no #{uf}]
  )
}

#pagebreak()

#heading(
  [APÊNDICE III: DADOS NÃO INFORMADOS EM CADA UNIDADE DA FEDERAÇÃO],
  outlined: true,
  numbering: none
)

Todos os gráficos apresentados consideram o período entre 2018 e setembro de 2023.

#let pna_plots = (
  "plot/pna_acidentes_AC.png": "Acre",
  "plot/pna_acidentes_AL.png": "Alagoas",
  "plot/pna_acidentes_AM.png": "Amazonas",
  "plot/pna_acidentes_AP.png": "Amapá",
  "plot/pna_acidentes_BA.png": "Bahia",
  "plot/pna_acidentes_CE.png": "Ceará",
  "plot/pna_acidentes_DF.png": "Distrito Federal",
  "plot/pna_acidentes_ES.png": "Espírito Santo",
  "plot/pna_acidentes_GO.png": "Goiás",
  "plot/pna_acidentes_MA.png": "Maranhão",
  "plot/pna_acidentes_MG.png": "Minas Gerais",
  "plot/pna_acidentes_MS.png": "Mato Grosso do Sul",
  "plot/pna_acidentes_MT.png": "Mato Grosso",
  "plot/pna_acidentes_PA.png": "Pará",
  "plot/pna_acidentes_PB.png": "Paraíba",
  "plot/pna_acidentes_PE.png": "Pernambuco",
  "plot/pna_acidentes_PI.png": "Piauí",
  "plot/pna_acidentes_PR.png": "Paraná",
  "plot/pna_acidentes_RJ.png": "Rio de Janeiro",
  "plot/pna_acidentes_RN.png": "Rio Grande do Norte",
  "plot/pna_acidentes_RO.png": "Rondônia",
  "plot/pna_acidentes_RR.png": "Roraima",
  "plot/pna_acidentes_RS.png": "Rio Grande do Sul",
  "plot/pna_acidentes_SC.png": "Santa Catarina",
  "plot/pna_acidentes_SE.png": "Sergipe",
  "plot/pna_acidentes_SP.png": "São Paulo",
  "plot/pna_acidentes_TO.png": "Tocantins"
)

#for (path, uf) in pna_plots {
  figure(
    image(path, width: 100%),
    caption: [Percentual de campos comuns não informados, #{uf} -- Sinistros]
  )
}