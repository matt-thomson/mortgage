module Components.Form where

import Effects exposing (Effects)
import Html exposing (Html, Attribute)
import Html.Attributes
import Signal exposing (Address)
import List

import Components.Input as Input
import Components.Submit as Submit

type alias Model =
  { inputs: List Input.Model
  , submit: Submit.Model
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

    (submit, submitFx) =
      Submit.init

    allInputsFx =
      inputsFx
      |> List.indexedMap matchFx
      |> Effects.batch

    fx =
      Effects.batch
        [ allInputsFx
        , Effects.map SubmitAction submitFx
        ]

  in
    (Model inputs submit, fx)

type Action =
  FieldAction Int Input.Action
  | SubmitAction Submit.Action

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

    SubmitAction submitAction ->
      let
        (newSubmit, fx) =
          Submit.update submitAction model.submit
      in
        ({ model | submit = newSubmit}, Effects.map SubmitAction fx)

view: Address Action -> Model -> Html
view address model =
  let
    viewN index field =
      let fieldAddress =
        Signal.forwardTo address (FieldAction index)
      in
        Input.view fieldAddress field

    inputs =
      List.indexedMap viewN model.inputs

    submit =
      let submitAddress =
        Signal.forwardTo address SubmitAction
      in
        Submit.view submitAddress model.submit
  in
    Html.form
      [ Html.Attributes.class "form-horizontal" ]
      ( inputs ++ [submit] )
