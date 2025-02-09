% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rate_plot.R
\name{get_rate_summary}
\alias{get_rate_summary}
\title{Rates summary}
\usage{
get_rate_summary(
  seahorse_rates,
  measure = "OCR",
  assay,
  model = "ols",
  error_metric = "ci",
  conf_int = 0.95,
  sep_reps = FALSE,
  ci_method = "Wald"
)
}
\arguments{
\item{seahorse_rates}{data.table Seahorse OCR and ECAR rates (imported using \code{read_data} function)}

\item{measure}{Whether to calculate summary for \code{"OCR"} or \code{"ECAR"}}

\item{assay}{What assay to calculate summary for (e.g. "MITO" or "GLYCO")}

\item{model}{The model used to estimate mean and confidence intervals:}

\item{error_metric}{Whether to calculate error as standard deviations (\code{"sd"}) or confidence intervals (\code{"ci"})}

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
a data.table with means, standard deviations/standard error with bounds around the mean(sd or confidence intervals)
}
\description{
Summarize OCR and ECAR as mean and bounded standard deviations or standard error with confidence intervals
}
\examples{
rep_list <- system.file("extdata", package = "ceas") |>
  list.files(pattern = "*.xlsx", full.names = TRUE)
seahorse_rates <- read_data(rep_list, sheet = 2)
combined_reps <- get_rate_summary(
  seahorse_rates,
  measure = "OCR",
  assay = "MITO",
  model = "ols",
  error_metric = "ci",
  conf_int = 0.95,
  sep_reps = FALSE
)
head(combined_reps, n = 10)

# separate replicates
sep_reps <- get_rate_summary(
  seahorse_rates,
  measure = "OCR",
  assay = "MITO",
  model = "ols",
  error_metric = "ci",
  conf_int = 0.95,
  sep_reps = TRUE
)
head(sep_reps, n = 10)

# mixed effects model
reps_as_random_effects <- get_rate_summary(
  seahorse_rates,
  measure = "OCR",
  assay = "MITO",
  model = "mixed",
  error_metric = "ci",
  conf_int = 0.95,
  sep_reps = FALSE
)
head(reps_as_random_effects, n = 10)
}
