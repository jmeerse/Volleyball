install.packages("rjson")
library(rjson)
install.packages("jsonlite")

one_game_points <- fromJSON("https://data.ncaa.com/casablanca/game/6032819/gameInfo.json")
View(one_game_points[["linescores"]])

boxscore <- fromJSON("https://data.ncaa.com/casablanca/game/6032819/boxscore.json")

one_game_points
one_game_points$linescores

pbp <- fromJSON("https://data.ncaa.com/casablanca/game/6032819/pbp.json")

pbp <- as.data.frame(pbp)


