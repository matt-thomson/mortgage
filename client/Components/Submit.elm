module Components.Submit where

import Effects exposing (Effects)
import Html exposing (Html, Attribute)
import Html.Attributes
import Html.Events
import Signal exposing (Address)

type alias Model = ()

init: (Model, Effects Action)
init =
  ((), Effects.none)

type Action =
  Submit

update: Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    Submit ->
      (model, Effects.none)

view: Address Action -> Model -> Html
view address model =
  let
    button =
      Html.button
        [ Html.Attributes.type' "submit"
        , Html.Attributes.class "btn btn-primary"
        , Html.Events.onClick address Submit
        ]
        [ Html.text "Submit" ]
  in
    Html.div
      [ Html.Attributes.class "form-group" ]
      [ Html.div
        [ Html.Attributes.class "col-sm-offset-4 col-sm-8" ]
        [ button ]
      ]
