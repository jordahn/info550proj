##############
#
# create network with top 3 
# connected countries
#
##########
library(visNetwork)
# library(networkD3)
library(RColorBrewer)
library(igraph)
library(tidygraph)
library(tidyverse)
library(ggraph)
library(htmlwidgets)
library(here)


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


# visNetwork

# assign node value based on how many edges

degree_value <- degree(africa_igraph, mode = "in")
nodes$value <- degree_value[match(nodes$id, names(degree_value))]


# change color of countries with confirmed mosquito
mosquito <- c("Djibouti", "Sudan")
edges <- mutate(edges, width = weight*40)
nodes <- mutate(nodes, group = ifelse(label %in% mosquito, "Invasive mosquito present","No invasive mosquito"),
                       color = ifelse(is.na(habitat.suitability),"#2A9D8F", ifelse(habitat.suitability == 2, "#E9C46A", "#D00000")))
                


# the graph
expafrica <- visNetwork(nodes,edges, height = 1000, width = "100%", main = "Maritime Trade Connectivity of Coastal African Nations <br> 
                        (Top 3 LSBCI country pairs)") %>%
             
               visIgraphLayout(layout = "layout.lgl") %>% 
               visGroups(groupname = "Invasive mosquito present", shape = "diamond", color = "#D00000") %>% 
               visGroups(groupname = "No invasive mosquito", shape = "dot", color = "#E9C46A" ) %>% 
               visNodes(shadow = list(enabled = TRUE, size = 10), font = list(size = "20")) %>%
               visEdges(smooth = FALSE,arrows = "to", color = list(color = "#A8DADC", highlight = "#9A8C98")) %>%
               visOptions(highlightNearest = list(enabled = TRUE, degree = list(from = 0, to = 1), algorithm = "hierarchical"),
                           selectedBy = list(variable = "group", selected = "Invasive mosquito present",highlight = TRUE),
                          autoResize = FALSE) %>% 
               visLegend(addNodes = list(
                  list(label = "Highly suitable habitat", shape = "dot", color = "#D00000"),
                  list(label = "Moderately suitable habitat", shape = "dot", color = "#E9C46A"),
                  list(label = "Data Unavailable", shape = "dot", color = "#2A9D8F")), 
                 useGroups = FALSE,
                 width = 0.15,
                 zoom = FALSE) %>% 
                 visPhysics(stabilization = TRUE)
             
            
expafrica


visSave(expafrica,file ="Figs/trade_network.html", selfcontained = TRUE, background = "white")




