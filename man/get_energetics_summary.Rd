% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/energetics.R
\name{get_energetics_summary}
\alias{get_energetics_summary}
\title{Calculate ATP Production Mean and Standard Deviation}
\usage{
get_energetics_summary(
  energetics,
  model = "ols",
  error_metric = "ci",
  conf_int = 0.95,
  sep_reps = FALSE,
  ci_method = "Wald"
)
}
\arguments{
\item{energetics}{a data.table of Seahorse OCR and ECAR rates (from \code{get_energetics})}

\item{model}{The model used to estimate mean and confidence intervals:
ordinary least squares (\code{"ols"}) or mixed-effects (\code{"mixed"})}

\item{error_metric}{Whether to calculate error as standard deviation (\code{"sd"}) or confidence intervals (\code{"ci"})}

\item{conf_int}{The confidence interval percentage. Should be between 0 and 1}

\item{sep_reps}{Whether to calculate summary statistics on the groups with
replicates combined. The current default \code{FALSE} combines replicates, but
future releases will default to \code{TRUE} providing replicate-specific
summaries.}

\item{ci_method}{The method used to compute confidence intervals for the
mixed-effects model: \code{"Wald"}, \code{"profile"}, or \code{"boot"} passed to
\code{lme4::confint.merMod()}.}
}
\value{
a list of groups from the data
}
\description{
Calculates mean and standard deviation of ATP production from glycolysis and
OXPHOS at points defined in \code{partition_data} and with values calculated
using the \code{get_energetics} function via ordinary least squares or a
mixed-effects model
}
\details{
To get the means and confidence intervals for experiments with replicates,
users can either use \code{sep_reps = TRUE} to get replicate-level summary
statistics or set \code{model = "mixed"} to use a linear mixed-effects model on
with replicate as the random-effect. The confidence intervals are generated
using \code{confint(method = "Wald")}.
}
\examples{
rep_list <- system.file("extdata", package = "ceas") |>
  list.files(pattern = "*.xlsx", full.names = TRUE)
seahorse_rates <- read_data(rep_list, sheet = 2)
partitioned_data <- partition_data(seahorse_rates)
energetics_list <- get_energetics(
  partitioned_data,
  ph = 7.4,
  pka = 6.093,
  buffer = 0.1
)
energetics_summary <- get_energetics_summary(energetics_list, sep_reps = FALSE)
head(energetics_summary[, c(1:5)], n = 10)
head(energetics_summary[, c(1, 2, 6, 7)], n = 10)
}
