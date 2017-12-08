library(visNetwork)

# Takes an edge id and returns a sample song link from a track shared by the two countries at end of the edge
sample_track <- function(edge_id) {
  countries <- ends(g, edge_id)
  track_pool <- track_colocation[(track_colocation$country.x == countries[1] & track_colocation$country.y == countries[2]) |
                                         (track_colocation$country.x == countries[2] & track_colocation$country.y == countries[1]), "track_uri"]
  track <- sample(track_pool, 1, replace = TRUE)
  track_info <- track_data[track_data$track_uri %in% track,c("track_name", "artist_name", "album_name")]
  colnames(track_info) <- c("Track", "Artist", "Album")
  
  return(track_info)
}

#getPage<-function(preview_url) {
#  return((HTML(readLines(preview_url))))
#}