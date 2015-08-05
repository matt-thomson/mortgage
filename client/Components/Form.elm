module Components.Form where

import Html exposing (Html, Attribute)
import Html.Attributes
import Html.Events
import Helper exposing (..)
import Signal exposing (Address)
import List

import Components.Input as Input

type alias State =
  { fields: List Input.State
  }

init: List Input.State -> State
init fields =
  { fields = fields
  }

type Action =
  FieldAction Int Input.Action

update: Action -> State -> State
update action state =
  case action of
    FieldAction n fieldAction ->
      { state | fields <- updateN n (Input.update fieldAction) state.fields }

view: Address Action -> State -> Html
view address state =
  let
    viewN index field =
      let fieldAddress =
        Signal.forwardTo address (FieldAction index)
      in
        Input.view fieldAddress field
  in
    Html.form
      [ Html.Attributes.class "form-horizontal" ]
      ( List.indexedMap viewN state.fields )
