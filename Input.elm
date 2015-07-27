module Input ( Input(..)
             , inputs
             , usernameMailbox
             , tweetContentMailbox
             , tweetsMailbox
             ) where

-- Vendor Imports
import Graphics.Input.Field exposing (Content, noContent)
import Signal exposing ((<~), mergeMany)
import Regex exposing (regex, contains)
import String
import Window exposing (dimensions)
import Debug

-- Imports
import Types exposing (Tweet(ContentTweet, Retweet))

usernameMailbox : Signal.Mailbox Content
usernameMailbox = Signal.mailbox noContent

tweetContentMailbox : Signal.Mailbox Content
tweetContentMailbox = Signal.mailbox noContent

tweetsMailbox : Signal.Mailbox Tweet
tweetsMailbox = Signal.mailbox (ContentTweet {username="", content=""})

type Input = Layout (Int, Int)
           | NewTweet Tweet
           -- | Favorite Tweet
           | ChangeUsername Content
           | WriteTweet Content

validateUsernameContent : Content -> Bool
validateUsernameContent = not << (contains << regex) "[^\\w_]" << .string

validateTweet : Tweet -> Bool
validateTweet tweet =
    case Debug.watch "Tweet" tweet of
        ContentTweet {content} ->
            0 < String.length content
        Retweet username retweetedTweet ->
            case retweetedTweet of
                ContentTweet nestedRT -> username /= nestedRT.username
                Retweet nestedUN nestedRT ->
                    nestedUN /= username && validateTweet (Retweet username nestedRT)

inputs : Signal Input
inputs =
    mergeMany [ Layout <~ Window.dimensions
              , NewTweet <~ Signal.filter validateTweet (ContentTweet {username="", content=""}) tweetsMailbox.signal
              , ChangeUsername <~ Signal.filter validateUsernameContent noContent usernameMailbox.signal
              , WriteTweet <~ tweetContentMailbox.signal
              ]
