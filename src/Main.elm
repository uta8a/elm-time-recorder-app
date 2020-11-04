port module Main exposing (..)
import Browser
import Html exposing (..)
import Task
import Time exposing (Month (..))
import Html.Attributes exposing (class,id)
import Html.Events exposing (onClick)
import Json.Encode as E

-- MAIN


main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL
type alias Todo =
  { title: String
  , last_modified: Time.Posix
  , delta: Int
  }

type alias Model =
  { zone : Time.Zone
  , time : Time.Posix
  , counter : Int
  , app_start_time: Time.Posix
  }


init : Int -> (Model, Cmd Msg)
init start_time =
  ( Model Time.utc (Time.millisToPosix 0) 0 (Time.millisToPosix start_time) -- Model function arguments
  , Task.perform AdjustTimeZone Time.here -- Cmd
  )



-- UPDATE


type Msg
  = Tick Time.Posix
  | AdjustTimeZone Time.Zone
  | Increment
  | Decrement
  | Save



update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      ( { model | time = newTime } -- model return, but time is changed
      , Cmd.none
      )

    AdjustTimeZone newZone ->
      ( { model | zone = newZone }
      , Cmd.none
      )
    Increment ->
      (
        { model | counter = model.counter+1}
        , Cmd.none
      )
    Decrement ->
      (
        {model|counter = model.counter-1}
        , Cmd.none
      )
    Save ->
      let
        year = String.fromInt (Time.toYear model.zone model.app_start_time)
        month = toIntMonth(Time.toMonth model.zone model.app_start_time)
        day = String.fromInt (Time.toDay model.zone model.app_start_time)
        hour   = String.fromInt (Time.toHour   model.zone model.app_start_time)
        minute = String.fromInt (Time.toMinute model.zone model.app_start_time)
        second = String.fromInt (Time.toSecond model.zone model.app_start_time)
        title = year ++ "-" ++ month ++ "-" ++ day ++ "_" ++ hour ++ "-" ++ minute ++ "-" ++ second 
      in
      ( model
        ,record (E.object
          [ ("title", E.string title)
          , ("body", E.int 42)
          ])
      )
toIntMonth : Month -> String
toIntMonth month =
  case month of
    Jan -> "1"
    Feb -> "2"
    Mar -> "3"
    Apr -> "4"
    May -> "5"
    Jun -> "6"
    Jul -> "7"
    Aug -> "8"
    Sep -> "9"
    Oct -> "10"
    Nov -> "11"
    Dec -> "12"


port record : E.Value -> Cmd msg

-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every 1000 Tick



-- VIEW


view : Model -> Html Msg
view model =
  let
    hour   = String.fromInt (Time.toHour   model.zone model.time)
    minute = String.fromInt (Time.toMinute model.zone model.time)
    second = String.fromInt (Time.toSecond model.zone model.time)
    count = String.fromInt (model.counter)
  in
  div [id "main"]
  [
      h1 [] [ text (hour ++ ":" ++ minute ++ ":" ++ second) ]
    , h1 [class "test-counter"] [text(count)]
    , div [id "time"] [
        button [class "test-button-plus", onClick Increment] [text "+"]
      , button [class "test-counter-save", onClick Save] [text "Save"]
    ]
  ]

