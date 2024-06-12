---
title: "London bike sharing"
output:
  html_document:
    toc: true
    toc_depth: 2
---



```r
# Install packages, upload dataset and import font
pkgs <- c("ggplot2", "readr", "dplyr", "tibble", "tidyr", "lubridate","scales", "ragg", "systemfonts", "ggpointdensity", "ggblend", "ggdensity", "ggforce", "ggtext", "ggiraph", "remotes")

install.packages(setdiff(pkgs, rownames(installed.packages())))

remotes::install_github("AllanCameron/geomtextpath")
```

```
## Skipping install of 'geomtextpath' from a github remote, the SHA1 (ef1f12a9) has not changed since last install.
##   Use `force = TRUE` to force installation
```

```r
foce=TRUE
```


```r
bikes <- read.csv("london-bike-sharing-processed.csv")
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

#load and import the desired font type

#install.packages("extrafont")
library(extrafont)
font_import(paths = "C:/Users/user/AppData/Local/Microsoft/Windows/Fonts")
```

```
## Importing fonts may take a few minutes, depending on the number of fonts and the speed of the system.
## Continue? [y/n]
```

```
## Exiting.
```


```r
#Load font, set theme and reorder season
library(ggplot2)
library(ggthemes)
loadfonts(device = "win") # load font font after importing them
```

```
## Asap already registered with windowsFonts().
```

```
## Asap SemiCondensed Black already registered with windowsFonts().
```

```
## Asap SemiCondensed already registered with windowsFonts().
```

```r
# To set a theme for all plots in the session---------------------------
theme_set(theme_minimal(base_family = "Asap SemiCondensed Black", base_size = 20))

theme_update(
  plot.title.position = "plot",
  plot.title = element_text(size = 24),
  panel.grid.minor = element_blank()
) # Update theme for all plots in the session

bikes$season <- forcats::fct_inorder(bikes$season) # Reorder season into the desired order
bikes_day$season <- forcats::fct_inorder(bikes_day$season)
```


```r
#Boxplot of humidity by season--------------------------------------------------------

ggplot(bikes_day, aes(season, humidity)) + geom_boxplot()
```


<img src="london_bike_sharing_files/figure-html/unnamed-chunk-18-1.png" width="672" />


```r
# Violin plot of humidity by season--------------------------
ggplot(bikes_day, aes(season, humidity)) + geom_violin()
```


<img src="london_bike_sharing_files/figure-html/unnamed-chunk-19-1.png" width="672" />


