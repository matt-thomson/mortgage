module Helper where

import Html exposing (Attribute)
import Html.Events
import Signal exposing (Address)

onInput : Address a -> (String -> a) -> Attribute
onInput address constructor =
  Html.Events.on "input" Html.Events.targetValue (constructor >> Signal.message address)
