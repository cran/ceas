% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fit_lme.R
\name{fit_lme}
\alias{fit_lme}
\title{Estimate mean and confidence intervals using a mixed-effects model}
\usage{
fit_lme(
  data_col,
  input,
  group_colname = "exp_group",
  rep_colname = "replicate"
)
}
\arguments{
\item{data_col}{The column name of the ATP measure ("ATP_basal_resp",
"ATP_max_resp", "ATP_basal_glyc", "ATP_max_glyc") or rate measure ("OCR", "ECAR")}

\item{input}{The dataset containing \code{data_col} from \code{get_energetics} or \code{read_data}}

\item{group_colname}{The column containing experimental group names}

\item{rep_colname}{The column containing replicate IDs}
}
\value{
an \code{lme4::lmer} mixed effects model
}
\description{
Estimates mean and standard deviation of energetics or rates with
replicates as the random-effect
}
\examples{
rep_list <- system.file("extdata", package = "ceas") |>
  list.files(pattern = "*.xlsx", full.names = TRUE)
seahorse_rates <- read_data(rep_list, sheet = 2)
partitioned_data <- partition_data(seahorse_rates)
energetics <- get_energetics(partitioned_data, ph = 7.4, pka = 6.093, buffer = 0.1)
fit_lme("ATP_max_glyc", energetics)
}
\keyword{internal}
