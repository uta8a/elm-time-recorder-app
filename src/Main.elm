port module Main exposing (..)
import Browser
import Html exposing (..)
import Task
import Time exposing (Month (..))
import Html.Attributes exposing (class,id)
import Html.Events exposing (onClick)
import Json.Encode as E
import Array exposing (..)
import Maybe exposing (withDefault)
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
type alias Message = 
  { message: String }
type alias Model =
  { zone : Time.Zone
  , time : Time.Posix
  , counter : Int
  , app_start_time: Time.Posix
  , message_text: Message
  }


init : Int -> (Model, Cmd Msg)
init start_time =
  ( Model Time.utc (Time.millisToPosix 0) 0 (Time.millisToPosix start_time) {message= "元気？"} -- Model function arguments
  , Task.perform AdjustTimeZone Time.here -- Cmd
  )



-- UPDATE


type Msg
  = Tick Time.Posix
  | AdjustTimeZone Time.Zone
  | Increment
  | Decrement
  | Save
  | ChangeMessage Time.Posix



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
        year = String.padLeft 2 '0' (String.fromInt (Time.toYear model.zone model.app_start_time))
        month = String.padLeft 2 '0' (toIntMonth(Time.toMonth model.zone model.app_start_time))
        day = String.padLeft 2 '0' (String.fromInt (Time.toDay model.zone model.app_start_time))
        hour   = String.padLeft 2 '0' (String.fromInt (Time.toHour   model.zone model.app_start_time))
        minute = String.padLeft 2 '0' (String.fromInt (Time.toMinute model.zone model.app_start_time))
        second = String.padLeft 2 '0' (String.fromInt (Time.toSecond model.zone model.app_start_time))
        title = year ++ "-" ++ month ++ "-" ++ day ++ "_" ++ hour ++ "-" ++ minute ++ "-" ++ second 
      in
      ( model
        ,record (E.object
          [ ("title", E.string title)
          , ("body", E.object [
              ("id1", E.object [
                  ("task", E.string "ねこ")
                , ("description", E.string "かわいいいきもの")
                , ("duration", E.int 1000)
              ] )
            , ("id2", E.object [
                  ("task", E.string "いぬ")
                , ("description", E.string "ほえるいきもの")
                , ("duration", E.int 1100)
              ] )
          ] )
          ])
      )
    ChangeMessage newTime ->
      let
          cheerup_comment = ["やればできる！", "あんたならできるよ", "楽しくやっていきましょう", "うおおおお", "つらいときは休もう！", "疲れたら休憩！", "飽きたらお布団ダイブッ！！"]
          index = modBy (length (fromList cheerup_comment)) (Time.toSecond model.zone model.time) 
          text = {message = withDefault "元気？" (get index (fromList cheerup_comment))}
      in
      ( {model | message_text = text}
      , Cmd.none
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
  Sub.batch [
    Time.every 1000 Tick
  , Time.every 1000 ChangeMessage
  ]


-- VIEW


view : Model -> Html Msg
view model =
  let
    hour   = String.padLeft 2 '0' (String.fromInt (Time.toHour   model.zone model.time))
    minute = String.padLeft 2 '0' (String.fromInt (Time.toMinute model.zone model.time))
    second = String.padLeft 2 '0' (String.fromInt (Time.toSecond model.zone model.time))
    count = String.fromInt (model.counter)
    message = model.message_text.message
  in
  div [id "main"]
  [
      div [id "message"] [
        -- message changes randomly to cheer up User
        h1 [class "message-text", class "text-center", class "pt-10", class "text-5xl"] [text message]
      ]
    , div [id "display-time"] [
        -- 今の時間の下に、プロジェクトとDurationと、その下に、記録ボタンと一時停止ボタンを置く
        h1 [class "clock", class "text-center", class "pt-4", class "text-4xl"] [ text (hour ++ ":" ++ minute ++ ":" ++ second) ]
      , div [id ""] [

      ]
      , h1 [class ""] []
      ]
    , div [id "todo-table"] [
        -- todoのリスト
      ]
    , div [id "manage-data"] [
        -- export/importを行うところ。ボタンで行う。
        -- exportしたJSONファイルがたくさんできちゃうと思うので、そこは別routing(/data)でマージするサービスを提供する。
      ]
    -- , h1 [] [ text (hour ++ ":" ++ minute ++ ":" ++ second) ]
    -- , h1 [class "test-counter"] [text(count)]
    -- , div [id "time"] [
    --     button [class "bb", class "test-button-plus", onClick Increment] [text "+"]
    --   , button [class "test-counter-save", onClick Save] [text "Save"]
    -- ]
  ]

