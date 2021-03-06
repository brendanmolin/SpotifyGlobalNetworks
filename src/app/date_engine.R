# Takes an edge id and returns a sample song link from a track shared by the two countries at end of the edge
sample_track <- function(edge_id, network, track_colocation, track_data) {
  countries <- ends(network, edge_id)
  track_pool <- track_colocation[(track_colocation$country.x == countries[1] & track_colocation$country.y == countries[2]) |
                                         (track_colocation$country.x == countries[2] & track_colocation$country.y == countries[1]), "track_uri"]
  track <- track_data[track_data$track_uri %in% track_pool$track_uri,c("track_name", "artist_name", "album_name", 'track_preview_url'),]
  track <- track[sample(1:nrow(track), 1, replace = TRUE),]
  colnames(track) <- c("Track", "Artist", "Album", "Preview")
  
  return(track)
}