# 05_retention_vs_churn_decay.R
# Antonio Fuentes Moreno - E-commerce Sales & Customer Analytics
# Page 3 - Customer Retention | Retention vs Churn Decay (19% M1 - Real KPI)
# This script reproduces the executive chart used in Power BI P3
# Data source: retention_curve (Month, Retention) - Average cohort

library(ggplot2)
library(scales)

# DATOS REALES DEL DASHBOARD - NO EJEMPLO
# Month-1 Retention = 19% (81% Churn) - validated from 25 cohorts
df <- data.frame(
  Month = c(0,1,2,3,4,5,6,9,12),
  Retention = c(1,0.19,0.14,0.13,0.12,0.11,0.10,0.09,0.08)
)
df$Churn <- 1 - df$Retention

# Plot - PRO version with fixed annotation (19% readable, not 49%)
p <- ggplot(df, aes(x = Month)) +
  geom_area(aes(y = Retention), fill = "#2E86AB", alpha = 0.12) +
  geom_line(aes(y = Retention, color = "Retention"), size = 1.6) +
  geom_point(aes(y = Retention, color = "Retention"), size = 4) +
  geom_line(aes(y = Churn, color = "Churn"), size = 1.3, linetype = "dashed") +
  geom_point(aes(y = Churn, color = "Churn"), size = 3.5) +
  # Fixed: labels separated from points to avoid 19% looking like 49%
  annotate("text", x = 1.8, y = 0.22, label = "19% Retention M1", color = "#2E86AB", fontface = "bold", hjust = 0, size = 4.5) +
  annotate("text", x = 1.8, y = 0.68, label = "81% Churn M1", color = "#E74C3C", fontface = "bold", hjust = 0, size = 4.5) +
  geom_curve(aes(x = 1.8, y = 0.25, xend = 1.12, yend = 0.195), color = "#2E86AB", curvature = 0.2, arrow = arrow(length = unit(0.02, "npc"))) +
  geom_curve(aes(x = 1.8, y = 0.71, xend = 1.12, yend = 0.795), color = "#E74C3C", curvature = -0.2, arrow = arrow(length = unit(0.02, "npc"))) +
  scale_x_continuous(breaks = c(0,1,2,3,4,5,6,9,12), labels = c("M0","M1","M2","M3","M4","M5","M6","M9","M12")) +
  scale_y_continuous(labels = percent, limits = c(0,1.05), breaks = c(0,0.25,0.5,0.75,1)) +
  scale_color_manual(values = c("Retention" = "#2E86AB", "Churn" = "#E74C3C")) +
  labs(title = "Retention vs Churn Decay — Average Cohort", subtitle = "Avg M1 Retention 19% | 25 cohorts tracked | 24-month window", x = NULL, y = NULL, color = NULL) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0),
    plot.subtitle = element_text(size = 10, color = "grey40", hjust = 0),
    legend.position = "bottom",
    panel.grid.minor = element_blank()
  )

# Save to figures/ for GitHub and Desktop
# ggsave auto-detects path - adjust if needed
ggsave("figures/retention_vs_churn_19pro.png", plot = p, width = 10, height = 5.5, dpi = 300)
ggsave("~/Desktop/retention_vs_churn_19pro.png", plot = p, width = 10, height = 5.5, dpi = 300)

print(p)
