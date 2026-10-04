# Build a wide Gapminder-style CSV for the poverty rate indicator
# (% of people living on less than $6.85 per day, Gapminder `gm_685pov_rate`).
# Source: Gapminder fasttrack DDF dataset, https://github.com/open-numbers/ddf--gapminder--fasttrack
# Output matches the layout of CSVs downloaded from gapminder.org/data: geo, name, 1800 ... 2100.

suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(tidyr)
})

base <- "https://raw.githubusercontent.com/open-numbers/ddf--gapminder--fasttrack/master/"

points <- read_csv(
  paste0(base, "countries_etc_datapoints/ddf--datapoints--gm_685pov_rate--by--country--time.csv"),
  show_col_types = FALSE
)
countries <- read_csv(paste0(base, "ddf--entities--geo--country.csv"), show_col_types = FALSE) |>
  select(geo = country, name)

wide <- points |>
  rename(geo = country) |>
  arrange(time) |>
  pivot_wider(names_from = time, values_from = gm_685pov_rate) |>
  left_join(countries, by = "geo") |>
  relocate(geo, name) |>
  arrange(name)

# Run from the week-02 folder: Rscript data/prepare_poverty.R
out <- "data/poverty_rate_under_6_85_usd_per_day.csv"
write_csv(wide, out, na = "")
message("Wrote ", nrow(wide), " countries to ", out)
