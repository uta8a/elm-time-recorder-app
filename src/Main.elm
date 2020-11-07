port module Main exposing (..)

import Array exposing (..)
import Browser
import Duration
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, on)
import Json.Encode as E
import Maybe exposing (withDefault)
import String exposing (fromInt)
import Task
import Time exposing (Month(..), Zone, millisToPosix, posixToMillis)
import Json.Decode as D


-- MAIN


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- UTIL
ifIsEnter : msg -> D.Decoder msg
ifIsEnter msg =
  D.field "key" D.string
    |> D.andThen (\key -> if key == "Enter" then D.succeed msg else D.fail "some other key")
diffConvert : Int -> String
diffConvert diff = 
    let
        hour = diff//(60*60*1000)
        min = (diff - hour * 60 * 60 * 1000)//(60*1000)
        sec  = (diff - hour* 60*60*1000 - min*60*1000)//1000
    in
        (String.fromInt hour) ++ ":" ++ String.padLeft 2 '0' (String.fromInt min) ++ ":" ++ String.padLeft 2 '0' (String.fromInt sec)
        
    


-- MODEL


type alias Todo =
    { title : String
    , delta : Int
    , mounted_time : Time.Posix
    , id : Int
    }

type alias Message =
    { message : String }


type alias Model =
    { zone : Time.Zone
    , time : Time.Posix
    , counter : Int
    , app_start_time : Time.Posix
    , message_text : Message
    , todos : List Todo
    , globalId : Int
    , draft: String
    , now_todo_id: Int
    , play: Bool
    }


init : Int -> ( Model, Cmd Msg )
init start_time =
    ( Model Time.utc (Time.millisToPosix 0) 0 (millisToPosix start_time) (Message "休憩は大事") [ Todo "休憩" 0 (millisToPosix start_time) 0 ] 1 "" 0 False
      -- Model function arguments
    , Task.perform AdjustTimeZone Time.here
      -- Cmd
    )



-- UPDATE


type Msg
    = Tick Time.Posix
    | AdjustTimeZone Time.Zone
    | Increment
    | Decrement
    | Save
    | ChangeMessage Time.Posix
    | NewTodo
    | DeleteTodo Int
    | DraftChange String
    | SelectTodo Int
    | ComputeDuration Int Time.Posix
    | PlayStart
    | PlayStop

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( { model | time = newTime }
              -- model return, but time is changed
            , Cmd.none
            )

        AdjustTimeZone newZone ->
            ( { model | zone = newZone }
            , Cmd.none
            )

        Increment ->
            ( { model | counter = model.counter + 1 }
            , Cmd.none
            )

        Decrement ->
            ( { model | counter = model.counter - 1 }
            , Cmd.none
            )

        Save ->
            let
                year =
                    String.padLeft 2 '0' (String.fromInt (Time.toYear model.zone model.app_start_time))

                month =
                    String.padLeft 2 '0' (String.fromInt (toIntMonth (Time.toMonth model.zone model.app_start_time)))

                day =
                    String.padLeft 2 '0' (String.fromInt (Time.toDay model.zone model.app_start_time))

                hour =
                    String.padLeft 2 '0' (String.fromInt (Time.toHour model.zone model.app_start_time))

                minute =
                    String.padLeft 2 '0' (String.fromInt (Time.toMinute model.zone model.app_start_time))

                second =
                    String.padLeft 2 '0' (String.fromInt (Time.toSecond model.zone model.app_start_time))

                title =
                    year ++ "-" ++ month ++ "-" ++ day ++ "_" ++ hour ++ "-" ++ minute ++ "-" ++ second
            in
            ( model
            , record
                (E.object
                    [ ( "title", E.string title )
                    , ( "body"
                      , E.object
                            [ ( "id1"
                              , E.object
                                    [ ( "task", E.string "ねこ" )
                                    , ( "description", E.string "かわいいいきもの" )
                                    , ( "duration", E.int 1000 )
                                    ]
                              )
                            , ( "id2"
                              , E.object
                                    [ ( "task", E.string "いぬ" )
                                    , ( "description", E.string "ほえるいきもの" )
                                    , ( "duration", E.int 1100 )
                                    ]
                              )
                            ]
                      )
                    ]
                )
            )

        ChangeMessage newTime ->
            let
                cheerup_comment =
                    [ "やればできる！", "あんたならできるよ", "楽しくやっていきましょう", "うおおおお", "つらいときは休もう！", "疲れたら休憩！", "飽きたらお布団ダイブッ！！" ]

                index =
                    modBy (length (fromList cheerup_comment)) (Time.toSecond model.zone model.time)

                text =
                    { message = withDefault "元気？" (get index (fromList cheerup_comment)) }
            in
            ( { model | message_text = text }
            , Cmd.none
            )

        NewTodo ->
            let
                preModel =
                    { model | globalId = model.globalId + 1 }

                newModel =
                    { preModel | todos = Todo model.draft 0 model.time model.globalId :: model.todos }
            in
            ( newModel
            , Cmd.none
            )

        DeleteTodo id ->
            let
                newModel =
                    { model | todos = List.filter (\x -> x.id /= id) model.todos }
            in
            ( newModel
            , Cmd.none
            )
        DraftChange draft ->
            ( {model | draft = draft}
            , Cmd.none
            )
        SelectTodo id ->
            ( {model|now_todo_id = id}
            , Cmd.none
            )
        ComputeDuration id t ->
            -- ( { model | todos = (List.map (\x -> if x.id == id && model.play then {x| delta = posixToMillis(model.time) - posixToMillis(x.mounted_time)} else x) model.todos) }
            ( { model | todos = (List.map (\x -> if x.id == id && model.play then {x| delta = x.delta+1000} else x) model.todos) }
            , Cmd.none
            )
        PlayStart -> 
            ({model|play = True}
            , Cmd.none
            )
        PlayStop -> 
            ({model|play = False}
            , Cmd.none
            )    

toIntMonth : Month -> Int
toIntMonth month =
    case month of
        Jan ->
            1

        Feb ->
            2

        Mar ->
            3

        Apr ->
            4

        May ->
            5

        Jun ->
            6

        Jul ->
            7

        Aug ->
            8

        Sep ->
            9

        Oct ->
            10

        Nov ->
            11

        Dec ->
            12


port record : E.Value -> Cmd msg


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Time.every 1000 Tick
        , Time.every 60000 ChangeMessage
        , Time.every 1000 (ComputeDuration model.now_todo_id)
        ]



-- VIEW


genTr : Model -> Todo -> Html Msg
genTr model todo =
    let
        duration =
            todo.delta

        -- hour   = String.fromInt (Time.toHour zone todo.delta)
        -- minute = String.padLeft 2 '0' (String.fromInt (Time.toMinute zone todo.delta))
        -- second = String.padLeft 2 '0' (String.fromInt (Time.toSecond zone todo.delta))
    in
    tr []
        [ td [class "bg-transparent text-red-700 font-semibold hover:text-white mr-3 px-3 rounded text-3xl"] [if todo.id == model.now_todo_id then (text "⭐") else (text "")]
        , td []
            [ button [ class "bg-transparent hover:bg-red-500 text-red-700 font-semibold hover:text-white mr-3 px-3 border border-red-500 hover:border-transparent rounded text-3xl", onClick (SelectTodo todo.id)] [ text ">>>" ]
            ]
        , td [ class "text-2xl border-8 border-green-400 text-center" ] [ text (todo.title) ]
        , td [ class "text-2xl border-8 border-green-400 text-center" ] [ text (diffConvert todo.delta) ]
        -- -- TODO delete button design
        , td []
            [ if todo.id /= 0 then (button [ class "bg-transparent hover:bg-blue-500 text-blue-700 font-semibold hover:text-white ml-3 px-3 border border-blue-500 hover:border-transparent rounded text-3xl", onClick (DeleteTodo todo.id)] [ text "x" ]) else (div[][])
            ]
        ]


view : Model -> Html Msg
view model =
    let
        hour =
            String.padLeft 2 '0' (String.fromInt (Time.toHour model.zone model.time))

        minute =
            String.padLeft 2 '0' (String.fromInt (Time.toMinute model.zone model.time))

        second =
            String.padLeft 2 '0' (String.fromInt (Time.toSecond model.zone model.time))

        count =
            String.fromInt model.counter

        message =
            model.message_text.message

        todos =
            model.todos
        -- message_data message changes randomly to cheer up User
        message_data =
            div [ id "message-data" ]
                [ h1 [ class "message-text", class "text-center", class "pt-10", class "text-5xl" ] [ text message ]
                ]
        -- display current time and project:duration
        display_time =
            div [ id "display-time", class "w-4/5", class "m-auto" ]
                [ -- 今の時間の下に、プロジェクトとDurationと、その下に、記録ボタンと一時停止ボタンを置く
                  h1 [ class "clock", class "text-center", class "pt-5", class "text-5xl" ] [ text (hour ++ ":" ++ minute ++ ":" ++ second) ]
                , div [ id "todo-display", class "justify-center", class "flex", class "pt-1" ]
                    [ div [ class "todo-display-name", class "text-5xl" ] [ text (withDefault (Todo "---" 0 (millisToPosix 0) 0) (List.head (List.filter (\x -> x.id ==model.now_todo_id) model.todos))).title ]
                    , div [ class "todo-display-separator", class "text-5xl", class "px-5" ] [ text "🐈" ]
                    , div [ class "todo-display-duration", class "text-5xl" ] [ text (diffConvert (withDefault (Todo "---" 0 (millisToPosix 0) 0) (List.head (List.filter (\x -> x.id ==model.now_todo_id) model.todos))).delta) ]
                    ]
                , div [ id "start-stop-button", class "justify-center", class "flex", class "pt-5" ]
                    [ -- TODO Onclickで発火するようにしておく
                      button [ class "button-start", class "text-5xl", class "px-4 mx-4", class "border-4 border-solid", class "hover:bg-green-400", onClick PlayStart] [ text "▶" ]
                    , button [ class "button-stop", class "text-5xl", class "px-3 mx-4", class "border-4 border-solid", class "hover:bg-blue-400" , onClick PlayStop ] [ text "⏸" ]
                    ]
                ]
        -- todo input area
        todo_input = 
            div [class "mx-auto"] [
                div [class "text-2xl"] [text "🦍 < やることを入力してEnterキーを押してね"]
                -- button [ class "bg-transparent hover:bg-blue-500 text-blue-700 font-semibold hover:text-white ml-3 px-3 border border-blue-500 hover:border-transparent rounded text-3xl", class "mx-auto", onClick (NewTodo )] [ text "add todo" ]
                , input [id "input-new-todo", class "text-2xl border border-blue-500 my-3", placeholder "やること", on "keydown" (ifIsEnter NewTodo), onInput DraftChange, value model.draft ] []
            ]
        -- todo table and duration
        todo_table =
            div [ id "todo-table", class "flex flex-col justify-center w-3/5 mx-auto" ]
                [ 
                  todo_input
                , table [ class "table-fixed mx-auto" ]
                    [ thead []
                        [ th [] []
                        , th [] []
                        , th [ class "border-green-400 border-8 w-1/2" ] [ text "Todo Name" ]
                        , th [ class "border-green-400 border-8 w-1/2" ] [ text "Duration" ]
                        , th [] []
                        ]
                    , tbody [] (List.map (genTr model) todos)
                    ]
                ]
        -- export/import JSON data
        manage_data =
            div [ id "manage-data" ]
                [-- export/importを行うところ。ボタンで行う。
                 -- exportしたJSONファイルがたくさんできちゃうと思うので、そこは別routing(/data)でマージするサービスを提供する。
                ]
    in
    div [ id "main" ]
        [ message_data
        , display_time
        , todo_table
        , manage_data
        ]
