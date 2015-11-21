module Components.Form where

import Effects exposing (Effects)
import Html exposing (Html, Attribute)
import Html.Attributes
import Signal exposing (Address)
import List

import Components.Input as Input

type alias Model =
  { inputs: List Input.Model
  }

init: List (String, String) -> (Model, Effects Action)
init fields =
  let
    (inputs, inputsFx) =
      fields
      |> List.map Input.init
      |> List.unzip

    matchFx id fx =
      Effects.map (FieldAction id) fx

    fx =
      inputsFx
      |> List.indexedMap matchFx
      |> Effects.batch

  in
    (Model inputs, fx)

type Action =
  FieldAction Int Input.Action

update: Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    FieldAction fieldId fieldAction ->
      let
        subUpdate id field =
          if id == fieldId then
            let
              (newField, fx) = Input.update fieldAction field
            in
              (newField, Effects.map (FieldAction id) fx)
          else
            (field, Effects.none)

        (newInputs, fxList) =
          model.inputs
            |> List.indexedMap subUpdate
            |> List.unzip
      in
        ({ model | inputs = newInputs }, Effects.batch fxList)

view: Address Action -> Model -> Html
view address model =
  let
    viewN index field =
      let fieldAddress =
        Signal.forwardTo address (FieldAction index)
      in
        Input.view fieldAddress field

  in
    Html.form
      [ Html.Attributes.class "form-horizontal" ]
      ( List.indexedMap viewN model.inputs )
