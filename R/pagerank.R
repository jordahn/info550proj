library(here)
library(tidyverse)
library(igraph)
library(visNetwork)
library(tidygraph)

here::i_am('R/tradenetwork.R')

africa <- read.csv(here::here('data','africatradedata.csv'))
africa <- africa[, -1]

  
# create node list

source1 <- africa %>% 
            select(source, habitat.suitability) %>% 
            distinct(source, habitat.suitability) %>% 
            rename(label = source)

source2 <- africa %>% 
            distinct(target) %>% 
            rename(label = target)

nodes <- full_join(source1,source2,by = "label") 

# assign id numbers to countries

nodes <- nodes %>% rowid_to_column("id")

# create new edge list 

netmod <- africa %>%
  group_by(source, target) %>%
  summarise(weight, days.between) %>%
  ungroup()

edges <- netmod %>% 
  left_join(nodes, by = c("source" = "label")) %>%
  rename(from = id)


edges <- edges %>%
  left_join(nodes,by = c("target" = "label")) %>%
  rename(to = id)

edges <- select(edges, from, to, weight, days.between)


# graphs

africa_igraph <- graph_from_data_frame(d = edges, vertices = nodes, directed = TRUE)


