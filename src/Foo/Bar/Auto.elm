module Foo.Bar.Auto exposing (..)


{- this file is generated by <https://github.com/choonkeat/elm-auto-encoder-decoder> do not modify manually -}


import Foo.Bar exposing (..)
import Array exposing (Array)
import Dict exposing (Dict)
import Foo.Baz
import Foo.Baz.Auto exposing (..)
import Json.Decode
import Json.Encode
import Main
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
                 




{-| TypeAliasDef (AliasCustomType (TypeName "Foo.Bar.Acknowledgement" ["x"]) (CustomTypeConstructor (TitleCaseDotPhrase "Result") [ConstructorTypeParam "x",CustomTypeConstructor (TitleCaseDotPhrase "()") []])) -}
encodeFooBarAcknowledgement : (x -> Json.Encode.Value) -> Foo.Bar.Acknowledgement x -> Json.Encode.Value
encodeFooBarAcknowledgement argx value =
    (encodeResult (argx) (encode_Unit)) value



{-| TypeAliasDef (AliasCustomType (TypeName "Foo.Bar.Choice" []) (CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Option") [CustomTypeConstructor (TitleCaseDotPhrase "Bool") []])) -}
encodeFooBarChoice : Foo.Bar.Choice -> Json.Encode.Value
encodeFooBarChoice value =
    (encodeFooBarOption (encodeBool)) value



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.LatLng") [Tuple2 (CustomTypeConstructor (TitleCaseDotPhrase "Float") []) (CustomTypeConstructor (TitleCaseDotPhrase "Float") [])],CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Address") [Tuple3 (CustomTypeConstructor (TitleCaseDotPhrase "String") []) (CustomTypeConstructor (TitleCaseDotPhrase "Int") []) (CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.CountryCode") [])]], name = TypeName "Foo.Bar.Coordinates" [] } -}
encodeFooBarCoordinates : Foo.Bar.Coordinates -> Json.Encode.Value
encodeFooBarCoordinates value =
    case value of
        (Foo.Bar.LatLng (m0, m1 )) -> (Json.Encode.list identity [ encodeString "LatLng", encodeFloat m0, encodeFloat m1 ])
        (Foo.Bar.Address (m0, m1, m2 )) -> (Json.Encode.list identity [ encodeString "Address", encodeString m0, encodeInt m1, encodeFooBarCountryCode m2 ])



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.AA") [],CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.AB") [],CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.AC") [],CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.ZZ") []], name = TypeName "Foo.Bar.CountryCode" [] } -}
encodeFooBarCountryCode : Foo.Bar.CountryCode -> Json.Encode.Value
encodeFooBarCountryCode value =
    case value of
        (Foo.Bar.AA) -> (encodeString "AA")
        (Foo.Bar.AB) -> (encodeString "AB")
        (Foo.Bar.AC) -> (encodeString "AC")
        (Foo.Bar.ZZ) -> (encodeString "ZZ")



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Traditional_phrase") [],CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Bespoke_sentence") []], name = TypeName "Foo.Bar.Custom_word" [] } -}
encodeFooBarCustom_word : Foo.Bar.Custom_word -> Json.Encode.Value
encodeFooBarCustom_word value =
    case value of
        (Foo.Bar.Traditional_phrase) -> (encodeString "Traditional_phrase")
        (Foo.Bar.Bespoke_sentence) -> (encodeString "Bespoke_sentence")



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Hello") [],CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Good") [CustomTypeConstructor (TitleCaseDotPhrase "String") [],CustomTypeConstructor (TitleCaseDotPhrase "Result") [CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Option") [ConstructorTypeParam "x"],CustomTypeConstructor (TitleCaseDotPhrase "Maybe") [CustomTypeConstructor (TitleCaseDotPhrase "String") []]]]], name = TypeName "Foo.Bar.Hello" ["x"] } -}
encodeFooBarHello : (x -> Json.Encode.Value) -> Foo.Bar.Hello x -> Json.Encode.Value
encodeFooBarHello argx value =
    case value of
        (Foo.Bar.Hello) -> (encodeString "Hello")
        (Foo.Bar.Good m0 m1) -> (Json.Encode.list identity [ encodeString "Good", encodeString m0, encodeResult (encodeFooBarOption ((argx))) (encodeMaybe (encodeString)) m1 ])



{-| TypeAliasDef (AliasCustomType (TypeName "Foo.Bar.Lookup" []) (CustomTypeConstructor (TitleCaseDotPhrase "Dict.Dict") [CustomTypeConstructor (TitleCaseDotPhrase "String") [],CustomTypeConstructor (TitleCaseDotPhrase "Array.Array") [CustomTypeConstructor (TitleCaseDotPhrase "Foo.Baz.Record") []]])) -}
encodeFooBarLookup : Foo.Bar.Lookup -> Json.Encode.Value
encodeFooBarLookup value =
    (encodeDictDict (encodeString) (encodeArrayArray (encodeFooBazRecord))) value



{- functions cannot be encoded/decoded into json
{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Noop") [],CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Changes") [Function (CustomTypeConstructor (TitleCaseDotPhrase "String") []) (Function (CustomTypeConstructor (TitleCaseDotPhrase "Int") []) (CustomTypeConstructor (TitleCaseDotPhrase "String") []))]], name = TypeName "Foo.Bar.Msg" [] } -}
encodeFooBarMsg : Foo.Bar.Msg -> Json.Encode.Value
encodeFooBarMsg value =
    case value of
        (Foo.Bar.Noop) -> (encodeString "Noop")
        (Foo.Bar.Changes m0) -> (Json.Encode.list identity [ encodeString "Changes", <function> ])
-}



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.None") [],CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Some") [ConstructorTypeParam "Foo.Bar.a"]], name = TypeName "Foo.Bar.Option" ["a"] } -}
encodeFooBarOption : (a -> Json.Encode.Value) -> Foo.Bar.Option a -> Json.Encode.Value
encodeFooBarOption arga value =
    case value of
        (Foo.Bar.None) -> (encodeString "None")
        (Foo.Bar.Some m0) -> (Json.Encode.list identity [ encodeString "Some", (arga m0) ])



{-| TypeAliasDef (AliasRecordType (TypeName "Foo.Bar.Payload" []) [CustomField (FieldName "title") (CustomTypeConstructor (TitleCaseDotPhrase "String") []),CustomField (FieldName "author_person") (CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Person") []),CustomField (FieldName "comments") (CustomTypeConstructor (TitleCaseDotPhrase "Maybe") [CustomTypeConstructor (TitleCaseDotPhrase "String") []]),CustomField (FieldName "blob") (CustomTypeConstructor (TitleCaseDotPhrase "Json.Encode.Value") []),CustomField (FieldName "blob2") (CustomTypeConstructor (TitleCaseDotPhrase "Json.Decode.Value") []),CustomField (FieldName "custom_word") (CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Custom_word") [])]) -}
encodeFooBarPayload : Foo.Bar.Payload -> Json.Encode.Value
encodeFooBarPayload value =
    Json.Encode.object
        [ ("title", encodeString value.title)
        , ("author_person", encodeFooBarPerson value.author_person)
        , ("comments", encodeMaybe (encodeString) value.comments)
        , ("blob", encodeJsonEncodeValue value.blob)
        , ("blob2", encodeJsonDecodeValue value.blob2)
        , ("custom_word", encodeFooBarCustom_word value.custom_word)
        ]



{-| TypeAliasDef (AliasRecordType (TypeName "Foo.Bar.Person" []) [CustomField (FieldName "name") (CustomTypeConstructor (TitleCaseDotPhrase "String") []),CustomField (FieldName "age") (CustomTypeConstructor (TitleCaseDotPhrase "Int") [])]) -}
encodeFooBarPerson : Foo.Bar.Person -> Json.Encode.Value
encodeFooBarPerson value =
    Json.Encode.object
        [ ("name", encodeString value.name)
        , ("age", encodeInt value.age)
        ]



{- we cannot auto generate encoder/decoder for unexposed types
{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.PrivateCustom") [CustomTypeConstructor (TitleCaseDotPhrase "Int") []]], name = TypeName "Foo.Bar.PrivateCustom" [] } -}
encodeFooBarPrivateCustom : Foo.Bar.PrivateCustom -> Json.Encode.Value
encodeFooBarPrivateCustom value =
    case value of
        (Foo.Bar.PrivateCustom m0) -> (Json.Encode.list identity [ encodeString "PrivateCustom", encodeInt m0 ])
-}



{- we cannot auto generate encoder/decoder for unexposed types
{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.ProtectedCustom") [CustomTypeConstructor (TitleCaseDotPhrase "Int") []]], name = TypeName "Foo.Bar.ProtectedCustom" [] } -}
encodeFooBarProtectedCustom : Foo.Bar.ProtectedCustom -> Json.Encode.Value
encodeFooBarProtectedCustom value =
    case value of
        (Foo.Bar.ProtectedCustom m0) -> (Json.Encode.list identity [ encodeString "ProtectedCustom", encodeInt m0 ])
-}



{-| TypeAliasDef (AliasRecordType (TypeName "Foo.Bar.WithTypeVariable" ["a"]) [CustomField (FieldName "meta") (CustomTypeConstructor (TitleCaseDotPhrase "Result") [CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Hello") [ConstructorTypeParam "Foo.Bar.a"],CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Payload") []]),CustomField (FieldName "data") (ConstructorTypeParam "Foo.Bar.a")]) -}
encodeFooBarWithTypeVariable : (a -> Json.Encode.Value) -> Foo.Bar.WithTypeVariable a -> Json.Encode.Value
encodeFooBarWithTypeVariable arga value =
    Json.Encode.object
        [ ("meta", encodeResult (encodeFooBarHello ((arga))) (encodeFooBarPayload) value.meta)
        , ("data", (arga) value.data)
        ]

{-| TypeAliasDef (AliasCustomType (TypeName "Foo.Bar.Acknowledgement" ["x"]) (CustomTypeConstructor (TitleCaseDotPhrase "Result") [ConstructorTypeParam "x",CustomTypeConstructor (TitleCaseDotPhrase "()") []])) -}
decodeFooBarAcknowledgement : (Json.Decode.Decoder (x)) -> Json.Decode.Decoder (Foo.Bar.Acknowledgement x)
decodeFooBarAcknowledgement argx =
    (decodeResult (argx) (decode_Unit))



{-| TypeAliasDef (AliasCustomType (TypeName "Foo.Bar.Choice" []) (CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Option") [CustomTypeConstructor (TitleCaseDotPhrase "Bool") []])) -}
decodeFooBarChoice : Json.Decode.Decoder (Foo.Bar.Choice)
decodeFooBarChoice  =
    (decodeFooBarOption (decodeBool))



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.LatLng") [Tuple2 (CustomTypeConstructor (TitleCaseDotPhrase "Float") []) (CustomTypeConstructor (TitleCaseDotPhrase "Float") [])],CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Address") [Tuple3 (CustomTypeConstructor (TitleCaseDotPhrase "String") []) (CustomTypeConstructor (TitleCaseDotPhrase "Int") []) (CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.CountryCode") [])]], name = TypeName "Foo.Bar.Coordinates" [] } -}
decodeFooBarCoordinates : Json.Decode.Decoder (Foo.Bar.Coordinates)
decodeFooBarCoordinates  =
    Json.Decode.string
        |> Json.Decode.andThen
            (\word ->
                case word of
                    "LatLng" -> (Json.Decode.succeed Foo.Bar.LatLng |> (Json.Decode.map2 (|>) (Json.Decode.map2 (\item1 item2 -> (item1, item2))  (Json.Decode.index 1 (decodeFloat))  (Json.Decode.index 2 (decodeFloat)))))
                    "Address" -> (Json.Decode.succeed Foo.Bar.Address |> (Json.Decode.map2 (|>) (Json.Decode.map3 (\item1 item2 item3 -> (item1, item2, item3))   (Json.Decode.index 1 (decodeString))  (Json.Decode.index 2 (decodeInt))  (Json.Decode.index 3 (decodeFooBarCountryCode)))))
                    _ -> Json.Decode.fail ("Unexpected Foo.Bar.Coordinates: " ++ word)
            )
                 



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.AA") [],CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.AB") [],CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.AC") [],CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.ZZ") []], name = TypeName "Foo.Bar.CountryCode" [] } -}
decodeFooBarCountryCode : Json.Decode.Decoder (Foo.Bar.CountryCode)
decodeFooBarCountryCode  =
    Json.Decode.string
        |> Json.Decode.andThen
            (\word ->
                case word of
                    "AA" -> (Json.Decode.succeed Foo.Bar.AA)
                    "AB" -> (Json.Decode.succeed Foo.Bar.AB)
                    "AC" -> (Json.Decode.succeed Foo.Bar.AC)
                    "ZZ" -> (Json.Decode.succeed Foo.Bar.ZZ)
                    _ -> Json.Decode.fail ("Unexpected Foo.Bar.CountryCode: " ++ word)
            )
                 



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Traditional_phrase") [],CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Bespoke_sentence") []], name = TypeName "Foo.Bar.Custom_word" [] } -}
decodeFooBarCustom_word : Json.Decode.Decoder (Foo.Bar.Custom_word)
decodeFooBarCustom_word  =
    Json.Decode.string
        |> Json.Decode.andThen
            (\word ->
                case word of
                    "Traditional_phrase" -> (Json.Decode.succeed Foo.Bar.Traditional_phrase)
                    "Bespoke_sentence" -> (Json.Decode.succeed Foo.Bar.Bespoke_sentence)
                    _ -> Json.Decode.fail ("Unexpected Foo.Bar.Custom_word: " ++ word)
            )
                 



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Hello") [],CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Good") [CustomTypeConstructor (TitleCaseDotPhrase "String") [],CustomTypeConstructor (TitleCaseDotPhrase "Result") [CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Option") [ConstructorTypeParam "x"],CustomTypeConstructor (TitleCaseDotPhrase "Maybe") [CustomTypeConstructor (TitleCaseDotPhrase "String") []]]]], name = TypeName "Foo.Bar.Hello" ["x"] } -}
decodeFooBarHello : (Json.Decode.Decoder (x)) -> Json.Decode.Decoder (Foo.Bar.Hello x)
decodeFooBarHello argx =
    Json.Decode.string
        |> Json.Decode.andThen
            (\word ->
                case word of
                    "Hello" -> (Json.Decode.succeed Foo.Bar.Hello)
                    "Good" -> (Json.Decode.succeed Foo.Bar.Good |> (Json.Decode.map2 (|>) ( (Json.Decode.index 1 (decodeString)))) |> (Json.Decode.map2 (|>) ( (Json.Decode.index 2 (decodeResult (decodeFooBarOption ((argx))) (decodeMaybe (decodeString)))))))
                    _ -> Json.Decode.fail ("Unexpected Foo.Bar.Hello: " ++ word)
            )
                 



{-| TypeAliasDef (AliasCustomType (TypeName "Foo.Bar.Lookup" []) (CustomTypeConstructor (TitleCaseDotPhrase "Dict.Dict") [CustomTypeConstructor (TitleCaseDotPhrase "String") [],CustomTypeConstructor (TitleCaseDotPhrase "Array.Array") [CustomTypeConstructor (TitleCaseDotPhrase "Foo.Baz.Record") []]])) -}
decodeFooBarLookup : Json.Decode.Decoder (Foo.Bar.Lookup)
decodeFooBarLookup  =
    (decodeDictDict (decodeString) (decodeArrayArray (decodeFooBazRecord)))



{- functions cannot be encoded/decoded into json
{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Noop") [],CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Changes") [Function (CustomTypeConstructor (TitleCaseDotPhrase "String") []) (Function (CustomTypeConstructor (TitleCaseDotPhrase "Int") []) (CustomTypeConstructor (TitleCaseDotPhrase "String") []))]], name = TypeName "Foo.Bar.Msg" [] } -}
decodeFooBarMsg : Json.Decode.Decoder (Foo.Bar.Msg)
decodeFooBarMsg  =
    Json.Decode.string
        |> Json.Decode.andThen
            (\word ->
                case word of
                    "Noop" -> (Json.Decode.succeed Foo.Bar.Noop)
                    "Changes" -> (Json.Decode.succeed Foo.Bar.Changes |> (Json.Decode.map2 (|>) (<function>)))
                    _ -> Json.Decode.fail ("Unexpected Foo.Bar.Msg: " ++ word)
            )
                 
-}



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.None") [],CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Some") [ConstructorTypeParam "Foo.Bar.a"]], name = TypeName "Foo.Bar.Option" ["a"] } -}
decodeFooBarOption : (Json.Decode.Decoder (a)) -> Json.Decode.Decoder (Foo.Bar.Option a)
decodeFooBarOption arga =
    Json.Decode.string
        |> Json.Decode.andThen
            (\word ->
                case word of
                    "None" -> (Json.Decode.succeed Foo.Bar.None)
                    "Some" -> (Json.Decode.succeed Foo.Bar.Some |> (Json.Decode.map2 (|>) ((Json.Decode.index 1 (arga)))))
                    _ -> Json.Decode.fail ("Unexpected Foo.Bar.Option: " ++ word)
            )
                 



{-| TypeAliasDef (AliasRecordType (TypeName "Foo.Bar.Payload" []) [CustomField (FieldName "title") (CustomTypeConstructor (TitleCaseDotPhrase "String") []),CustomField (FieldName "author_person") (CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Person") []),CustomField (FieldName "comments") (CustomTypeConstructor (TitleCaseDotPhrase "Maybe") [CustomTypeConstructor (TitleCaseDotPhrase "String") []]),CustomField (FieldName "blob") (CustomTypeConstructor (TitleCaseDotPhrase "Json.Encode.Value") []),CustomField (FieldName "blob2") (CustomTypeConstructor (TitleCaseDotPhrase "Json.Decode.Value") []),CustomField (FieldName "custom_word") (CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Custom_word") [])]) -}
decodeFooBarPayload : Json.Decode.Decoder (Foo.Bar.Payload)
decodeFooBarPayload  =
    Json.Decode.succeed Foo.Bar.Payload
        |> Json.Decode.map2 (|>) (Json.Decode.at [ "title" ] (decodeString))
        |> Json.Decode.map2 (|>) (Json.Decode.at [ "author_person" ] (decodeFooBarPerson))
        |> Json.Decode.map2 (|>) (Json.Decode.oneOf [Json.Decode.at [ "comments" ] (decodeMaybe (decodeString)), Json.Decode.succeed Nothing])
        |> Json.Decode.map2 (|>) (Json.Decode.at [ "blob" ] (decodeJsonEncodeValue))
        |> Json.Decode.map2 (|>) (Json.Decode.at [ "blob2" ] (decodeJsonDecodeValue))
        |> Json.Decode.map2 (|>) (Json.Decode.at [ "custom_word" ] (decodeFooBarCustom_word))



{-| TypeAliasDef (AliasRecordType (TypeName "Foo.Bar.Person" []) [CustomField (FieldName "name") (CustomTypeConstructor (TitleCaseDotPhrase "String") []),CustomField (FieldName "age") (CustomTypeConstructor (TitleCaseDotPhrase "Int") [])]) -}
decodeFooBarPerson : Json.Decode.Decoder (Foo.Bar.Person)
decodeFooBarPerson  =
    Json.Decode.succeed Foo.Bar.Person
        |> Json.Decode.map2 (|>) (Json.Decode.at [ "name" ] (decodeString))
        |> Json.Decode.map2 (|>) (Json.Decode.at [ "age" ] (decodeInt))



{- we cannot auto generate encoder/decoder for unexposed types
{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.PrivateCustom") [CustomTypeConstructor (TitleCaseDotPhrase "Int") []]], name = TypeName "Foo.Bar.PrivateCustom" [] } -}
decodeFooBarPrivateCustom : Json.Decode.Decoder (Foo.Bar.PrivateCustom)
decodeFooBarPrivateCustom  =
    Json.Decode.string
        |> Json.Decode.andThen
            (\word ->
                case word of
                    "PrivateCustom" -> (Json.Decode.succeed Foo.Bar.PrivateCustom |> (Json.Decode.map2 (|>) ( (Json.Decode.index 1 (decodeInt)))))
                    _ -> Json.Decode.fail ("Unexpected Foo.Bar.PrivateCustom: " ++ word)
            )
                 
-}



{- we cannot auto generate encoder/decoder for unexposed types
{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.ProtectedCustom") [CustomTypeConstructor (TitleCaseDotPhrase "Int") []]], name = TypeName "Foo.Bar.ProtectedCustom" [] } -}
decodeFooBarProtectedCustom : Json.Decode.Decoder (Foo.Bar.ProtectedCustom)
decodeFooBarProtectedCustom  =
    Json.Decode.string
        |> Json.Decode.andThen
            (\word ->
                case word of
                    "ProtectedCustom" -> (Json.Decode.succeed Foo.Bar.ProtectedCustom |> (Json.Decode.map2 (|>) ( (Json.Decode.index 1 (decodeInt)))))
                    _ -> Json.Decode.fail ("Unexpected Foo.Bar.ProtectedCustom: " ++ word)
            )
                 
-}



{-| TypeAliasDef (AliasRecordType (TypeName "Foo.Bar.WithTypeVariable" ["a"]) [CustomField (FieldName "meta") (CustomTypeConstructor (TitleCaseDotPhrase "Result") [CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Hello") [ConstructorTypeParam "Foo.Bar.a"],CustomTypeConstructor (TitleCaseDotPhrase "Foo.Bar.Payload") []]),CustomField (FieldName "data") (ConstructorTypeParam "Foo.Bar.a")]) -}
decodeFooBarWithTypeVariable : (Json.Decode.Decoder (a)) -> Json.Decode.Decoder (Foo.Bar.WithTypeVariable a)
decodeFooBarWithTypeVariable arga =
    Json.Decode.succeed Foo.Bar.WithTypeVariable
        |> Json.Decode.map2 (|>) (Json.Decode.at [ "meta" ] (decodeResult (decodeFooBarHello ((arga))) (decodeFooBarPayload)))
        |> Json.Decode.map2 (|>) (Json.Decode.at [ "data" ] ((arga)))