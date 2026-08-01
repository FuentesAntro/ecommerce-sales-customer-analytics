library(tidyverse)

cohort <- read.csv("data/processed/cohort_table.csv")

cohort_long <- cohort %>%
  pivot_longer(cols = -CohortMonth, names_to = "MonthIndex", values_to = "Retention") %>%
  mutate(
    MonthIndex = as.numeric(gsub("X", "", MonthIndex)),
    CohortMonth = factor(CohortMonth, levels = rev(unique(CohortMonth)))
  ) %>%
  filter(!is.na(Retention))

ggplot(cohort_long, aes(x = MonthIndex, y = CohortMonth, fill = Retention)) +
  geom_tile(color = "white", linewidth = 0.5) +
  geom_text(aes(label = scales::percent(Retention, accuracy = 1)), size = 2.8, color = "grey20") +
  scale_fill_gradient(low = "#EAF3FF", high = "#0C447C", labels = scales::percent) +
  scale_x_continuous(breaks = 0:24, expand = c(0, 0)) +
  labs(
    title = "Monthly cohort retention rate",
    x = "Months since first purchase",
    y = "Cohort (first purchase month)",
    fill = "Retention"
  ) +
  theme_minimal(base_size = 11) +
  theme(
    panel.grid = element_blank(),
    plot.title = element_text(face = "bold", size = 14),
    legend.position = "none"
  )

ggsave("figures/cohort_retention_heatmap_pro.png", width = 14, height = 9, dpi = 200, bg = "white")

cat("Heatmap guardado en figures/cohort_retention_heatmap_pro.png\n")