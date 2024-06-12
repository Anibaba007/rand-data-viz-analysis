# Install packages
pkgs <- c("ggplot2", "readr", "dplyr", "tibble", "tidyr", "lubridate",
          "scales", "ragg", "systemfonts", "ggpointdensity", "ggblend", 
          "ggdensity", "ggforce", "ggtext", "ggiraph", "remotes")

install.packages(setdiff(pkgs, rownames(installed.packages())))

remotes::install_github("AllanCameron/geomtextpath")

## -----------------------------------------------------------------------------
#load the data london bike data
bikes <- read.csv("london-bike-sharing-processed.csv")


## -----------------------------------------------------------------------------
library(dplyr)
bikes_day <- filter(bikes, day_night == "day")

bikes_monthly <-
  bikes |> 
  filter(year == "2016") |> 
  mutate(month = lubridate::month(date, label = TRUE)) |>
  summarize(
    count = sum(count), 
    across(c(temp, humidity, wind_speed), mean),
    .by = c(month, day_night)
  )
## ----------------------------------------------------------------------------
#load and import the desired font type

#install.packages("extrafont")
library(extrafont)
font_import(paths = "C:/Users/user/AppData/Local/Microsoft/Windows/Fonts")
y
## -----------------------------------------------------------------------------
library(ggplot2)
library(ggthemes)
loadfonts(device = "win") # load font font after importing them
# To set a theme for all plots in the session
theme_set(theme_minimal(base_family = "Asap SemiCondensed Black", base_size = 20))

theme_update(
  plot.title.position = "plot",
  plot.title = element_text(size = 24),
  panel.grid.minor = element_blank()
) # Update theme for all plots in the session

bikes$season <- forcats::fct_inorder(bikes$season) # Reorder season into the desired order
bikes_day$season <- forcats::fct_inorder(bikes_day$season)

##-------------------------------------------------------------------------
ggplot(bikes_day, aes(season, humidity)) + geom_boxplot()

##-----------------------------------------------------------------------
ggplot(bikes_day, aes(season, humidity)) + geom_violin()

## -----------------------------------------------------------------------------
ggplot(bikes_day, aes(x = season, y = humidity)) +
  geom_violin() +
  geom_boxplot(width = .1) # width of boxplot

## ggdist-------------------------------------------------------------

## -----------------------------------------------------------------------------
ggplot(bikes_day, aes(x = season, y = humidity)) +
  ggdist::stat_eye()

## -----------------------------------------------------------------------------
ggplot(bikes_day, aes(x = humidity, y = season)) +
  ggdist::stat_halfeye()

## -----------------------------------------------------------------------------
ggplot(bikes_day, aes(x = humidity, y = season)) +
  ggdist::stat_halfeye(.width = .5) ## default: c(.66, .95)

## -----------------------------------------------------------------------------
ggplot(bikes_day, aes(x = humidity, y = season)) +
  ggdist::stat_halfeye(.width = c(0, 1), adjust = .5, shape = 23, point_size = 5)

## -----------------------------------------------------------------------------
ggplot(bikes, aes(x = humidity, y = season, fill = day_night)) +
  ggdist::stat_halfeye(.width = 0, adjust = .5, slab_alpha = .5, shape = 21) +
  scale_fill_manual(values = c("#EFAC00", "#9C55E3"), name = NULL)

## --------------------------------------------

## -----------------------------------------------------------------------------
ggplot(bikes_day, aes(x = season, y = humidity)) +
  ggdist::stat_interval()
?ggdist::stat_interval()
## -----------------------------------------------------------------------------
ggplot(bikes_day, aes(x = season, y = humidity)) +
  ggdist::stat_interval(.width = 1:4*.25, linewidth = 10) +
  scale_color_viridis_d(option = "mako", direction = -1, end = .9)
?scale_color_viridis_d()

