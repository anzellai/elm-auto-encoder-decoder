module Foo.Baz.Auto exposing (..)


{- this file is generated by <https://github.com/choonkeat/elm-auto-encoder-decoder> do not modify manually -}


import Foo.Baz exposing (..)
import Array
import Dict
import Json.Decode
import Json.Encode
import Platform
import Set



-- HARDCODE


encodeString : String -> Json.Encode.Value
encodeString =
    Json.Encode.string


encodeInt : Int -> Json.Encode.Value
encodeInt =
    Json.Encode.int


encodeFloat : Float -> Json.Encode.Value
encodeFloat =
    Json.Encode.float


encodeBool : Bool -> Json.Encode.Value
encodeBool =
    Json.Encode.bool


encodeList : (a -> Json.Encode.Value) -> List a -> Json.Encode.Value
encodeList =
    Json.Encode.list


encodeArrayArray : (a -> Json.Encode.Value) -> Array.Array a -> Json.Encode.Value
encodeArrayArray =
    Json.Encode.array


encodeResultResult : (x -> Json.Encode.Value) -> (a -> Json.Encode.Value) -> Result.Result x a -> Json.Encode.Value
encodeResultResult encodex encodea result =
    case result of
        Err x ->
            Json.Encode.list identity [ Json.Encode.string "Err", encodex x ]

        Ok a ->
            Json.Encode.list identity [ Json.Encode.string "Ok", encodea a ]


encodeSetSet : (comparable -> Json.Encode.Value) -> Set.Set comparable -> Json.Encode.Value
encodeSetSet encoder =
    Set.toList >> encodeList encoder


encodeDictDict : (a -> Json.Encode.Value) -> (b -> Json.Encode.Value) -> Dict.Dict a b -> Json.Encode.Value
encodeDictDict keyEncoder =
    Json.Encode.dict (\k -> Json.Encode.encode 0 (keyEncoder k))


encode_Unit : () -> Json.Encode.Value
encode_Unit value =
    Json.Encode.list identity [ encodeString "" ]


encodeJsonDecodeValue : Json.Decode.Value -> Json.Encode.Value
encodeJsonDecodeValue a =
    a


encodeJsonEncodeValue : Json.Encode.Value -> Json.Encode.Value
encodeJsonEncodeValue a =
    a



--


decodeJsonDecodeValue : Json.Decode.Decoder Json.Decode.Value
decodeJsonDecodeValue =
    Json.Decode.value


decodeJsonEncodeValue : Json.Decode.Decoder Json.Decode.Value
decodeJsonEncodeValue =
    Json.Decode.value


decodeString : Json.Decode.Decoder String
decodeString =
    Json.Decode.string


decodeInt : Json.Decode.Decoder Int
decodeInt =
    Json.Decode.int


decodeFloat : Json.Decode.Decoder Float
decodeFloat =
    Json.Decode.float


decodeBool : Json.Decode.Decoder Bool
decodeBool =
    Json.Decode.bool


decodeList : (Json.Decode.Decoder a) -> Json.Decode.Decoder (List a)
decodeList =
    Json.Decode.list


decodeArrayArray : (Json.Decode.Decoder a) -> Json.Decode.Decoder (Array.Array a)
decodeArrayArray =
    Json.Decode.array


decodeResultResult : Json.Decode.Decoder x -> Json.Decode.Decoder a -> Json.Decode.Decoder (Result.Result x a)
decodeResultResult decodex decodea =
    Json.Decode.index 0 Json.Decode.string
        |> Json.Decode.andThen
            (\s ->
                case s of
                    "Err" ->
                        Json.Decode.map Err (Json.Decode.index 1 decodex)

                    "Ok" ->
                        Json.Decode.map Ok (Json.Decode.index 1 decodea)

                    _ ->
                        Json.Decode.fail ("Unexpected: " ++ s)
            )


decodeSetSet : (Json.Decode.Decoder comparable) -> Json.Decode.Decoder (Set.Set comparable)
decodeSetSet =
    Json.Decode.list >> Json.Decode.map Set.fromList


decodeDictDict : (Json.Decode.Decoder comparable) -> (Json.Decode.Decoder b) -> Json.Decode.Decoder (Dict.Dict comparable b)
decodeDictDict keyDecoder valueDecoder =
    Json.Decode.dict valueDecoder
        |> Json.Decode.map (\dict ->
            Dict.foldl (\string v acc ->
                case Json.Decode.decodeString keyDecoder string of
                    Ok k ->
                        Dict.insert k v acc
                    Err _ ->
                        acc
            ) Dict.empty dict
        )


decode_Unit : Json.Decode.Decoder ()
decode_Unit  =
    Json.Decode.index 0 Json.Decode.string
        |> Json.Decode.andThen
            (\word ->
                case word of
                    "" -> (Json.Decode.succeed ())
                    _ -> Json.Decode.fail ("Unexpected Unit: " ++ word)
            )


-- PRELUDE


{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Nothing") [],CustomTypeConstructor (TitleCaseDotPhrase "Just") [ConstructorTypeParam "a"]], name = TypeName "Maybe" ["a"] } -}
encodeMaybe : (a -> Json.Encode.Value) -> Maybe a -> Json.Encode.Value
encodeMaybe arga value =
    case value of
        (Nothing) -> (encodeString "Nothing")
        (Just m0) -> (Json.Encode.list identity [ encodeString "Just", (arga m0) ])



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Err") [ConstructorTypeParam "x"],CustomTypeConstructor (TitleCaseDotPhrase "Ok") [ConstructorTypeParam "a"]], name = TypeName "Result" ["x","a"] } -}
encodeResult : (x -> Json.Encode.Value) -> (a -> Json.Encode.Value) -> Result x a -> Json.Encode.Value
encodeResult argx arga value =
    case value of
        (Err m0) -> (Json.Encode.list identity [ encodeString "Err", (argx m0) ])
        (Ok m0) -> (Json.Encode.list identity [ encodeString "Ok", (arga m0) ])

{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Nothing") [],CustomTypeConstructor (TitleCaseDotPhrase "Just") [ConstructorTypeParam "a"]], name = TypeName "Maybe" ["a"] } -}
decodeMaybe : (Json.Decode.Decoder (a)) -> Json.Decode.Decoder (Maybe a)
decodeMaybe arga =
    Json.Decode.string
        |> Json.Decode.andThen
            (\word ->
                case word of
                    "Nothing" -> (Json.Decode.succeed Nothing)
                    "Just" -> (Json.Decode.succeed Just |> (Json.Decode.map2 (|>) ((Json.Decode.index 1 (arga)))))
                    _ -> Json.Decode.fail ("Unexpected Maybe: " ++ word)
            )
                 



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Err") [ConstructorTypeParam "x"],CustomTypeConstructor (TitleCaseDotPhrase "Ok") [ConstructorTypeParam "a"]], name = TypeName "Result" ["x","a"] } -}
decodeResult : (Json.Decode.Decoder (x)) -> (Json.Decode.Decoder (a)) -> Json.Decode.Decoder (Result x a)
decodeResult argx arga =
    Json.Decode.string
        |> Json.Decode.andThen
            (\word ->
                case word of
                    "Err" -> (Json.Decode.succeed Err |> (Json.Decode.map2 (|>) ((Json.Decode.index 1 (argx)))))
                    "Ok" -> (Json.Decode.succeed Ok |> (Json.Decode.map2 (|>) ((Json.Decode.index 1 (arga)))))
                    _ -> Json.Decode.fail ("Unexpected Result: " ++ word)
            )
                 




{-| TypeAliasDef (AliasRecordType (TypeName "Foo.Baz.Record" []) [CustomField (FieldName "title") (CustomTypeConstructor (TitleCaseDotPhrase "String") [])]) -}
encodeFooBazRecord : Foo.Baz.Record -> Json.Encode.Value
encodeFooBazRecord value =
    Json.Encode.object
        [ ("title", encodeString value.title)
        ]



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Foo.Baz.Transparent") [CustomTypeConstructor (TitleCaseDotPhrase "Int") []]], name = TypeName "Foo.Baz.Transparent" [] } -}
encodeFooBazTransparent : Foo.Baz.Transparent -> Json.Encode.Value
encodeFooBazTransparent value =
    case value of
        (Foo.Baz.Transparent m0) -> (Json.Encode.list identity [ encodeString "Transparent", encodeInt m0 ])

{-| TypeAliasDef (AliasRecordType (TypeName "Foo.Baz.Record" []) [CustomField (FieldName "title") (CustomTypeConstructor (TitleCaseDotPhrase "String") [])]) -}
decodeFooBazRecord : Json.Decode.Decoder (Foo.Baz.Record)
decodeFooBazRecord  =
    Json.Decode.succeed Foo.Baz.Record
        |> Json.Decode.map2 (|>) (Json.Decode.at [ "title" ] (decodeString))



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Foo.Baz.Transparent") [CustomTypeConstructor (TitleCaseDotPhrase "Int") []]], name = TypeName "Foo.Baz.Transparent" [] } -}
decodeFooBazTransparent : Json.Decode.Decoder (Foo.Baz.Transparent)
decodeFooBazTransparent  =
    Json.Decode.string
        |> Json.Decode.andThen
            (\word ->
                case word of
                    "Transparent" -> (Json.Decode.succeed Foo.Baz.Transparent |> (Json.Decode.map2 (|>) ( (Json.Decode.index 1 (decodeInt)))))
                    _ -> Json.Decode.fail ("Unexpected Foo.Baz.Transparent: " ++ word)
            )
                 