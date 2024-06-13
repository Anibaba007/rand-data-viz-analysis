library(ggplot2)
library(dplyr)
library(here)
library(ggtext)
library(ggimage)

base_path <- here("arsenal-consistency")

arsenal_df <- tribble(
  ~opponent, ~home_away, ~result_ht, ~result_ft, ~shortontarget_ht, ~shortontarget_ft, ~successfuldribble_ht, ~successfuldribble_ft, ~rating_ht, ~rating_ft,
  "EVE", "h", "1-1", "2-1",2
,3,2,5,6.38,6.74,
"MAN U","a","0-1","0-1",1,4,2,7,6.19,6.89,
"BOURN", "h","1-0","3-0",4,6,7,13,6.66,7.50,
"TOT","a","0-3","2-3",0,1,5,9,6.96,6.77,
"CHE","h","1-0","5-0",2,5,4,5,6.74,7.57)

arsenal_df <- arsenal_df %>% 
  mutate(image = here(base_path,"input", glue::glue("{opponent}.png")))

ragg::agg_png(here(base_path, "plots", "ArsenalFC.png"), res = 300,
              width = 7, height = 7, units = "in")

arsenal_df %>%
  mutate(match_id = row_number(),
         opponent_home_away = paste0(opponent, " (", home_away, ")"),
         opponent_home_away = forcats::fct_inorder(opponent_home_away),
         opponent_home_away = forcats::fct_rev(opponent_home_away)) %>% ggplot() +
  geom_segment(aes(x = opponent_home_away, xend = opponent_home_away, 
                   y = rating_ht, yend = rating_ft),
               col = "grey50", size = 1.25) +
  geom_point(aes(opponent_home_away, rating_ht, fill = "Halftime"),
             shape = 21, col = "white", size = 3) +
  geom_point(aes(opponent_home_away, rating_ft, fill = "Fulltime"),
             shape = 21, col = "black",  size = 3) +
  geom_text(aes(opponent_home_away, y = pmin(rating_ht, rating_ft), label = opponent_home_away),
            hjust = 0, nudge_x = 0.3, nudge_y = 0.05,
            family = "Roboto Condensed Bold", col = "grey80") +
  geom_image(aes(opponent_home_away, y = pmin(rating_ht, rating_ft), image = image),
             size = 0.03, nudge_x = 0.3, nudge_y = 0.025) +
  scale_fill_manual(values = c("white", "#DF3021")) + 
  coord_flip(ylim = c(6, 8)) +
  guides(fill = "none" # guide_legend(title = NULL)
  ) +
  labs(
    title = toupper("Arsenal FC Ratings in the last 5 Matches"),
    subtitle = "DIFFERENCE BETWEEN <b style='color:#DF3021'>FIRST</b> AND <b style='color:white'>SECOND</b> HALF",
    caption = "**Source:** WhoScored.com | **Visualization:** Quadri A. Anibaba",
    y = "WhoScored Rating"
  ) +
  theme_minimal(base_family = "Roboto Condensed") +
  theme(
    plot.background = element_rect(color = NA, fill = "#373B4A"),
    axis.text.y = element_blank(),
    panel.grid = element_blank(),
    panel.grid.major.x = element_line(linewidth = 0.1, linetype = "dotted", color = "grey89"),
    legend.position = "top",
    legend.justification = "left",
    text = element_text(color = "grey82"),
    plot.title = element_text(color = "#9DD949", face = "bold", size = 18),
    plot.subtitle = element_markdown(size = 12, margin = margin(b = 12)),
    plot.caption = element_markdown(),
    axis.title.y = element_blank(),
    axis.title.x = element_text(hjust = 0),
    axis.text = element_text(color = "grey84")
  )
dev.off()

## Short on target ----

ragg::agg_png(here(base_path, "plots", "Shots on Target.png"), res = 300,
              width = 8, height = 7, units = "in")

arsenal_df %>%
  mutate(match_id = row_number(),
         opponent_home_away = paste0(opponent, " (", home_away, ")"),
         opponent_home_away = forcats::fct_inorder(opponent_home_away),
         opponent_home_away = forcats::fct_rev(opponent_home_away)) %>% ggplot() +
  geom_segment(aes(x = opponent_home_away, xend = opponent_home_away, 
                   y = shortontarget_ht, yend = shortontarget_ft),
               col = "grey50", size = 1.25) +
  geom_point(aes(opponent_home_away, shortontarget_ht, fill = "Halftime"),
             shape = 21, col = "white", size = 3) +
  geom_point(aes(opponent_home_away, shortontarget_ft, fill = "Fulltime"),
             shape = 21, col = "black",  size = 3) +
  geom_text(aes(opponent_home_away, y = pmin(shortontarget_ht, shortontarget_ft), label = opponent_home_away),
            hjust = 0, nudge_x = 0.3, nudge_y = 0.05,
            family = "Roboto Condensed Bold", col = "grey80") +
  geom_image(aes(opponent_home_away, y = pmin(shortontarget_ht, shortontarget_ft), image = image),
             size = 0.03, nudge_x = 0.3, nudge_y = 0.005) +
  scale_fill_manual(values = c("white", "#DF3021")) + 
  coord_flip(ylim = c(0, 6.5)) +
  guides(fill = "none" # guide_legend(title = NULL)
  ) +
  labs(
    title = toupper("Arsenal FC Shots on Target in the last 5 Matches"),
    subtitle = "DIFFERENCE BETWEEN <b style='color:#DF3021'>FIRST</b> AND <b style='color:white'>SECOND</b> HALF",
    caption = "**Source:** arsenal.com | **Visualization:** Quadri A. Anibaba",
    y = "Arsenal FC"
  ) +
  theme_minimal(base_family = "Roboto Condensed") +
  theme(
    plot.background = element_rect(color = NA, fill = "#373B4A"),
    axis.text.y = element_blank(),
    panel.grid = element_blank(),
    panel.grid.major.x = element_line(linewidth = 0.1, linetype = "dotted", color = "grey89"),
    legend.position = "top",
    legend.justification = "left",
    text = element_text(color = "grey82"),
    plot.title = element_text(color = "#9DD949", face = "bold", size = 18),
    plot.subtitle = element_markdown(size = 12, margin = margin(b = 12)),
    plot.caption = element_markdown(),
    axis.title.y = element_blank(),
    axis.title.x = element_text(hjust = 0),
    axis.text = element_text(color = "grey84")
  )
dev.off()
