library(tidyverse)
library(elevatr)
library(rayshader)
library(sf)
library(here)
library(terra)
library(rnaturalearth)
library(remotes)
library(rnaturalearthhires)
library(ggspatial)


base_path <- here("pop maps _3d")

polska <- rnaturalearth::ne_countries(scale = 10, country = "poland", returnclass = "sf") # extract country shape file

polska %>% 
  ggplot() +
  geom_sf()# plot shape file on ggplot

elev <- elevatr::get_elev_raster(polska, z = 7) # get elevation data for Poland
elev_polska <- raster::mask(elev, polska) # mask the elevation data with Poland shape file
mat_poland <- raster_to_matrix(elev_polska) # convert raster to matrix

# custom_texture <- create_texture(
#   "springgreen","darkgreen", "turquoise","steelblue3", "white")
custom_texture <- create_texture(
  "#3498eb","#0a2c47", "#2aaebf","#59a5e3", "white")# create custom texture


custom_texture %>%
  plot_map() # plot the texture

#mat_poland %>% 
  # sphere_shade(texture = "imhof2") %>% 
 # sphere_shade(texture = custom_texture) %>% 
  #add_water(detect_water(mat_poland, min_area = 400), color = "imhof3") %>%
  #plot_3d(mat_poland, windowsize = c(1200, 1200), zoom = 0.6, phi = 25.75, theta = 70,
   #       zscale = 30, background = "white",
    #      solid = TRUE, solidcolor = "grey76") #plot 3d map

#render_camera() # render camera
#render_snapshot(here(base_path, "Poland-3d.png"),
 #               width = 2000, height = 2000, software_render = TRUE) 

#rgl::rgl.clear()
# rgl::rgl.close()


elev_pol_df <- as.data.frame(elev_polska, xy = TRUE, na.rm = TRUE)

elev_pol_df$elev <- elev_pol_df$file705c4a383dd0

sst.color_1 = c("white", "#e9a3c9", "#fde0ef", "#e6f5d0", "#a1d76a", "#4d9221","#3498eb","#0a2c47", "#2aaebf","#59a5e3", "#c51b7d")

elev_map_pol <- elev_pol_df %>% ggplot(aes(x = x, y = y)) +
  geom_tile(aes(fill = elev))+
  scale_fill_gradientn(colours = sst.color_1, breaks = seq(-750,2200,400), guide = guide_colorbar(title.position = "right", title = expression(Elevation~(m)), title.theme = element_text(angle = 90))) + geom_sf(data = polska, inherit.aes = FALSE, fill = NA) + labs(
    title = "Elevation map of Poland"
  ) +
  xlab("Longitude") +
  ylab("Latitude") +
  theme_bw() +
  theme() + annotation_scale(location = "bl", width_hint = 0.2, pad_x = unit(3, "cm"), pad_y = unit(2, "cm")) +  annotation_north_arrow(
    location = "tl",
    pad_x = unit(0.5, "in"),
    pad_y = unit(0.1, "in"),
    style = north_arrow_fancy_orienteering
  ) #%>% add_water(detect_water(elev_pol_df, min_area = 400), color = "imhof3")## add arrows and scale using ggpsatial package

?annotation_scale()

elev_map_pol

ggsave(
  "Poland elevation map.tif",
  elev_map_pol,
  width = 7,
  height =7,
  units = "in",
  bg = "white"
)

#add_water(detect_water(mat_poland, min_area = 400), color = "imhof3")

