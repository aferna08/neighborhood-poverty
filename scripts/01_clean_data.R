pacman::p_load(tidyverse, ipumsr, here, janitor, sf)

#### Load CBSAs ####
# Load CBSA data and shapefiles from last wave (2022) to filter tracts in top 100

# data and merge with shapefile
top_101_cbsa <- read_nhgis(here("data", "cbsa_data.zip")) %>% 
  clean_names() %>% 
  mutate(pop = aqnfe001) %>% 
  slice_max(pop, n = 101) # keep 101 to deal with Cape Coral issue

# shapefile
cbsa_shp_2022 <- read_ipums_sf(here("data", "cbsa_shp.zip")) %>% 
  clean_names() %>% 
  inner_join(top_101_cbsa, by = "gisjoin") %>% 
  select(gisjoin, cbsafp, name, pop, geometry)

#### Load Tracts ####
# 1. Load tract shapefiles and convert to centroids
# 2. Filter tracts with centroids in current top CBSAs
# 3. Filter tracts in 1970 tracted area
# 4. Join with NHGIS tract data on poverty and population

# 1970 tracted area
tract_shp_1970 <- read_ipums_sf(here("data", "tract_shp.zip"),
                                file_select = contains("tract_1970")) %>% 
  clean_names()

# Load all tracts
all_tracts <- read_ipums_sf(here("data", "tract_shp.zip"),
                               bind_multiple = TRUE) %>% 
  clean_names() %>% 
  mutate(
    year = as.integer(sub(".*_(\\d{4}).*", "\\1", layer)), # create year variable from layer name variable
    year = case_when(
      year %in% c(1970, 1980, 1990, 2000) ~ as.character(year),
      year == 2012 ~ "2008-2012",
      year == 2022 ~ "2018-2022"
    )
    ) %>%
  select(gisjoin, year, geometry) %>% 
  st_centroid()

# identify tracts in top CBSAs
top_cbsa_tracts <- all_tracts %>% 
  st_filter(cbsa_shp_2022) %>% 
  mutate(top_cbsa = TRUE) %>% 
  st_drop_geometry()

# identify tracts in 1970 tracted area
in_1970_tracts <- all_tracts %>% 
  st_filter(tract_shp_1970) %>% 
  mutate(in_1970 = TRUE) %>% 
  st_drop_geometry()

combined_tracts <- all_tracts %>% 
  st_drop_geometry() %>% 
  full_join(top_cbsa_tracts, by = c("gisjoin", "year")) %>% # note: join warnings are just tracts with population that will be dropped later
  full_join(in_1970_tracts, by = c("gisjoin", "year")) %>% 
  mutate(
    in_1970 = case_when(
      in_1970 == TRUE ~ TRUE,
      year == 1970 ~ TRUE,
      TRUE ~ FALSE
    ),
    top_cbsa = case_when(
      top_cbsa == TRUE ~ TRUE,
      TRUE ~ FALSE
    )
  )

# Load tract population data
tract_data <- read_nhgis(here("data", "tract_data.zip")) %>% 
  clean_names() %>% 
  mutate(npov = cl6aa,
         dpov = ax6aa,
         poverty_rate = npov / dpov,
         fb = at5ab,
         nb = at5aa) %>% 
  select(gisjoin, year, npov:nb) %>% 
  inner_join(combined_tracts, by = c("gisjoin", "year"))

write_csv(tract_data, here("data", "combined_tract_clean.csv"))
