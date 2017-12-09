library(visNetwork)
library(igraph)

# Takes an edge id and returns a sample song link from a track shared by the two countries at end of the edge
sample_track <- function(edge_id) {
  countries <- ends(g, edge_id)
  track_pool <- track_colocation[(track_colocation$country.x == countries[1] & track_colocation$country.y == countries[2]) |
                                         (track_colocation$country.x == countries[2] & track_colocation$country.y == countries[1]), "track_uri"]
  track <- track_data[track_data$track_uri %in% track_pool,c("track_name", "artist_name", "album_name", 'track_preview_url')]
  track <- sample(track_pool, 1, replace = TRUE)
  colnames(track_info) <- c("Track", "Artist", "Album", "Preview")
  
  return(track_info)
}