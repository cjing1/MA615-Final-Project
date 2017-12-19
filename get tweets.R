# Get tweets

library(devtools)
library(twitteR)
library(xlsx)

api_key <- 	"uBCceZC4F5Bt9MR3dkhoKNlva"
api_secret <- "JZncDTYepnTOpP3OrQgiBG7F9GgkPsSHH62HwlRjjYXhi7DsjB"
access_token <- "824271420389724161-WuRwQ8dgQ01AZylw633tjNKiGpGt6QO"
access_token_secret <- "UkRN0jgb0f5a1jXHf6PC7iV9SfMy4ru7u8JbcnZD3Wzu0"
setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)

setwd('/Users/JingC/Desktop/MA 615/Final project/')

#############################
tweets_nintendo <- searchTwitter("#nintendo", n = 50000, lang="en",since = '2017-10-01')
tweets_nintendo.df <- twListToDF(tweets_nintendo)
write.csv(tweets_nintendo.df, "tweets_nintendo.csv")

tweets_nintendoswitch <- searchTwitter("#nintendoswitch", n = 30000, lang="en",since = '2017-10-01')
tweets_nintendoswitch.df <- twListToDF(tweets_nintendoswitch)
write.csv(tweets_nintendoswitch.df, "tweets_nintendoswitch.csv")

tweets_SuperMarioOdyssey <- searchTwitter("#SuperMarioOdyssey", n = 15000, lang="en",since = '2017-10-01')
tweets_SuperMarioOdyssey.df <- twListToDF(tweets_SuperMarioOdyssey)
write.csv(tweets_SuperMarioOdyssey.df, "tweets_SuperMarioOdyssey.csv")


tweets_BreathoftheWild <- searchTwitter("#BreathoftheWild", n = 15000, lang="en",since = '2017-10-01')
tweets_BreathoftheWild.df <- twListToDF(tweets_BreathoftheWild)
write.csv(tweets_BreathoftheWild.df, "tweets_BreathoftheWild.csv")


tweets_splatoon <- searchTwitter("#splatoon", n = 15000, lang="en",since = '2017-10-01')
tweets_splatoon.df <- twListToDF(tweets_splatoon)
write.csv(tweets_splatoon.df, "tweets_splatoon.csv")



N <- read.csv('tweets_nintendo.csv', stringsAsFactors=FALSE)
NS <- read.csv('tweets_nintendoswitch.csv', stringsAsFactors=FALSE)
SMO <- read.csv('tweets_SuperMarioOdyssey.csv', stringsAsFactors=FALSE)
BW <- read.csv('tweets_BreathoftheWild.csv', stringsAsFactors=FALSE)
S <- read.csv('tweets_splatoon.csv', stringsAsFactors=FALSE)
Z <- read.csv('tweets_zelda.csv', stringsAsFactors=FALSE)

N$tweets<-'nintendo'
NS$tweets<-'nintendoswitch'
SMO$tweets<-'SuperMarioOdyssey'
BW$tweets<-'BreathoftheWild'
S$tweets<-'splatoon'
Z$tweets <- 'zelda'

NintendoData <- rbind(N, NS, SMO, S,BW,Z)

NintendoData$tweets <- as.factor(NintendoData$tweets)
NintendoData$created <- as.POSIXct(NintendoData$created)

write.xlsx(NintendoData, "NintendoData.xlsx",sheetName = "NintendoData", row.names = FALSE)


