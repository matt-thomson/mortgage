module Main where

import Html exposing (Html)
import Html.Attributes
import Signal exposing (Address)
import StartApp

import Components.Form as Form
import Components.Input as Input

type alias State =
  { form: Form.State
  }

init: State
init =
  { form =
      Form.init
        [ Input.init "amount" "Amount"
        , Input.init "num_years" "Number of years"
        , Input.init "apr" "APR (%)"
        ]
  }

type Action
  = FormAction Form.Action
  | NoOp

update: Action -> State -> State
update action state =
  case action of
    FormAction formAction ->
      { state | form <- Form.update formAction state.form }
    NoOp ->
      state


view: Address Action -> State -> Html
view address state =
  let
    formAddress =
      Signal.forwardTo address FormAction
  in
    Html.div
      [ Html.Attributes.class "container" ]
      [ Html.h1 [] [ Html.text "Mortgage Calculator" ]
      , Form.view formAddress state.form
      ]

main : Signal Html
main = StartApp.start { model = init, view = view, update = update }
