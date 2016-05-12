module Mortgage exposing (..)

import Api
import Html exposing (Html, Attribute)
import Html.App as Html
import Html.Attributes
import Html.Events
import String
import Task


type alias Model =
    { amount : String
    , numYears : String
    , apr : String
    , response : Result String Api.Response
    }


type Msg
    = UpdateAmount String
    | UpdateNumYears String
    | UpdateApr String
    | Submit
    | Response Api.Response
    | RequestError String


init : ( Model, Cmd Msg )
init =
    let
        model =
            { amount = ""
            , numYears = ""
            , apr = ""
            , response = Err ""
            }
    in
        ( model, Cmd.none )


request : Model -> Result () Api.Request
request model =
    let
        amount =
            String.toInt model.amount

        numYears =
            String.toInt model.numYears

        apr =
            String.toFloat model.apr
    in
        case ( amount, numYears, apr ) of
            ( Ok amount, Ok numYears, Ok apr ) ->
                Ok (Api.Request amount numYears apr)

            _ ->
                Err ()


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    let
        fetchStats =
            case request model of
                Ok r ->
                    Task.perform RequestError Response (Api.getStats r)

                Err () ->
                    Cmd.none
    in
        case action of
            UpdateAmount amount ->
                ( { model | amount = amount }, Cmd.none )

            UpdateNumYears numYears ->
                ( { model | numYears = numYears }, Cmd.none )

            UpdateApr apr ->
                ( { model | apr = apr }, Cmd.none )

            Submit ->
                ( model, fetchStats )

            Response response ->
                ( { model | response = Ok response }, Cmd.none )

            RequestError error ->
                ( { model | response = Err error }, Cmd.none )


view : Model -> Html Msg
view model =
    let
        inputLabel id label =
            Html.label
                [ Html.Attributes.for id
                , Html.Attributes.class "col-sm-4 control-label"
                ]
                [ Html.text label ]

        inputField id action value =
            Html.input
                [ Html.Attributes.id id
                , Html.Attributes.class "form-control"
                , Html.Attributes.type' "number"
                , Html.Attributes.required True
                , Html.Attributes.value value
                , Html.Events.onInput action
                ]
                []

        input id label action value =
            Html.div [ Html.Attributes.class "form-group" ]
                [ inputLabel id label
                , Html.div [ Html.Attributes.class "col-sm-8" ]
                    [ inputField id action value ]
                ]

        formView =
            Html.form [ Html.Attributes.class "form-horizontal" ]
                [ input "amount" "Amount" UpdateAmount model.amount
                , input "num_years" "Number of years" UpdateNumYears model.numYears
                , input "apr" "APR (%)" UpdateApr model.apr
                ]

        button =
            Html.button
                [ Html.Attributes.type' "submit"
                , Html.Attributes.class "btn btn-primary"
                , Html.Events.onClick Submit
                ]
                [ Html.text "Submit" ]

        submitView =
            Html.div [ Html.Attributes.class "form-group" ]
                [ Html.div [ Html.Attributes.class "col-sm-offset-4 col-sm-8" ]
                    [ button ]
                ]

        responseText =
            case model.response of
                Ok response ->
                    let
                        round x =
                            (x * 100 |> floor |> toFloat) / 100.0

                        monthlyRepayment =
                            round response.stats.monthly_repayment
                    in
                        (String.append "Monthly repayment: £" (toString monthlyRepayment))

                Err err ->
                    err

        responseView =
            Html.div [ Html.Attributes.class "row" ]
                [ Html.div [ Html.Attributes.class "col-sm-offset-4 col-sm-8" ]
                    [ Html.strong [] [ Html.text responseText ] ]
                ]
    in
        Html.div [ Html.Attributes.class "container" ]
            [ Html.h1 [] [ Html.text "Mortgage Calculator" ]
            , formView
            , submitView
            , responseView
            ]


main : Program Never
main =
    Html.program { init = init, update = update, view = view, subscriptions = \_ -> Sub.none }
