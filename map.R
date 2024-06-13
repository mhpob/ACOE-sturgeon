library(sf); library(ggplot2)

dredge <- read_sf('data/nanticoke_dredging.gpkg')

nan <- st_read('s:/nansturg-analysis/manuscript/data/spatial/NHD_H_0208_HU4_GDB.gdb',
               layer = 'wbdhu10',
               query = "SELECT OGR_GEOM_WKT AS wkt
                        FROM wbdhu10
                        WHERE States LIKE 'D%'")

nan <- st_read('s:/nansturg-analysis/manuscript/data/spatial/NHD_H_0208_HU4_GDB.gdb',
                         layer = 'nhdarea',
                         wkt_filter = nan$wkt)

library(geoarrow)
states <- arrow::open_dataset('../chesapeake-backbone/data and imports/matl_states.parquet') |> 
  st_as_sf() |> 
  dplyr::filter(STATE_ABBR %in% c('MD', 'DE'))


nan_plot <-
  ggplot() +
  geom_sf(data = states, aes(fill = STATE_ABBR)) +
  scale_fill_manual(values = c('lightblue', 'yellow')) +
  geom_sf(data = nan, fill = NA) +
  geom_sf(data = dredge, aes(color = state), lwd = 1) +
  scale_color_manual(values = c('blue', 'red')) +
  coord_sf(xlim = c(-75.96, -75.54), ylim = c(38.2467, 38.7), expand = F) +
  annotate('point', x = c(-75.59, -75.77), y = c(38.65, 38.692),
           size = 6, pch=8) +
  labs(x = NULL, y = NULL) +
  theme_bw() +
  theme(legend.position = 'none')




# Make a polygon using a bounding box
crop_box <- st_bbox(c(ymin = 36.76498, xmin = -77.08675,
                      ymax = 39.72379, xmax = -74.84402),
                    crs = st_crs(4326)) %>%
  # turn into a simple features collection
  st_as_sfc()


# Import map, selecting only features that touch the crop box.
#   Do this by turning the box into well-known text

inset_map <- st_read('s:/nansturg-analysis/manuscript/data/spatial/natural earth/ne_10m_coastline.shp',
                     # turn box into well-known text
                     wkt_filter = st_as_text(crop_box))

# plot(inset_map$geometry)


# Use the coastline (a linestring) to cut up the bbox polygon
inset_map <- crop_box %>%
  lwgeom::st_split(inset_map) %>%
  # Separate into individual features
  st_collection_extract() %>%
  # just so happens that features 6 (upper Potomac) and 2 (everything else) are
  #   redundant to what we need
  .[-c(2, 6),]

inset <- ggplot() +
  geom_sf(data = inset_map, fill = 'gray') +
  annotate('rect', xmin = -75.96, xmax = -75.54, ymin = 38.2467, ymax = 38.7,
           fill = NA, color = 'black', linetype = 'dotted') +
  coord_sf(expand = F) +
  theme_void() +
  theme(plot.margin = margin(0, 0, 0, 0),
        plot.background = element_rect(color = 'white'))


library(patchwork)

nan_plot + inset_element(inset, 0.6, 0, 0.99, 0.5)
