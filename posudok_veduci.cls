\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{posudok_veduci}[2026/06/07 Trieda pre posudok vedúceho BP]

\LoadClass[12pt,a4paper]{article}

\usepackage[slovak]{babel}
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{listings}
\usepackage[top=0.63in, bottom=0.89in, left=0.98in, right=0.79in]{geometry}
\usepackage{longtable}
\usepackage{array}
\usepackage{setspace}
\usepackage{tabularx}
\usepackage{fancyhdr}
\usepackage{expl3}
\usepackage{xfp}
\usepackage{tabularx}
\usepackage{lipsum}
\usepackage{multirow}
\usepackage{xurl}
\usepackage{indentfirst}

\usepackage{enumitem}
% Nastavenie štýlov pre itemize
\setlist[itemize,1]{label=--}
% Nastavenie štýlov pre enumerate
\setlist[enumerate,2]{label=\alph*., ref=\theenumi\alph*}

\lstset{
  extendedchars=true,
  literate=
    {á}{{\'a}}1
    {ä}{{\"a}}1
    {č}{{\v{c}}}1
    {ď}{{\v{d}}}1
    {é}{{\'e}}1
    {í}{{\'i}}1
    {ĺ}{{\'l}}1
    {ľ}{{\v{l}}}1
    {ň}{{\v{n}}}1
    {ó}{{\'o}}1
    {ô}{{\^o}}1
    {ŕ}{{\'{r}}}1
    {š}{{\v{s}}}1
    {ť}{{\v{t}}}1
    {ú}{{\'u}}1
    {ý}{{\'y}}1
    {ž}{{\v{z}}}1
    {Á}{{\'A}}1
    {Ä}{{\""A}}1
    {Č}{{\v{C}}}1
    {Ď}{{\v{C}}}1
    {É}{{\'E}}1
    {Í}{{\'I}}1
    {Ĺ}{{\'L}}1
    {Ľ}{{\v{L}}}1
    {Ň}{{\v{N}}}1
    {Ó}{{\'O}}1
    {Ô}{{\^O}}1
    {Ŕ}{{\'{R}}}1
    {Š}{{\v{S}}}1
    {Ť}{{\v{T}}}1
    {Ú}{{\'U}}1
    {Ý}{{\'Y}}1
    {Ž}{{\v{Z}}}1
}

\setlength{\parindent}{0pt}
\setlength{\parskip}{1em}
\onehalfspacing

\renewcommand{\sfdefault}{phv}
\renewcommand{\rmdefault}{ptm}
\renewcommand{\ttdefault}{pcr}
\renewcommand{\arraystretch}{1.3}

\def\@den{\number\day}
\def\@mesiac{\number\month}
\def\@rok{\number\year}
\newcommand\MyDate[3]{\def\@den{#1}
    \def\@mesiac{#2}
    \def\@rok{#3}}
\newcommand{\printDate}{\@den.\ \@mesiac.\ \@rok}

% =======================
% Automatické výpočty
% =======================

% Spočítaj všetky body
\ExplSyntaxOn
\newcommand{\ComputeTotalPoints}{
  \int_zero_new:N \l_tmpa_int
  \int_set:Nn \l_tmpa_int {
    \bodyKonEfektivita + \bodyKonIniciativa +
    \bodyKvantita + \bodyKvalita +
    \bodyPrOrganizacia + \bodyPrEfektivita +
    \bodyHarmonogram +
    \bodySamostatnost
  }
  \edef\bodySpolu{\int_use:N \l_tmpa_int}
}
\ExplSyntaxOff

% Urči známku podľa rozsahu bodov
\newcommand{\AutoGrade}{
  \ComputeTotalPoints
  \def\finalGrade{}
  \ifnum\bodySpolu>91
    \def\finalGrade{výborne (A)}
  \else\ifnum\bodySpolu>82
    \def\finalGrade{veľmi dobre (B)}
  \else\ifnum\bodySpolu>73
    \def\finalGrade{dobre (C)}
  \else\ifnum\bodySpolu>64
    \def\finalGrade{uspokojivo (D)}
  \else\ifnum\bodySpolu>55
    \def\finalGrade{dostatočne (E)}
  \else
    \def\finalGrade{nedostatočne (FX)}
  \fi\fi\fi\fi\fi
}

% Urči odporúčanie práce
\newcommand{\AutoRecommendation}{
  \ifnum\bodySpolu>55
    \def\recommendation{odporúčam}
  \else
    \def\recommendation{neodporúčam}
  \fi
}

% =======================
% Premenné - hlavička
% =======================
\newcommand{\studentName}{}
\newcommand{\studyProgram}{}
\newcommand{\thesisTitle}{}
\newcommand{\supervisorName}{}
\newcommand{\crzpRatio}{}

\newcommand{\setStudentName}[1]{\renewcommand{\studentName}{#1}}
\newcommand{\setStudyProgram}[1]{\renewcommand{\studyProgram}{#1}}
\newcommand{\setThesisTitle}[1]{\renewcommand{\thesisTitle}{#1}}
\newcommand{\setSupervisorName}[1]{\renewcommand{\supervisorName}{#1}}
\newcommand{\setCrzpRatio}[1]{\renewcommand{\crzpRatio}{#1}}


% =======================
% Premenné - bodové hodnotenie
% =======================
\newcommand{\bodyKonEfektivita}{}
\newcommand{\bodyKonIniciativa}{}
\newcommand{\bodyKvantita}{}
\newcommand{\bodyKvalita}{}
\newcommand{\bodyPrOrganizacia}{}
\newcommand{\bodyPrEfektivita}{}
\newcommand{\bodyHarmonogram}{}
\newcommand{\bodySamostatnost}{}

% =======================
% Komponenty - zobrazenie
% =======================
\newcommand{\DrawHeader}{
  \begin{center}
    \Large \textbf{Posudok ved\'{u}ceho bakalárskej práce}
  \end{center}

  \vspace{-1em}

  \noindent
  \begin{tabularx}{\textwidth}{@{}l>{\raggedright\arraybackslash}X@{}}
    \textbf{Meno študenta:} & \studentName \\
    \textbf{Študijný program:} & \bf{\studyProgram} \\
    \textbf{Názov bakalárskej práce:} & \thesisTitle \\
    \textbf{Meno vedúceho BP:} & \supervisorName \\
  \end{tabularx}

  \vspace{1em}
}

\newcommand{\DrawEvaluationTable}{
\ComputeTotalPoints
\textbf{Hodnotenie} bakalárskej práce (bodové):

\begin{table}[h] \centering
\begin{tabular}{|l|ll|r|r|}
\hline
                   & \multicolumn{2}{c|}{\textbf{Kritériá bodového hodnotenia}}                                          & \multicolumn{1}{l|}{\begin{tabular}[c]{@{}l@{}}Max.\\ počet\\ bodov\end{tabular}} & \multicolumn{1}{l|}{\begin{tabular}[c]{@{}l@{}}Získané\\ body\end{tabular}} \\ \hline
\multirow{2}{*}{1} & \multicolumn{1}{l|}{\multirow{2}{*}{Spolupráca s vedúcim}}     & Efektivita konzultácií             & 15                                                                                & \bodyKonEfektivita                                           \\ \cline{3-5} 
                   & \multicolumn{1}{l|}{}                                          & Iniciatíva pri získavaní podkladov & 5                                                                                 & \bodyKonIniciativa                                           \\ \hline
\multirow{2}{*}{2} & \multicolumn{1}{l|}{\multirow{2}{*}{Splnenie cieľov zadania}}  & Kvantitatívne plnenie úloh         & 10                                                                                & \bodyKvantita                                                \\ \cline{3-5} 
                   & \multicolumn{1}{l|}{}                                          & Kvalitatívne plnenie úloh          & 10                                                                                & \bodyKvalita                                                 \\ \hline
\multirow{2}{*}{3} & \multicolumn{1}{l|}{\multirow{2}{*}{Kvalita priebežnej práce}} & Organizácia práce                  & 10                                                                                & \bodyPrOrganizacia                                           \\ \cline{3-5} 
                   & \multicolumn{1}{l|}{}                                          & Efektivita práce                   & 20                                                                                & \bodyPrEfektivita                                            \\ \hline
4                  & \multicolumn{2}{l|}{Dodržanie časového harmonogramu}                                                & 10                                                                                & \bodyHarmonogram                                             \\ \hline
5                  & \multicolumn{2}{l|}{Samostatný prístup k práci}                                                     & 20                                                                                & \bodySamostatnost                                            \\ \hline
                   & \multicolumn{1}{l|}{\textbf{Spolu}}                            &                                    & \textbf{100}                                                                      & \textbf{\bodySpolu}                                          \\ \hline
\end{tabular}
\label{tab:my-table}
\end{table}
}

\newcommand{\DrawWordEvaluation}[1]{
    Slovné hodnotenie: \\
    \input{#1}
    \newline
}

\newcommand{\printOriginalityStatement}[1]{
    \newline Stanovisko k výsledku kontroly originality bakalárskej práce: \\
    Protokol o kontrole originality preukázal mieru zhody s indexom prác korpusu CRZP \crzpRatio\ \%.
    \input{#1}
    \newline
}

\newcommand{\DrawAutoGrade}{
  \AutoGrade
  \newline
  Hodnotenie známkou: \textbf{\finalGrade}
  \newline
}

\newcommand{\DrawRecommendation}{
  \AutoRecommendation
  \newline
  Bakalársku prácu \textbf{\recommendation{}} na obhajobu.
  \newline
}

\newcommand{\DrawFooter}{
\vspace{1em}
\newline
Dňa: \printDate

\vspace{3em}

\begin{flushright}
  \makebox[6cm]{\dotfill} \\ % riadok bodiek (šírka nastaviteľná)
  \makebox[6cM]{\centering \small podpis ved\'{u}ceho}
\end{flushright}
}

\newcommand{\DrawEvaluationCriteria}[1]{
    \newpage
    \pagestyle{plain}
    \textbf{\large Príloha: Kritériá bodového hodnotenia}
    \input{#1}
}
