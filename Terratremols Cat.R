library(rgdal)
library(raster) 
library(rgeos)
library(sf)
library(tidyverse)
library(sp)
library(stringr)
library(gganimate)

sismes <- read_csv("/SISMOCAT_export.csv")

municipios_mapa <- readOGR("/Municipis shapefiles/Municipios_IGN.shp")
municipios_mapa<-st_as_sf(municipios_mapa)
municipios_mapa<-municipios_mapa %>% filter(CODNUT2 == "ES51")

sismes_filtered <- sismes%>%
  filter(Àrea == "Local")
sismes_filtered$datetime <- paste(sismes_filtered$`Data(TU)`, sismes_filtered$`Hora(TU)`, sep= " ")

sismes_filtered$`Lon(°)`<- as.numeric(str_sub(sismes_filtered$`Lon(°)`,1,nchar(sismes_filtered$`Lon(°)`)-2))
sismes_filtered$`Lat(°)` <- as.numeric(str_sub(sismes_filtered$`Lat(°)`,1,nchar(sismes_filtered$`Lat(°)`)-2))
sismes_filtered <- rename(sismes_filtered, Lon = `Lon(°)`, Lat = `Lat(°)`)
sismes_filtered <- sismes_filtered%>%
  mutate(datetime = as.POSIXct(datetime))

animate(
  ggplot(municipios_mapa) + 
  geom_sf(fill = "#FFFFFF")+ 
  geom_point(data = sismes_filtered, mapping = aes(x = `Lon`, y = `Lat`, size = Mag, colour = `Prof.(km)`), show.legend = FALSE, alpha = 0.7)+
  scale_color_viridis_d() +
  theme_bw()+
  transition_time(datetime)+
  shadow_mark(past = T, future=F, alpha=0.3)+
  labs(title = "Dia i hora: {frame_time}"),
  fps = 5)





 
