library(here)
library(dplyr)
source(paste0(here(), "/code/config.R"))

# Read SPSS files C:/Users/dof-mccullaghp/Documents/R/2025dryrun/Tech Lab - PCOS/Raw/CHS_PCOS25_FINAL
data_pcos_provisional <- f_read_spss(filepath = paste0(data_folder, 
                                          "Raw/", 
                                          data_filename),
                                          pass = password)

data_pcos_final <- f_read_spss(filepath = paste0(data_folder, 
                                          "Raw/", 
                                          data_filename2),
                                          pass = password)


# Check dimensions
dim(data_pcos_provisional)
dim(data_pcos_final)

# PERSONIDs in df1 but not df2

diff_id <- anti_join(data_pcos_provisional, data_pcos_final, by = "PERSONID") %>%
            select(PERSONID)

# diff check of PCOS and Weights

vars_to_compare <- c(
  paste0("W", 1:3),
  names(data_pcos_final %>% select(PCOS1:PCOS6))
)

final_subset <- data_pcos_final %>%
  select(PERSONID, all_of(vars_to_compare))

provisional_subset <- data_pcos_provisional %>%
  select(PERSONID, all_of(vars_to_compare))

comparison <- final_subset %>%
  inner_join(
    provisional_subset,
    by = "PERSONID",
    suffix = c("_final", "_provisional")
  )

for (var in vars_to_compare) {
  comparison[[paste0(var, "_match")]] <-
    comparison[[paste0(var, "_final")]] ==
    comparison[[paste0(var, "_provisional")]]
}

match_cols <- paste0(vars_to_compare, "_match")

mismatches <- comparison %>%
  filter(!if_all(all_of(match_cols), identity))

nrow(mismatches)

mismatches %>%
  summarise(
    across(
      all_of(match_cols),
      ~ sum(!., na.rm = TRUE),
      .names = "{.col}_count"
    )
  )

mismatches %>%
  select(
    PERSONID,
    ends_with("_final"),
    ends_with("_provisional")
  )






