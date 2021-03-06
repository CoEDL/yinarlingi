% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/skeletonise_df.R
\name{skeletonise_df}
\alias{skeletonise_df}
\title{Discard lines whose codes do not occur in the Warlpiri dictionary skeleton grammar}
\usage{
skeletonise_df(wlp_lexicon,
  grammar_file = system.file("structures/wlp_skeleton-simple.ne", package
  = "yinarlingi"))
}
\arguments{
\item{wlp_lexicon}{a Warlpiri lexicon data frame, or path to a Warlpiri dictionary file}

\item{grammar_file}{a Nearley grammar file (default is `wlp_skeleton-simple.ne`)}
}
\description{
Discard lines whose codes do not occur in the Warlpiri dictionary skeleton grammar
}
