module Main exposing (..)
import Browser
import Html exposing (..)
import Task
import Time
import Html.Attributes exposing (class,id)


-- MAIN


main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { zone : Time.Zone
  , time : Time.Posix
  , counter : Int
  }


init : () -> (Model, Cmd Msg)
init _ =
  ( Model Time.utc (Time.millisToPosix 0) 0 -- Model function arguments
  , Task.perform AdjustTimeZone Time.here -- Cmd
  )



-- UPDATE


type Msg
  = Tick Time.Posix
  | AdjustTimeZone Time.Zone
  | Increment
  | Decrement



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
    ,h1 [class "test-counter"] [text(count)]

  ]

