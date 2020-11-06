module Tests exposing (viewTest)

-- import Html.Attributes exposing (..)

import Expect exposing (Expectation, true)
import Fuzz exposing (Fuzzer, int, intRange, list, string)
import Html exposing (div)
import Html.Attributes as Ha
import Main exposing (..)
import Test exposing (..)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector exposing (class, containing, id, tag, text)


viewTest : Test
viewTest =
    describe "view test" <|
        [ -- describe "カウンタのテスト"
          -- [ test "カウンタは0を表示している" <|
          --     \() ->
          --         let z = init 0 |> Tuple.first
          --         in
          --         view z
          --             |> Query.fromHtml
          --             |> Query.find [class "test-counter"]
          --             |> Query.has [text "0"]
          -- ]
          -- , describe "増減ボタン"
          -- [
          --     test "+ボタン" <|
          --      \() ->
          --         let z = init 0 |> Tuple.first
          --         in
          --         view z
          --             |> Query.fromHtml
          --             |> Query.find [tag "button", class "test-button-plus"]
          --             |> Event.simulate Event.click
          --             |> Event.expect Increment
          -- ]
          describe "depth 1 html"
            [ test "message-data" <|
                \() ->
                    let
                        model =
                            init 0 |> Tuple.first
                    in
                    view model
                        |> Query.fromHtml
                        |> Query.findAll [ id "message-data" ]
                        |> Query.count (Expect.equal 1)
            , test "display-time" <|
                \() ->
                    let
                        model =
                            init 0 |> Tuple.first
                    in
                    view model
                        |> Query.fromHtml
                        |> Query.findAll [ id "display-time" ]
                        |> Query.count (Expect.equal 1)
            , test "todo-table" <|
                \() ->
                    let
                        model =
                            init 0 |> Tuple.first
                    in
                    view model
                        |> Query.fromHtml
                        |> Query.findAll [ id "todo-table" ]
                        |> Query.count (Expect.equal 1)
            , test "manage-data" <|
                \() ->
                    let
                        model =
                            init 0 |> Tuple.first
                    in
                    view model
                        |> Query.fromHtml
                        |> Query.findAll [ id "manage-data" ]
                        |> Query.count (Expect.equal 1)
            , test "no-id" <|
                \() ->
                    let
                        model =
                            init 0 |> Tuple.first
                    in
                    view model
                        |> Query.fromHtml
                        |> Query.findAll [ id "XXX" ]
                        |> Query.count (Expect.equal 0)
            ]
        ]

