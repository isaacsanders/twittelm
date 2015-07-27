module Update (updateState) where

-- Core Imports
import Graphics.Input.Field exposing (noContent)
import Debug exposing (watch)

-- Imports
import State exposing (State)
import Input exposing (Input(..))

updateState : Input -> State -> State
updateState input state =
    let
        state_ = Debug.watch "Last State" state
    in
        case Debug.watch "Input" input of
            Layout _ -> state_
            NewTweet tweet ->
                { state_ | tweets <- tweet::state_.tweets
                , tweetContent <- noContent
                }
            ChangeUsername newUsernameContent ->
                { state_ | usernameContent <- newUsernameContent }
            WriteTweet newTweetContent ->
                { state_ | tweetContent <- newTweetContent }
