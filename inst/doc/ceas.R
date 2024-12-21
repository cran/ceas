## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(ceas)

## ----data_custom_dir, eval=FALSE----------------------------------------------
#  rep_list <- list.files("seahorse_data", pattern = "*.xlsx", full.names = TRUE)

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
norm_csv
exp_group_norm <- norm_csv[1]
well_norm <- norm_csv[2]

read.csv(exp_group_norm) |>
    knitr::kable(caption = "For normalizing by experimental group")
read.csv(well_norm) |> head() |>
    knitr::kable(caption = "For normalizing by well")

## ----normalized_read----------------------------------------------------------
read_data(
    rep_list,
    norm = exp_group_norm,
    norm_column = "exp_group",
    norm_method = "self"
) |> head() |> knitr::kable()

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

## ----bioscope_plot, fig.cap="Bioenergetic scope with replicates combined", out.width = "100%", fig.dim = c(5, 3), dpi = 120----
bioscope <- bioscope_plot(
  energetics,
  model = "ols",
  sep_reps = FALSE
)
bioscope

## ----bioscope_plot_lme, fig.cap="Bioenergetic scope based on a mixed-effects model with replicates as random effect", message = FALSE, out.width = "100%", fig.dim = c(5, 3), dpi = 120----
bioscope_plot(energetics, sep_reps = FALSE, model = "mixed")

## ----bioscope_plot_sep_reps, fig.cap="Bioenergetic scope with replicates separated", out.width = "100%", fig.dim = c(5, 3), dpi = 120----
bioscope_plot(energetics, sep_reps = TRUE, model = "ols")

## ----ocr, fig.cap="OCR with replicates combined", out.width = "100%", fig.dim = c(5, 3), dpi = 120----
ocr <- rate_plot(
  seahorse_rates,
  measure = "OCR",
  assay = "MITO",
  model = "ols",
  sep_reps = FALSE
)
ocr

## ----ocr_lme, fig.cap="OCR based on mixed-effects model", out.width = "100%", fig.dim = c(5, 3), dpi = 120----
rate_plot(
  seahorse_rates,
  measure = "OCR",
  assay = "MITO",
  model = "mixed",
  sep_reps = FALSE
)

## ----ocr_sep_reps, fig.cap="OCR with replicates separated", out.width = "100%", fig.dim = c(5, 3), dpi = 120----
rate_plot(
  seahorse_rates,
  measure = "OCR",
  assay = "MITO",
  model = "ols",
  sep_reps = TRUE,
  linewidth = 1
)

## ----ecar, fig.cap="ECAR with replicates combined", out.width = "100%", fig.dim = c(5, 3), dpi = 120----
ecar <- rate_plot(
  seahorse_rates,
  measure = "ECAR",
  assay = "GLYCO",
  model = "ols",
  sep_reps = FALSE
)
ecar

## ----ecar_lme, fig.cap="ECAR based on mixed-effects model", out.width = "100%", fig.dim = c(5, 3), dpi = 120----
rate_plot(
  seahorse_rates,
  measure = "ECAR",
  assay = "GLYCO",
  model = "mixed",
  sep_reps = FALSE
)

## ----ecar_sep, fig.cap="ECAR with replicates separated", out.width = "100%", fig.dim = c(5, 3), dpi = 120----
rate_plot(
  seahorse_rates,
  measure = "ECAR",
  assay = "GLYCO",
  model = "ols",
  sep_reps = TRUE,
  linewidth = 1

)

## ----basal_glyc, fig.cap="JATP from basal glycolysis with replicates combined", out.width = "100%", fig.dim = c(5, 3), dpi = 120----
basal_glyc <- atp_plot(
  energetics,
  basal_vs_max = "basal",
  glyc_vs_resp = "glyc",
  sep_reps = FALSE
)
basal_glyc 

## ----basal_resp, fig.cap="JATP from basal respiration with replicates separated", out.width = "100%", fig.dim = c(5, 3), dpi = 120----
atp_plot(
  energetics,
  basal_vs_max = "basal",
  glyc_vs_resp = "resp",
  model = "ols",
  sep_reps = TRUE
)

## ----max_glyc, fig.cap="JATP from maximal glycolysis with a mixed-effects model", out.width = "100%", fig.dim = c(5, 3), dpi = 120----
atp_plot(
  energetics,
  basal_vs_max = "max",
  glyc_vs_resp = "glyc",
  model = "mixed",
  sep_reps = FALSE
)

## ----max_resp, fig.cap="JATP from maximal respiration replicates combined", out.width = "100%", fig.dim = c(5, 3), dpi = 120----
atp_plot(
  energetics,
  basal_vs_max = "max",
  glyc_vs_resp = "resp",
  model = "ols",
  sep_reps = TRUE
)

## ----custom_colors, out.width = "100%", fig.dim = c(5, 3), dpi = 120----------
custom_colors <- c("#e36500", "#b52356", "#3cb62d", "#328fe1")

## ----, out.width = "100%", fig.dim = c(5, 3), dpi = 120-----------------------
bioscope +
ggplot2::scale_color_manual(
  values = custom_colors
)

## ----out.width = "100%", fig.dim = c(5, 3), dpi = 120-------------------------
ocr +
ggplot2::scale_color_manual(
  values = custom_colors
)

## ----out.width = "100%", fig.dim = c(5, 3), dpi = 120-------------------------
ecar +
    ggplot2::labs(x = "Time points")

## ----out.width = "100%", fig.dim = c(5, 3), dpi = 120-------------------------
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

