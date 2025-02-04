pacman::p_load(tidyverse, here, scales)

tract_data <- read_csv(here("data", "combined_tract_clean.csv"))

#### Main Text Plot ####
# Create main text plot with geographic restrictions
main_text_plot <- tract_data %>% 
  filter(in_1970 == TRUE & top_cbsa == TRUE & !is.na(poverty_rate & (fb + nb) > 0)) %>% 
  pivot_longer(
    cols = c(fb, nb),             # Reshape the dataset for foreign-born and native-born
    names_to = "nativity",        # Create a new column indicating nativity
    values_to = "population"      # Create a column for population
  ) %>% 
  group_by(year, nativity) %>%
  mutate(total_population = sum(population, na.rm = TRUE)) %>%   # Calculate total population per group per year
  ungroup() %>%
  mutate(weight = population / total_population) %>% # Weight as fraction of total group population
  ggplot(aes(x = poverty_rate, color = nativity, weight = weight)) + # pass clean data to ggplot
  geom_vline(xintercept = c(.10, .40), linetype = "dashed", color = "black") +
  stat_bin(
    geom = "step", 
    aes(y = after_stat(count * 100)),
    position = "identity",
    breaks = seq(0, 1, 0.01),
    linewidth = .5
    ) +
  facet_wrap(~ year, ncol = 2) +  # One panel per year
  scale_color_manual(
    values = c("fb" = "darkorange", "nb" = "skyblue2"),  # Custom colors
    labels = c("fb" = "Foreign-Born", "nb" = "US-Born")
  ) +
  scale_x_continuous(
    labels = scales::percent,                     # X-axis as percentages
    name = "Tract Poverty Rate",
    breaks = seq(0, 1, .1)
  ) +
  scale_y_continuous(
    name = "Percent of Population",               # Y-axis label
    labels = scales::percent_format(scale = 1),   # Display percentages (e.g., 1%, 2%)
    breaks = seq(0, 10, 2)
  ) +
  theme_minimal(base_size = 12) +
  theme(
    strip.text = element_text(size = 12),  # Facet labels
    legend.title = element_blank(),
    legend.position = "bottom",
    axis.title = element_text(face = "bold"),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(linetype = "dashed"),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 1)  # Add black border to facets
  ) +
  coord_cartesian(xlim = c(0, .6))

# Save the plot
ggsave(
  here("output", "main_text_plot.png"),
  plot = main_text_plot,
  bg = "white",
  width = 6.5,
  height = 5,
  dpi = 500
)

#### Supplemental Plots ####
# Create alternative version without geographic filtering
all_tract_plot <- tract_data %>% 
  filter(!is.na(poverty_rate & (fb + nb) > 0)) %>% 
  pivot_longer(
    cols = c(fb, nb),             # Reshape the dataset for foreign-born and native-born
    names_to = "nativity",        # Create a new column indicating nativity
    values_to = "population"      # Create a column for population
  ) %>% 
  group_by(year, nativity) %>%
  mutate(total_population = sum(population, na.rm = TRUE)) %>%   # Calculate total population per group per year
  ungroup() %>%
  mutate(weight = population / total_population) %>% # Weight as fraction of total group population
  ggplot(aes(x = poverty_rate, color = nativity, weight = weight)) + # pass clean data to ggplot
  geom_vline(xintercept = c(.10, .40), linetype = "dashed", color = "black") +
  stat_bin(
    geom = "step", 
    aes(y = after_stat(count * 100)),
    position = "identity",
    breaks = seq(0, 1, 0.01),
    linewidth = .5
  ) +
  facet_wrap(~ year, ncol = 2) +  # One panel per year
  scale_color_manual(
    values = c("fb" = "darkorange", "nb" = "skyblue2"),  # Custom colors
    labels = c("fb" = "Foreign-Born", "nb" = "US-Born")
  ) +
  scale_x_continuous(
    labels = scales::percent,                     # X-axis as percentages
    name = "Tract Poverty Rate",
    breaks = seq(0, 1, .1)
  ) +
  scale_y_continuous(
    name = "Percent of Population",               # Y-axis label
    labels = scales::percent_format(scale = 1),   # Display percentages (e.g., 1%, 2%)
    breaks = seq(0, 10, 2)
  ) +
  theme_minimal(base_size = 12) +
  theme(
    strip.text = element_text(size = 12),  # Facet labels
    legend.title = element_blank(),
    legend.position = "bottom",
    axis.title = element_text(face = "bold"),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(linetype = "dashed"),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 1)  # Add black border to facets
  ) +
  coord_cartesian(xlim = c(0, .6))

# Save the plot
ggsave(
  here("output", "all_tract_plot.png"),
  plot = all_tract_plot,
  bg = "white",
  width = 6.5,
  height = 5,
  dpi = 500
)


# Create alternative version with kernel density curves
density_plot <- tract_data %>% 
  filter(in_1970 == TRUE & top_cbsa == TRUE & !is.na(poverty_rate & (fb + nb) > 0)) %>% 
  pivot_longer(
    cols = c(fb, nb),             # Reshape the dataset for foreign-born and native-born
    names_to = "nativity",        # Create a new column indicating nativity
    values_to = "population"      # Create a column for population
  ) %>% 
  group_by(year, nativity) %>%
  mutate(total_population = sum(population, na.rm = TRUE)) %>%   # Calculate total population per group per year
  filter(!is.na(population)) %>% 
  ungroup() %>%
  mutate(weight = population / total_population) %>% # Weight as fraction of total group population
  ggplot(aes(x = poverty_rate, color = nativity, weight = population)) + # pass clean data to ggplot
  geom_vline(xintercept = c(.10, .40), linetype = "dashed", color = "black") + 
  geom_density(linewidth = .6) +
  facet_wrap(~ year, ncol = 2) + 
  scale_color_manual(
    values = c("fb" = "darkorange", "nb" = "skyblue2"),  # Custom colors
    labels = c("fb" = "Foreign-Born", "nb" = "US-Born")
  ) +
  scale_x_continuous(
    labels = scales::percent,                     # X-axis as percentages
    name = "Tract Poverty Rate",
    breaks = seq(0, 1, .1)
  )+
  theme_minimal(base_size = 12) +
  theme(
    strip.text = element_text(size = 12),  # Facet labels
    legend.title = element_blank(),
    legend.position = "bottom",
    axis.title = element_text(face = "bold"),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(linetype = "dashed"),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 1)  # Add black border to facets
  ) + 
  coord_cartesian(xlim = c(0, .6)) + 
  guides(color = guide_legend(override.aes = list(fill = c("darkorange", "skyblue2"))))

# Save the plot
ggsave(
  here("output", "density_plot.png"),
  plot = density_plot,
  bg = "white",
  width = 6.5,
  height = 5,
  dpi = 500
)
