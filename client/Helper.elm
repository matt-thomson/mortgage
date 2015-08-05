module Helper where

import Html exposing (Attribute)
import Html.Events
import Signal exposing (Address)
import List

onInput : Address a -> (String -> a) -> Attribute
onInput address constructor =
  Html.Events.on "input" Html.Events.targetValue (constructor >> Signal.message address)

updateN : Int -> (a -> a) -> List a -> List a
updateN n update list =
  List.indexedMap (\index value -> if index == n then update value else value) list
