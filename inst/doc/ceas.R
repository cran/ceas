## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(ceas)

## ----data---------------------------------------------------------------------
rep_list <- system.file("extdata", package = "ceas") |>
  list.files(pattern = "*.xlsx", full.names = TRUE)
raw_data <- readxl::read_excel(rep_list[1], sheet = 2)
knitr::kable(head(raw_data))

## ----read_dataformat----------------------------------------------------------
seahorse_rates <- read_data(rep_list)
knitr::kable(head(seahorse_rates))

## ----norm_csv-----------------------------------------------------------------
norm_csv <- system.file("extdata", package = "ceas") |>
  list.files(pattern = "norm.csv", full.names = TRUE)
read.csv(norm_csv) |> knitr::kable()

## ----normalized_read----------------------------------------------------------
read_data(rep_list, norm = norm_csv) |> head() |> knitr::kable()

## ----partition_data-----------------------------------------------------------
partitioned_data <- partition_data(seahorse_rates)

## ----eval = FALSE-------------------------------------------------------------
#  partitioned_data <- partition_data(
#    seahorse_rates,
#    assay_types = list(
#      basal = "MITO",
#      uncoupled = "MITO",
#      maxresp = "MITO",
#      nonmito = "MITO",
#      no_glucose_glyc = "GLYCO",
#      glucose_glyc = "GLYCO",
#      max_glyc = "GLYCO"
#    ),
#    basal_tp = 3,
#    uncoupled_tp = 6,
#    maxresp_tp = 8,
#    nonmito_tp = 12,
#    no_glucose_glyc_tp = 3,
#    glucose_glyc_tp = 6,
#    max_glyc_tp = 8
#  )

## ----eval = FALSE-------------------------------------------------------------
#  partitioned_data <- partition_data(
#    seahorse_rates,
#    assay_types = list(
#      basal = "RefAssay",
#      uncoupled = "RefAssay",
#      maxresp = NA,
#      nonmito = "RefAssay",
#      no_glucose_glyc = "RefAssay",
#      glucose_glyc = "RefAssay",
#      max_glyc = NA
#    ),
#    basal_tp = 5,
#    uncoupled_tp = 10,
#    nonmito_tp = 12,
#    maxresp = NA,
#    no_glucose_glyc_tp = 1,
#    glucose_glyc_tp = 5,
#    max_glyc = NA
#  )
#  

## ----eval = FALSE-------------------------------------------------------------
#  partitioned_data <- partition_data(
#    seahorse_rates,
#    assay_types = list(
#      basal = "MITO",
#      uncoupled = "MITO",
#      maxresp = "MITO",
#      nonmito = "MITO",
#      no_glucose_glyc = NA,
#      glucose_glyc = "MITO",
#      max_glyc = NA
#    ),
#    basal_tp = 3,
#    uncoupled_tp = 6,
#    maxresp_tp = 8,
#    nonmito_tp = 12,
#    no_glucose_glyc_tp = NA,
#    glucose_glyc_tp = 3,
#    max_glyc_tp = NA
#  )

## ----eval = FALSE-------------------------------------------------------------
#  partitioned_data <- partition_data(
#    seahorse_rates,
#    assay_types = list(
#      basal = "RCR",
#      uncoupled = "RCR",
#      maxresp = "RCR,"
#      nonmito = "RCR",
#      no_glucose_glyc = NA,
#      glucose_glyc = "GC",
#      max_glyc = "GC"
#    ),
#    basal_tp = 3,
#    uncoupled_tp = 6,
#    maxresp_tp = 8,
#    nonmito_tp = 12,
#    no_glucose_glyc = NA,
#    glucose_glyc_tp = 3,
#    max_glyc_tp = 9
#  )

## ----get_energetics-----------------------------------------------------------
energetics <- get_energetics(partitioned_data, ph = 7.4, pka = 6.093, buffer = 0.10)

## ----bioscope_plot------------------------------------------------------------
(bioscope <- bioscope_plot(energetics))

## ----ocr----------------------------------------------------------------------
(ocr <- rate_plot(seahorse_rates, measure = "OCR", assay = "MITO"))

## ----ecar---------------------------------------------------------------------
(ecar <- rate_plot(seahorse_rates, measure = "ECAR", assay = "GLYCO"))

## ----basal_glyc---------------------------------------------------------------
(basal_glyc <- atp_plot(energetics, basal_vs_max = "basal", glyc_vs_resp = "glyc"))

## ----basal_resp---------------------------------------------------------------
(basal_resp <- atp_plot(energetics, basal_vs_max = "basal", glyc_vs_resp = "resp"))

## ----max_glyc-----------------------------------------------------------------
(max_glyc <- atp_plot(energetics, basal_vs_max = "max", glyc_vs_resp = "glyc"))

## ----max_resp-----------------------------------------------------------------
(max_resp <- atp_plot(energetics, basal_vs_max = "max", glyc_vs_resp = "resp"))

## ----custom_colors------------------------------------------------------------
custom_colors <- c("#e36500", "#b52356", "#3cb62d", "#328fe1")

## -----------------------------------------------------------------------------
bioscope +
ggplot2::scale_color_manual(
  values = custom_colors
)

## -----------------------------------------------------------------------------
ocr +
ggplot2::scale_color_manual(
  values = custom_colors
)

## -----------------------------------------------------------------------------
ecar +
    ggplot2::labs(x = "Time points")

## -----------------------------------------------------------------------------
basal_glyc +
    ggplot2::theme(axis.text = ggplot2::element_text(size = 20))

## ----eval = FALSE-------------------------------------------------------------
#  rate_plot

## ----results = 'asis', echo = FALSE-------------------------------------------
func_code <- capture.output(dput(rate_plot))
cat("```r\n")
cat(func_code, sep = "\n")
cat("\n```")

## ----eval = FALSE-------------------------------------------------------------
#  edit(rate_plot)

