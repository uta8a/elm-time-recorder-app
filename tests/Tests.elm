module Tests exposing (viewTest)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, intRange, list, string)
import Main exposing (..)
import Test exposing (..)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector exposing (containing, tag, text, class)
-- Check out https://package.elm-lang.org/packages/elm-explorations/test/latest to learn more about testing in Elm!

viewTest : Test
viewTest = 
    describe "view test"
        [ test "カウンタは0を表示している" <| 
            \() ->
                let z = init () |> Tuple.first
                in
                view z
                    |> Query.fromHtml
                    |> Query.find [class "test-counter"]
                    |> Query.has [text "0"]
        ]

-- all : Test
-- all =
--     describe "A Test Suite"
--         [ test "Addition" <|
--             \_ ->
--                 Expect.equal 10 (3 + 7)
--         , test "String.left" <|
--             \_ ->
--                 Expect.equal "a" (String.left 1 "abcdefg")
--         , test "This test should fail" <|
--             \_ ->
--                 Expect.fail "failed as expected!"
--         ]
