module Foo.Bar.Auto exposing (..)


{- this file is generated by <https://github.com/choonkeat/elm-auto-encoder-decoder> do not modify manually -}


import Foo.Bar exposing (..)
import Dict
import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Main
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


encodeSetSet : (comparable -> Json.Encode.Value) -> Set.Set comparable -> Json.Encode.Value
encodeSetSet encoder =
    Set.toList >> encodeList encoder


encodeDictDict : (a -> Json.Encode.Value) -> (b -> Json.Encode.Value) -> Dict.Dict a b -> Json.Encode.Value
encodeDictDict keyEncoder =
    Json.Encode.dict (\k -> Json.Encode.encode 0 (keyEncoder k))


--

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

-- PRELUDE


{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Nothing") [],CustomTypeConstructor (TitleCaseDotPhrase "Just") [ConstructorTypeParam "a"]], name = TypeName "Maybe" ["a"] } -}
encodeMaybe : (a -> Json.Encode.Value) -> Maybe a -> Json.Encode.Value
encodeMaybe funcArga value =
    case value of
        (Nothing) -> (Json.Encode.list identity [ encodeString "Nothing" ])
        (Just m0) -> (Json.Encode.list identity [ encodeString "Just", (funcArga m0) ])



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Err") [ConstructorTypeParam "x"],CustomTypeConstructor (TitleCaseDotPhrase "Ok") [ConstructorTypeParam "a"]], name = TypeName "Result" ["x","a"] } -}
encodeResult : (x -> Json.Encode.Value) -> (a -> Json.Encode.Value) -> Result x a -> Json.Encode.Value
encodeResult funcArgx funcArga value =
    case value of
        (Err m0) -> (Json.Encode.list identity [ encodeString "Err", (funcArgx m0) ])
        (Ok m0) -> (Json.Encode.list identity [ encodeString "Ok", (funcArga m0) ])

{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Nothing") [],CustomTypeConstructor (TitleCaseDotPhrase "Just") [ConstructorTypeParam "a"]], name = TypeName "Maybe" ["a"] } -}
decodeMaybe : (Json.Decode.Decoder (a)) -> Json.Decode.Decoder (Maybe a)
decodeMaybe funcArga =
    Json.Decode.index 0 Json.Decode.string
        |> Json.Decode.andThen
            (\word ->
                case word of
                    "Nothing" -> (Json.Decode.succeed Nothing)
                    "Just" -> (Json.Decode.succeed Just |> (Json.Decode.Pipeline.custom (Json.Decode.index 1 (funcArga))))
                    _ -> Json.Decode.fail ("Unexpected Maybe: " ++ word)
            )
                 



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Err") [ConstructorTypeParam "x"],CustomTypeConstructor (TitleCaseDotPhrase "Ok") [ConstructorTypeParam "a"]], name = TypeName "Result" ["x","a"] } -}
decodeResult : (Json.Decode.Decoder (x)) -> (Json.Decode.Decoder (a)) -> Json.Decode.Decoder (Result x a)
decodeResult funcArgx funcArga =
    Json.Decode.index 0 Json.Decode.string
        |> Json.Decode.andThen
            (\word ->
                case word of
                    "Err" -> (Json.Decode.succeed Err |> (Json.Decode.Pipeline.custom (Json.Decode.index 1 (funcArgx))))
                    "Ok" -> (Json.Decode.succeed Ok |> (Json.Decode.Pipeline.custom (Json.Decode.index 1 (funcArga))))
                    _ -> Json.Decode.fail ("Unexpected Result: " ++ word)
            )
                 




{-| TypeAliasDef (AliasCustomType (TypeName "Foo.Bar.Choice" []) (CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Option") [CustomTypeConstructor (TitleCaseDotPhrase "Bool") []])) -}
encodeFooBarChoice : Foo.Bar.Choice -> Json.Encode.Value
encodeFooBarChoice value =
    (encodeFooBarOption (encodeBool)) value



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Hello") [],CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Good") [CustomTypeConstructor (TitleCaseDotPhrase "String") [],CustomTypeConstructor (TitleCaseDotPhrase "Result") [ConstructorTypeParam "x",CustomTypeConstructor (TitleCaseDotPhrase "Maybe") [CustomTypeConstructor (TitleCaseDotPhrase "String") []]]]], name = TypeName "Foo.Bar.Hello" ["x"] } -}
encodeFooBarHello : (x -> Json.Encode.Value) -> Foo.Bar.Hello x -> Json.Encode.Value
encodeFooBarHello funcArgx value =
    case value of
        (Foo.Bar.Hello) -> (Json.Encode.list identity [ encodeString "Foo.Bar.Hello" ])
        (Foo.Bar.Good m0 m1) -> (Json.Encode.list identity [ encodeString "Foo.Bar.Good", (encodeString m0), (encodeResult (funcArgx) (encodeMaybe (encodeString)) m1) ])



{-| TypeAliasDef (AliasCustomType (TypeName "Foo.Bar.Lookup" []) (CustomTypeConstructor (TitleCaseDotPhrase "Dict.Dict") [CustomTypeConstructor (TitleCaseDotPhrase "String") [],CustomTypeConstructor (TitleCaseDotPhrase "Int") []])) -}
encodeFooBarLookup : Foo.Bar.Lookup -> Json.Encode.Value
encodeFooBarLookup value =
    (encodeDictDict (encodeString) (encodeInt)) value



{- functions cannot be encoded/decoded into json
{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Noop") [],CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Changes") [Function (CustomTypeConstructor (TitleCaseDotPhrase "String") []) (Function (CustomTypeConstructor (TitleCaseDotPhrase "Int") []) (CustomTypeConstructor (TitleCaseDotPhrase "String") []))]], name = TypeName "Foo.Bar.Msg" [] } -}
encodeFooBarMsg : Foo.Bar.Msg -> Json.Encode.Value
encodeFooBarMsg value =
    case value of
        (Foo.Bar.Noop) -> (Json.Encode.list identity [ encodeString "Foo.Bar.Noop" ])
        (Foo.Bar.Changes m0) -> (Json.Encode.list identity [ encodeString "Foo.Bar.Changes", (<function>) ])
-}



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.None") [],CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Some") [ConstructorTypeParam "a"]], name = TypeName "Foo.Bar.Option" ["a"] } -}
encodeFooBarOption : (a -> Json.Encode.Value) -> Foo.Bar.Option a -> Json.Encode.Value
encodeFooBarOption funcArga value =
    case value of
        (Foo.Bar.None) -> (Json.Encode.list identity [ encodeString "Foo.Bar.None" ])
        (Foo.Bar.Some m0) -> (Json.Encode.list identity [ encodeString "Foo.Bar.Some", (funcArga m0) ])



{-| TypeAliasDef (AliasRecordType (TypeName "Foo.Bar.Payload" []) [CustomField (FieldName "title") (CustomTypeConstructor (TitleCaseDotPhrase "String") []),CustomField (FieldName "author") (CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Person") [])]) -}
encodeFooBarPayload : Foo.Bar.Payload -> Json.Encode.Value
encodeFooBarPayload value =
    Json.Encode.object
        [ ("title", (encodeString) value.title)
        , ("author", (encodeFooBarPerson) value.author)
        ]



{-| TypeAliasDef (AliasRecordType (TypeName "Foo.Bar.Person" []) [CustomField (FieldName "name") (CustomTypeConstructor (TitleCaseDotPhrase "String") []),CustomField (FieldName "age") (CustomTypeConstructor (TitleCaseDotPhrase "Int") [])]) -}
encodeFooBarPerson : Foo.Bar.Person -> Json.Encode.Value
encodeFooBarPerson value =
    Json.Encode.object
        [ ("name", (encodeString) value.name)
        , ("age", (encodeInt) value.age)
        ]

{-| TypeAliasDef (AliasCustomType (TypeName "Foo.Bar.Choice" []) (CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Option") [CustomTypeConstructor (TitleCaseDotPhrase "Bool") []])) -}
decodeFooBarChoice : Json.Decode.Decoder (Foo.Bar.Choice)
decodeFooBarChoice  =
    (decodeFooBarOption (decodeBool))



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Hello") [],CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Good") [CustomTypeConstructor (TitleCaseDotPhrase "String") [],CustomTypeConstructor (TitleCaseDotPhrase "Result") [ConstructorTypeParam "x",CustomTypeConstructor (TitleCaseDotPhrase "Maybe") [CustomTypeConstructor (TitleCaseDotPhrase "String") []]]]], name = TypeName "Foo.Bar.Hello" ["x"] } -}
decodeFooBarHello : (Json.Decode.Decoder (x)) -> Json.Decode.Decoder (Foo.Bar.Hello x)
decodeFooBarHello funcArgx =
    Json.Decode.index 0 Json.Decode.string
        |> Json.Decode.andThen
            (\word ->
                case word of
                    "Foo.Bar.Hello" -> (Json.Decode.succeed Foo.Bar.Hello)
                    "Foo.Bar.Good" -> (Json.Decode.succeed Foo.Bar.Good |> (Json.Decode.Pipeline.custom (Json.Decode.index 1 (decodeString))) |> (Json.Decode.Pipeline.custom (Json.Decode.index 2 (decodeResult (funcArgx) (decodeMaybe (decodeString))))))
                    _ -> Json.Decode.fail ("Unexpected Foo.Bar.Hello: " ++ word)
            )
                 



{-| TypeAliasDef (AliasCustomType (TypeName "Foo.Bar.Lookup" []) (CustomTypeConstructor (TitleCaseDotPhrase "Dict.Dict") [CustomTypeConstructor (TitleCaseDotPhrase "String") [],CustomTypeConstructor (TitleCaseDotPhrase "Int") []])) -}
decodeFooBarLookup : Json.Decode.Decoder (Foo.Bar.Lookup)
decodeFooBarLookup  =
    (decodeDictDict (decodeString) (decodeInt))



{- functions cannot be encoded/decoded into json
{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Noop") [],CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Changes") [Function (CustomTypeConstructor (TitleCaseDotPhrase "String") []) (Function (CustomTypeConstructor (TitleCaseDotPhrase "Int") []) (CustomTypeConstructor (TitleCaseDotPhrase "String") []))]], name = TypeName "Foo.Bar.Msg" [] } -}
decodeFooBarMsg : Json.Decode.Decoder (Foo.Bar.Msg)
decodeFooBarMsg  =
    Json.Decode.index 0 Json.Decode.string
        |> Json.Decode.andThen
            (\word ->
                case word of
                    "Foo.Bar.Noop" -> (Json.Decode.succeed Foo.Bar.Noop)
                    "Foo.Bar.Changes" -> (Json.Decode.succeed Foo.Bar.Changes |> (Json.Decode.Pipeline.custom (Json.Decode.index 1 (<function>))))
                    _ -> Json.Decode.fail ("Unexpected Foo.Bar.Msg: " ++ word)
            )
                 
-}



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.None") [],CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Some") [ConstructorTypeParam "a"]], name = TypeName "Foo.Bar.Option" ["a"] } -}
decodeFooBarOption : (Json.Decode.Decoder (a)) -> Json.Decode.Decoder (Foo.Bar.Option a)
decodeFooBarOption funcArga =
    Json.Decode.index 0 Json.Decode.string
        |> Json.Decode.andThen
            (\word ->
                case word of
                    "Foo.Bar.None" -> (Json.Decode.succeed Foo.Bar.None)
                    "Foo.Bar.Some" -> (Json.Decode.succeed Foo.Bar.Some |> (Json.Decode.Pipeline.custom (Json.Decode.index 1 (funcArga))))
                    _ -> Json.Decode.fail ("Unexpected Foo.Bar.Option: " ++ word)
            )
                 



{-| TypeAliasDef (AliasRecordType (TypeName "Foo.Bar.Payload" []) [CustomField (FieldName "title") (CustomTypeConstructor (TitleCaseDotPhrase "String") []),CustomField (FieldName "author") (CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Person") [])]) -}
decodeFooBarPayload : Json.Decode.Decoder (Foo.Bar.Payload)
decodeFooBarPayload  =
    Json.Decode.succeed Foo.Bar.Payload
        |> Json.Decode.Pipeline.custom (Json.Decode.at [ "title" ] (decodeString))
        |> Json.Decode.Pipeline.custom (Json.Decode.at [ "author" ] (decodeFooBarPerson))



{-| TypeAliasDef (AliasRecordType (TypeName "Foo.Bar.Person" []) [CustomField (FieldName "name") (CustomTypeConstructor (TitleCaseDotPhrase "String") []),CustomField (FieldName "age") (CustomTypeConstructor (TitleCaseDotPhrase "Int") [])]) -}
decodeFooBarPerson : Json.Decode.Decoder (Foo.Bar.Person)
decodeFooBarPerson  =
    Json.Decode.succeed Foo.Bar.Person
        |> Json.Decode.Pipeline.custom (Json.Decode.at [ "name" ] (decodeString))
        |> Json.Decode.Pipeline.custom (Json.Decode.at [ "age" ] (decodeInt))