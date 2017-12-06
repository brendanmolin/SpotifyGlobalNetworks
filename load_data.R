devtools::install_github('charlie86/spotifyr')

library(spotifyr)
library(stringr)
library(jsonlite)
library(tidyverse)
library(countrycode)

### setup here https://developer.spotify.com/my-applications/
# Sys.setenv('SPOTIFY_CLIENT_ID' = '[YOUR_CLIENT_ID]')
# Sys.setenv('SPOTIFY_CLIENT_SECRET' = '[YOUR_SECRET]')

soundsofspotify <- get_user_playlists('thesoundsofspotify')

city_playlists <- soundsofspotify %>% 
    filter(grepl('The Sound of', playlist_name),
           grepl(' [[:upper:]]{2}$', playlist_name))

city_playlist_tracks <- get_playlist_tracks(city_playlists)

load('city_playlist_tracks.RData')
city_playlist_track_audio_features <- get_track_audio_features(city_playlist_tracks)
city_playlist_track_popularity <- get_track_popularity(city_playlist_tracks)

geo_tracks <- city_playlist_tracks %>% 
    left_join(city_playlist_track_popularity, by = 'track_uri') %>%
    left_join(city_playlist_track_audio_features, by = 'track_uri') %>% 
    unique %>% 
    mutate(city_country = gsub('The Sound of ', '', playlist_name),
           city = gsub(' [[:upper:]]{2}$', '', city_country),
           country_abb = str_extract(playlist_name, '[[:upper:]]{2}$')) %>% 
    left_join(select(countrycode_data, iso2c, iso3c, region, continent, country = country.name.en), by = c('country_abb' = 'iso2c'))

save(geo_tracks, file = 'geo_tracks.RData')
write.csv(geo_tracks, 'geo_tracks.csv', row.names = F)

load('geo_tracks.RData')

feature_vars <- c('danceability', 'energy', 'loudness', 'speechiness', 'acousticness', 'instrumentalness', 'liveness', 'valence', 'tempo', 'duration_ms')

country_features <- geo_tracks %>% 
    group_by(country_abb, iso3c, country) %>% 
    summarise_at(feature_vars, funs(mean(., na.rm = T)))

save(country_features, file = 'country_features.RData')
write.csv(country_features, file = 'country_features.csv', row.names = F)

download.file('https://raw.githubusercontent.com/johan/world.geo.json/master/countries.geo.json', destfile = 'countries.geo.json')
countries <- geojsonio::geojson_read("countries.geo.json",
                                     what = "sp")

map(countries$id, function(country_id) {
    map(feature_vars, function(feature) {
        this_feature <- country_features[[feature]][country_features$iso3c == country_id]
        if (length(this_feature) == 0) {
            value <- NA
        } else {
            value <- this_feature
        }
        
        countries[[feature]][countries$id == country_id] <<- value
    })
})

save(countries, file = 'countries.RData')