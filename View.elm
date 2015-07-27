module View (renderState) where

-- Core Imports
import Graphics.Element exposing (Element, show, above, leftAligned, empty, flow, down)
import Graphics.Input exposing (button)
import Graphics.Input.Field exposing (Content, field, defaultStyle)
import Text exposing (bold, italic, append, fromString)
import Debug exposing (watch)
import String

-- Imports
import Input exposing (usernameMailbox, tweetContentMailbox, tweetsMailbox)
import State exposing (State)
import Types exposing (Tweet(ContentTweet, Retweet), Username)

usernameField : Content -> Element
usernameField = field defaultStyle (Signal.message usernameMailbox.address) "Username"

paragraphStyle : Graphics.Input.Field.Style
paragraphStyle =
    let
        padding = defaultStyle.padding
        paragraphPadding = { padding | right <- padding.right * 2
                                     , bottom <- padding.bottom * 4
                                     }
    in
        { defaultStyle | padding <- paragraphPadding }

tweetField : Content -> Element
tweetField = field defaultStyle (Signal.message tweetContentMailbox.address) "Write your tweet here..."

sendTweetButton : Username -> String -> Element
sendTweetButton username content =
    let
        newTweet = ContentTweet { username = username
                                , content = content
                                }
        message = Signal.message tweetsMailbox.address newTweet
    in
        button message "Send"

retweetButton : Username -> Tweet -> Element
retweetButton username tweet =
    let
        message = Signal.message tweetsMailbox.address (Retweet username tweet)
    in
        button message "Retweet"

tweetView : Username -> Tweet -> Element
tweetView currentUsername tweet =
    case tweet of
        ContentTweet {username, content} ->
            let
                visualUsername = bold
                               <| append (fromString "@")
                               <| fromString
                               <| username
                visualContent = fromString content
                rtButton = retweetButton currentUsername tweet
            in
                flow down [leftAligned visualUsername, leftAligned visualContent, rtButton]
        Retweet username retweet ->
            let
                retweetedBy = italic
                            <| append (fromString "Retweeted by ")
                            <| fromString
                            <| username
                originalUsername = Types.originalUsername retweet
            in
                flow down [tweetView originalUsername retweet, leftAligned retweetedBy]

renderState : State -> Element
renderState state =
    let
        tweetContent = state.tweetContent
        usernameContent = Debug.watch "Username" state.usernameContent
        sendButton = sendTweetButton usernameContent.string tweetContent.string
        username = usernameContent.string
    in
        flow down <| usernameField state.usernameContent
                  :: tweetField state.tweetContent
                  :: sendButton
                  :: (List.map (tweetView username) state.tweets)
