module Api where

import Http
import Json.Decode exposing ((:=))
import Json.Encode
import Task exposing (Task)

type alias Request
  = { amount: Int
    , num_years: Int
    , apr: Float
    }

type alias Response
  = { stats: Stats }

type alias Stats
  = { monthly_repayment: Float }

getStats : Request -> Task Http.Error Response
getStats request =
  let
    decodeStats =
      Json.Decode.object1 Stats ("monthly_repayment" := Json.Decode.float)
    decodeResponse =
      Json.Decode.object1 Response ("stats" := decodeStats)

    encodedRequest =
      Json.Encode.object
        [ ("amount", Json.Encode.int request.amount)
        , ("num_years", Json.Encode.int request.num_years)
        , ("apr", Json.Encode.float request.apr)
        ]

    body =
      Http.string (Json.Encode.encode 0 encodedRequest)
  in
    Http.post decodeResponse "/mortgages" body
