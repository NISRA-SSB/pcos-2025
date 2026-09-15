message("PfG Data Prep.R has started running")
library(here)
source(paste0(here(), "/code/ods_tables/data_prep_for_ods.R"))

# PfG Report Data Prep

## Assembly
pfg_assembly <- table_3.3a_data %>%
  filter(`Response (%)` != "Number of Respondents") %>%
  mutate(`Response (%)` = recode(`Response (%)`,
                                 "Don't Know" = "dont_know",
                                 "Tend to trust/trust a great deal" = "trust",
                                 "Tend to distrust/distrust greatly" = "distrust")) %>%
  pivot_longer(
    cols = -`Response (%)`,
    names_to = "year",
    values_to = "value"
  ) %>%
  pivot_wider(
    names_from = `Response (%)`,
    values_from = value
  )

pfg_assembly <- pfg_assembly %>%
  mutate(
    across(c(trust, distrust, dont_know), as.numeric),
    year = as.numeric(year)
  )

pfg_assembly$year <- factor(pfg_assembly$year)
rownames(pfg_assembly) <- as.character(seq_len(nrow(pfg_assembly)))


## Media
pfg_media <- table_3.4a_data %>%
  filter(`Response (%)` != "Number of Respondents") %>%
  mutate(`Response (%)` = recode(`Response (%)`,
                                 "Don't Know" = "dont_know",
                                 "Tend to trust/trust a great deal" = "trust",
                                 "Tend to distrust/distrust greatly" = "distrust")) %>%
  pivot_longer(
    cols = -`Response (%)`,
    names_to = "year",
    values_to = "value"
  ) %>%
  pivot_wider(
    names_from = `Response (%)`,
    values_from = value
  )

pfg_media <- pfg_media %>%
  mutate(
    across(c(trust, distrust, dont_know), as.numeric),
    year = as.numeric(year)
  )

pfg_media$year <- factor(pfg_media$year)
rownames(pfg_media) <- as.character(seq_len(nrow(pfg_media)))



