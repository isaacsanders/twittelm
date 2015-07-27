module Types (Tweet(..), TweetContent, Username, originalUsername) where

type alias Username = String
type alias TweetContent = { username: Username , content: String }
type Tweet = ContentTweet TweetContent
           | Retweet Username Tweet

originalUsername : Tweet -> Username
originalUsername tweet =
    case tweet of
        ContentTweet {username} -> username
        Retweet _ retweet -> originalUsername retweet
