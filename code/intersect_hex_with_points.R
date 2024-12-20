##### Header #####
## author: Robert P. McGuinn, robert.mcguinn@noaa.gov, rpm@alumni.duke.edu
## startdate:20241220
## purpose:

##### linkage #####
filename <- 'intersect_hex_with_points' ## manual: for this code file name, match to redmine
github_path <- 'https://github.com/RobertMcGuinn/ecostack/blob/master/code/'
github_link <- paste(github_path, filename, '.R', sep = '')
browseURL(github_link)
# redmine_path <- 'https://vlab.noaa.gov/redmine/issues/'
# issuenumber <- filename
# redmine_link <- paste(redmine_path, issuenumber, sep = '')
# browseURL(redmine_link)

##### packages #####
library(tidyverse)
library(sf)
library(h3jsr)
library(terra)
library(ggplot2)
library(rnaturalearth)
library(rnaturalearthdata)
library(marmap)

##### load ndb #####
source("c:/rworking/deepseatools/code/mod_load_current_ndb.R")

##### create sf object from NDB #####
filtgeo  <- st_as_sf(filt, coords = c("Longitude", "Latitude"), crs = 4326)

##### get hexagon labels for chosen resolutions (assigned to each point record) #####
filt_h3 <- point_to_cell(filtgeo,
                         res = seq(7,8),
                         simple = FALSE)
##### check #####
# filt_h3 %>%
#   group_by(AphiaID, h3_resolution_5) %>%
#   summarize(n=n()) %>%
#   arrange(desc(n)) %>%
#   View

##### looking at depth distribution of coral and sponge occurrences summarized within hexes #####
filt_h3 %>% group_by(h3_resolution_6) %>%
  summarize(mindepth_res5 = min(MinimumDepthInMeters),
            maxdepth_res5 = max(MaximumDepthInMeters),
            n=n()) %>%
  View()

##### look at points that match a set of conditions and then extract the hexagon IDs in a list #####
locality <- 'Davidson Seamount'

cats <- filt_h3 %>%
  filter(grepl(locality, Locality)) %>%
  select(c('h3_resolution_7','h3_resolution_8'))

hexlist <- unlist(cats, use.names = FALSE)
hexlist <- unique(hexlist)

## make a selection of points that match the same condition ##
points <- filtgeo %>%
  filter(grepl(locality, Locality))

##### check ######
# class(hexlist)
# length(hexlist)
# length(unique(hexlist))

##### create polygons from hexes ######
hexes <- cell_to_polygon(unique(hexlist), simple = FALSE)

##### check #####
# class(hexes)
# st_crs(hexes)

##### export shapefiles for examination #####
# library(sf)
# st_write(hexes, "c:/rworking/deepseatools/indata/hexes.shp", append = F)
# st_write(points, "c:/rworking/deepseatools/indata/points.shp", append = F)

##### load bathymetry #####
# Get bounding box
hex_bbox <- st_bbox(hexes)

# Create an sf object for the bounding box
bbox_sf <- st_as_sfc(hex_bbox)

# Buffer by 1 km
buffered_bbox <- st_buffer(bbox_sf, dist = 10000)  # Buffer by
hex_bbox_buf <- st_bbox(buffered_bbox)

# Download bathymetry data for the region of interest
bathy <- getNOAA.bathy(
  lon1 = hex_bbox_buf$xmin,
  lon2 = hex_bbox_buf$xmax,
  lat1 = hex_bbox_buf$ymin,
  lat2 = hex_bbox_buf$ymax,
  resolution = 0.01
)

# Convert bathymetry to a data frame for ggplot
bathy_df <- marmap::fortify.bathy(bathy)

##### plot the map #####
points %>%
  ggplot() +
  # Add bathymetry layer
  geom_tile(data = bathy_df, aes(x = x, y = y, fill = z), alpha = 0.8) +
  scale_fill_viridis_c(name = "Depth (m)", option = "C", direction = -1) +  # Viridis for bathymetry
  # Add hexes
  geom_sf(data = hexes, fill = NA, colour = 'black', alpha = 0.5) +
  # Add points
  geom_sf(fill = NA, colour = 'red') +
  # Titles and theme
  ggtitle('Hex Relationships', subtitle = 'Neighboring Resolutions with Bathymetry') +
  theme_minimal() +
  coord_sf(
    xlim = c(hex_bbox$xmin, hex_bbox$xmax),
    ylim = c(hex_bbox$ymin, hex_bbox$ymax)
  )

##### Convert the CRS to a suitable projection for your area of interest #####
hexes_transform <- st_transform(hexes, crs = 32119)  # Example CRS (UTM Zone 33N)

##### Calculate the area in square kilometers #####
area_km2 <- st_area(hexes_transform) / 1e6  # Convert square meters to square kilometers

##### transform from 'units' object to character string #####
area_km2_char <- as.character(area_km2)

##### add area back to original hexes file #####
hexes_area <- hexes %>%
  mutate(area_km2 = area_km2_char)

##### check #####
hexes_area
hexes_area$area_km2
class(hexes_area$area_km2)




















