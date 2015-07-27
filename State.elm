module State (State, newState) where

-- Core Imports
import Graphics.Input.Field exposing (Content, noContent)

-- Imports
import Types exposing (Tweet)

type alias State = { tweets: List Tweet
                   , usernameContent: Content
                   , tweetContent: Content
                   }

newState : State
newState = { tweets = []
           , usernameContent = noContent
           , tweetContent = noContent
           }
