module Main (main) where

-- Core Imports
import Signal exposing ((<~), (~), constant, foldp)
import Graphics.Element exposing (show, above)

-- Imports
import Input exposing (inputs)
import View exposing (renderState)
import State exposing (newState)
import Update exposing (updateState)

main = renderState <~ foldp updateState newState inputs
