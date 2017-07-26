# Weather data from wunderground: can only return 398 (daily) records at a time,
# so have to split into batches
weather0 <- read.delim("../weather141017_151118.txt", sep = ",",
                      stringsAsFactors = FALSE) %>%
    rbind(read.delim("../weather151119_161220.txt", sep = ",",
                     stringsAsFactors = FALSE)) %>%
    rbind(read.delim("../weather161221_161227.txt", sep = ",",
                     stringsAsFactors = FALSE))

# Select only columns which might affect travel or behaviour
weather <- select(weather0, Date = GMT, MeanTemperatureC = Mean.TemperatureC,
                  MeanHumidity = Mean.Humidity,
                  MeanWindSpeedKmh = Mean.Wind.SpeedKm.h,
                  Precipitationmm, Events) %>%
    # Convert date to date object. Create logical vectors to indicate presence
    # of adverse weather
    mutate(Date = ymd(Date), Rain = grepl("Rain", Events),
           Fog = grepl("Fog", Events), Snow = grepl("Snow", Events)) %>%
    select(-Events)


save(weather, file = "data/weather.rda")
