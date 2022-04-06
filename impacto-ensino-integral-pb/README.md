# Impacto do ensino integral no desempenho do ENEM dos alunos de escolas públicas da Paraíba

´´´
Autores: Flávio Macaúbas e Wisley Costa
´´´

## Descrição

As escolas estaduais iniciaram o processo de transição para essa modalidade em 2016, tendo
em 2018 um total de 97 escolas em funcionamento integral, cerca de 14,2% do total. Dessa
forma, este trabalho tem por objetivo verificar o impacto da adoção de escolas estaduais
em tempo integral da Paraíba na nota do Exame Nacional do Ensino Médio (ENEM) nos
anos de 2016 a 2018. Para isso, é utilizado a técnica de diferenças em diferenças com
múltiplas entradas para estimar o impacto da modalidade do ensino integral das escolas
públicas estaduais da Paraíba no desempenho do ENEM das mesmas. Os resultados
demonstram que o efeito é positivo e significante, em 7,4%, no caso homogêneo e possui
o maior impacto no segundo ano de implantação da modalidade, com 15,5%. Não foi
encontrado significância estatística no terceiro ano da modalidade, possivelmente devido a
pouca quantidade de observações.

## Métodologia

A base de dados utilizado no trabalho são os microdados do Enem para os anos de 2013 a 2018 da Paraíba para verificação de trajetórias paralelas. Por sua vez o impacto é medido levando em consideração o ano de 2015 - pré-tratamento e 2016 a 2018 - pós-tratamento. Como há diferentes tempos de exposição, foram necessários ajustes na base de dados para captar a iteração entre tempo e tratamento, conforme descrito na tabela \autoref{tab:expo_tempo_integral}. Complementarmente, adiciona-se as gerências regionais de ensino como forma de controlar as diferenças na qualidade ensino entre as regiões do estado.

\begin{table}[H]
\caption{Comparação dos indicadores entre as Escolas Públicas Estaduais sob regime integral e regime não integral}\label{tab:estat_descrit}
\begin{tabular*}{\columnwidth}{@{\extracolsep{\fill}}l|cccc|cccc@{}}
\toprule
 & \multicolumn{4}{c|}{\textbf{Sem Integral}} & \multicolumn{4}{c}{\textbf{Com Integral}} \\
\textbf{Variável} & \multicolumn{1}{c}{\textbf{2015}} & \textbf{2016} & \textbf{2017} & \multicolumn{1}{c|}{\textbf{2018}} & \multicolumn{1}{c}{\textbf{2015}} & \textbf{2016} & \textbf{2017} & \multicolumn{1}{c}{\textbf{2018}} \\ \hline
\midrule
Média & 410 & 393 & 379 & 372 & 426 & 409 & 404 & 399 \\
Desvio-Padrão & 55,7 & 58,8 & 67,0 & 74,9 & 36,5 & 44,6 & 50,6 & 60,5 \\
LI (95\%) & 404 & 386 & 372 & 363 & 418 & 398 & 392 & 385 \\
LS (95\%) & 417 & 399 & 387 & 380 & 433 & 418 & 417 & 411 \\ \hline
\bottomrule
\end{tabular*}
\fonte{Elaboração própria a partir dos dados Inep}
\end{table}

A partir dos dados \autoref{tab:estat_descrit} percebe-se que há uma tendência de queda das médias observada nos dois grupos. Analogamente, é possível observar um aumento do desvio padrão no decorrer dos anos. Este é um indicativo de que os alunos do ensino público na Paraíba possam estar menos preparados para o ENEM, similarmente, é possível que as provas estejam ficando mais difícil, relativo a preparação do aluno. Destaca-se ainda que o número de escolas participantes no ENEM por ano é constante ao longo dos anos, uma vez que há um balanceamento imposto do painel. Constata-se que a hipótese de igualdade de médias é rejeitada a 95\%, consequentemente, os dois grupos possuem médias diferentes.

Como forma de verificar o verdadeiro impacto do ensino integral na escolas de ensino médio estaduais na Paraíba se faz necessário checarmos o que teria acontecido com essas escolas acaso não tivessem se submetido ao modelo integral. Assim, precisamos de um contrafactual não observado, dado que não é possível obter o desempenho das escolas que adotaram ensino integral sem possíveis efeitos do tratamento.

A não presença de um contrafactual ideal pode gerar viés em nossas estimativas devido a seleção das observações. O viés de seleção, nessa situação, se dá pois a adoção do modelo de ensino não ocorre de forma aleatorizada. Isto é, o governante escolhe quais escolas serão beneficiadas com a modalidade de ensino. Além de que, de acordo com as diretrizes do PNE, 25\% dos alunos brasileiros devem estar matriculados na forma integral de ensino até 2024.

Esses fatores, por um lado, pressionam os governantes a adotar a modalidade, e por outro, requer uma infraestrutura apropriada para a adoção do modelo integral, o que ocasiona seleção de escolas que já possuam ou que sejam propícias a comportar a categoria integral. No caso da Escola Técnica de Mangabeira, por exemplo, que foi construída com a finalidade de adoção do ensino integral.

As escolas privadas foram removidas da base de dados utilizada, uma vez que essas possuem regras próprias de adoção do ensino integral. Analogamente, filtramos a base dados apenas para os alunos concluintes, porque não há garantias que os alunos não concluintes cursaram em modelo integral, uma vez que não há como saber qual o ano ele concluiu o ensino médio. Por outro lado, ao filtrar apenas para alunos concluintes, garantimos que apenas alunos do 3º do ensino médio serão contabilizados.

\begin{table}[H]
\caption{Distribuição das escolas por tempo de exposição ao modelo de ensino integral por ano. Paraíba, de 2015 a 2018.}\label{tab:expo_tempo_integral}
\begin{tabular*}{\columnwidth}{@{\extracolsep{\fill}}c|cccc|c@{}}
\toprule
 & \multicolumn{4}{c|}{\textbf{Tempo (em anos)}} &  \\ \hline
\textbf{Ano} & \textbf{0} & \textbf{1} & \textbf{2} & \textbf{3} & \textbf{Total} \\ \hline
\midrule
\textbf{2015} & 415 &  &  &  & 415 \\
\cellcolor[HTML]{C0C0C0}\textbf{2016} & \cellcolor[HTML]{C0C0C0}428 & \cellcolor[HTML]{C0C0C0}6 &  &  & 434 \\
\textbf{2017} & 411 & 25 & 6 &  & 442 \\
\cellcolor[HTML]{C0C0C0}{\color[HTML]{000000} \textbf{2018}} & \cellcolor[HTML]{C0C0C0}{\color[HTML]{000000} 348} & \cellcolor[HTML]{C0C0C0}{\color[HTML]{000000} 66} & \cellcolor[HTML]{C0C0C0}{\color[HTML]{000000} 25} & \cellcolor[HTML]{C0C0C0}{\color[HTML]{000000} 6} & 445 \\ \hline
\bottomrule
\textbf{Total} & 1602 & 97 & 31 &  6 & 1736
\end{tabular*}
\fonte{Elaboração própria a partir dos dados Inep}
\end{table}


Na \autoref{tab:expo_tempo_integral}, podemos observar a quantidade de escolas que ingressaram na modalidade integral para cada um dos anos, a partir de 2016. No primeiro ano de implantação, haviam 6 escolas tratadas. Já em 2017, mais 25 foram incorporadas; em 2018, 66. Até 2018, o estado da Paraíba possui um total de 97 escolas com ensino médio integral.

% ENEM - PB - ESCOLA ESTADUAL - CONCLUINTES (GARANTE ENSINO MÉDIO)

\section{Diferença em diferenças}

Uma maneira de contornar possíveis vieses nos contrafactuais é adotarmos a diferença em diferenças como método de capturarmos o impacto do ensino integral. Essa metodologia permite controlar não observáveis invariantes no tempo, sob hipótese de trajetórias paralelas entre os grupos de tratamento e controle.

Na Figura \ref{fig:trajetorias_paralelas}, temos as trajetórias das médias no ENEM para o grupo de tratamento e controle. Como pode ser observado, as notas médias seguem uma tendência de crescimento, com alguns anos de pouca estabilidade. De forma geral, as series possuem um comportamento semelhante entre os grupos de interesse, possibilitando estimarmos o impacto do ensino integral através do diferença em diferenças.

% Deve-se verificar a hipótese de trajetórias paralelas para decidir se iremos adotar PSM
  \begin{figure}[H]
        \centering
        \caption{Trajetórias Paralelas}
        \includegraphics[width=0.8\linewidth]{Figuras/trajetorias_paralelas.png}
        \label{fig:trajetorias_paralelas}
    \end{figure}

O modelo proposto,  seguindo a estratégia de \citeonline{almeida2019impacto}, é 

\begin{equation}
    y_{it} = \sum_{j=1}^{J} \beta_j integral_{j, it} + \phi_i + \tau_t + \varepsilon_{it}
\end{equation}

em que $y_{it}$ é o indicador de resultado representado pela média das notas no emem dos estudantes vinculados a escola $i$ no tempo $t$, $integral_{j, it}$ é uma variável binária que assume valor um caso a escola $i$ seja de ensino integral no tempo $t$ por um número $j$ de anos, $\phi_{i}$ são variáveis constantes no tempo para cada $i$, $\tau_u$ é uma tendência temporal global e $\varepsilon_{it}$ é o termo de erro.  

Espera-se que as variáveis binárias referente aos anos nessa modalidade sejam positivas, uma vez que o ensino integral visa oferecer um ensino de melhor qualidade ao aluno, perpassando tanto as áreas da formação básica como formações complementares e profissionalizantes. 


