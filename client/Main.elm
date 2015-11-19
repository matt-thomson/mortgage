module Main where

import Effects exposing (Effects)
import Html exposing (Html)
import Html.Attributes
import Signal exposing (Address)
import StartApp exposing(App)

import Components.Form as Form
import Components.Input as Input

type alias State =
  { form: Form.State
  }


type alias Update = (State, Effects Action)

init: Update
init =
  ({ form =
      Form.init
        [ Input.init "amount" "Amount"
        , Input.init "num_years" "Number of years"
        , Input.init "apr" "APR (%)"
        ]
  }, Effects.none)

type Action
  = FormAction Form.Action
  | NoOp

update: Action -> State -> Update
update action state =
  case action of
    FormAction formAction ->
      ({ state | form = Form.update formAction state.form }, Effects.none)
    NoOp ->
      (state, Effects.none)


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


app : App State
app = StartApp.start { init = init, view = view, update = update, inputs = [] }


main : Signal Html
main = app.html
