# Indiana 2026 Marketplace plans: monthly premium vs. medical deductible
# Source: CMS 2026 QHP Individual Market Medical Landscape workbook
# Place individual_market_medical.xlsx in the same folder as this script.
# Install readxl once if needed: install.packages("readxl")
library(readxl)

# The workbook has a banner in row 1; column names are in row 2.
plans <- read_excel("individual_market_medical.xlsx", sheet = 1, skip = 1,
                    .name_repair = "unique")
names(plans) <- trimws(names(plans))

# Select Indiana records and the matching individual premium/deductible measures.
indiana <- plans[trimws(as.character(plans[["State Code"]])) == "IN", ]

# Remove currency symbols and thousands separators before converting to numbers.
to_number <- function(x) suppressWarnings(as.numeric(gsub("[$,]", "", as.character(x))))
indiana$premium <- to_number(indiana[["Premium Adult Individual Age 40"]])
indiana$deductible <- to_number(indiana[["Medical Deductible - Individual - Standard"]])
valid <- is.finite(indiana$premium) & is.finite(indiana$deductible)
plot_data <- indiana[valid, ]

cat("All-state rows:", nrow(plans), "\n")
cat("Indiana rows:", nrow(indiana), "\n")
cat("Rows dropped:", sum(!valid), "\n")
cat("Rows plotted:", nrow(plot_data), "\n")

# The axes match the graph described in the project results: premium on x,
# medical deductible on y. Each point is a plan-county-metal record.
png("in_premium_vs_deductible_R.png", width = 1100, height = 760, res = 120)
plot(plot_data$premium, plot_data$deductible,
     main = paste0("Indiana Marketplace plans, 2026 (n = ", nrow(plot_data), ")"),
     xlab = "Monthly premium, adult age 40 ($)",
     ylab = "Medical deductible, individual, standard plan ($)",
     pch = 16, cex = 0.38, col = rgb(0.12, 0.36, 0.65, alpha = 0.55))
grid()
dev.off()
