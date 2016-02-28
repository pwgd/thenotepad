◊(local-require "../util-date.rkt")
◊(define (print-if thing fmt)
   (if thing (format fmt thing) ""))
\documentclass[11pt]{article}

\usepackage{amssymb,amsmath}
\usepackage{fixltx2e} % provides \textsubscript

\usepackage[T1]{fontenc}
\usepackage[utf8]{inputenc}
\usepackage{eurosym}

\usepackage{mathspec}
\usepackage{xltxtra,xunicode}
\defaultfontfeatures{Mapping=tex-text,Scale=MatchLowercase}

% use upquote if available, for straight quotes in verbatim environments
\IfFileExists{upquote.sty}{\usepackage{upquote}}{}
% use microtype if available
\IfFileExists{microtype.sty}{\usepackage{microtype}}{}

%% Typography defaults
\setsansfont{Fira Sans OT}
\setmainfont{Charter}
\setmonofont{Triplicate T4c}

\usepackage{color}
\definecolor{mygray}{rgb}{0.7,0.7,0.7}
\definecolor{light-gray}{gray}{0.95}

\usepackage{listings}
\lstset{
   basicstyle=\small\ttfamily,
   columns=flexible,
   breaklines=true,
   numbers=left,
   backgroundcolor=\color{light-gray},
   numbersep=5pt,
   xleftmargin=.25in,
   xrightmargin=.25in,
   numberstyle=\small\color{mygray}\ttfamily\itshape
}

\usepackage{fancyvrb}

\usepackage{longtable,booktabs}

\usepackage{graphicx}

\makeatletter
\def\maxwidth{\ifdim\Gin@nat@width>\linewidth\linewidth\else\Gin@nat@width\fi}
\def\maxheight{\ifdim\Gin@nat@height>\textheight\textheight\else\Gin@nat@height\fi}
\makeatother

% Scale images if necessary, so that they will not overflow the page
% margins by default, and it is still possible to overwrite the defaults
% using explicit options in \includegraphics[width, height, ...]{}
\setkeys{Gin}{width=\maxwidth,height=\maxheight,keepaspectratio}

 \usepackage[setpagesize=false, % page size defined by xetex
             unicode=false, % unicode breaks when used with xetex
             xetex]{hyperref}

\hypersetup{breaklinks=true,
           bookmarks=true,
           pdfauthor={◊(print-if (select-from-metas 'author metas) "~a")},
           pdftitle={◊(print-if (select-from-metas 'title metas) "~a")},
           colorlinks=true,
           citecolor=blue,
           urlcolor=blue,
           linkcolor=magenta,
           pdfborder={0 0 0}}
\urlstyle{same}  % don't use monospace font for urls

% Make links footnotes instead of hotlinks:
\renewcommand{\href}[2]{#2\footnote{\url{#1}}}

\setlength{\parindent}{0pt}
\setlength{\parskip}{6pt plus 2pt minus 1pt}
\setlength{\emergencystretch}{3em}  % prevent overfull lines

\setcounter{secnumdepth}{0}

\VerbatimFootnotes % allows verbatim text in footnotes

\title{◊(print-if (select-from-metas 'title metas) "~a")}
\author{◊(print-if (select-from-metas 'author metas) "~a")}
\date{◊(unless (not (select-from-metas 'published metas)) (pubdate->english (select-from-metas 'published metas)))}

%% Reduced margins
%\usepackage[margin=1.2in]{geometry}

%% Paragraph and line spacing
%\linespread{1.05} % a bit more vertical space
%\setlength{\parskip}{\baselineskip} % space between paragraphs spacing is one baseline unit

%% Sections headings spacing: one baseline unit before, none after
\usepackage{titlesec}
\titlespacing{\section}{0pt}{\baselineskip}{0pt}
\titlespacing{\subsection}{0pt}{\baselineskip}{0pt}
\titlespacing{\subsubsection}{0pt}{\baselineskip}{0pt}

% Customize footnotes so that, within the footnote, the footnote number is
% the same size as the footnote text (per Bringhurst).
%
\usepackage[splitrule,multiple,hang]{footmisc}
\makeatletter
\renewcommand\@makefntext[1]{\parindent 1em%
   \noindent
   \hb@xt@0em{\hss\normalfont\@thefnmark.} #1}
\def\splitfootnoterule{\kern-3\p@ \hrule width 1in \kern2.6\p@}
\makeatother
\renewcommand\footnotesize{\fontsize{8}{10} \selectfont}
\renewcommand{\thefootnote}{\arabic{footnote}}

%% Main doc
\begin{document}

\maketitle

◊(local-require racket/list)
◊(apply string-append (filter string? (flatten doc)))

\end{document}