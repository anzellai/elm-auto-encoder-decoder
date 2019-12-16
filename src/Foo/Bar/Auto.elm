module Foo.Bar.Auto exposing (..)

-- imports: Set.fromList []
-- importResolver_: Dict.fromList [("Bool","Bool"),("Choice","Foo.Bar.Choice"),("Dict","Dict.Dict"),("Float","Float"),("Good String Float","Foo.Bar.Good String Float"),("Hello","Foo.Bar.Hello"),("Int","Int"),("List","List"),("List.List","List"),("Maybe","Maybe"),("Maybe.Maybe","Maybe"),("None","Foo.Bar.None"),("Option","Foo.Bar.Option"),("Option Bool","Foo.Bar.Option Bool"),("Payload","Foo.Bar.Payload"),("Person","Foo.Bar.Person"),("Set","Set.Set"),("Some a","Foo.Bar.Some a"),("String","String"),("String.String","String")]
-- file.knownTypes: Dict.fromList [("Choice",ElmTypeAlias (AliasCustomType { constructors = [CustomTypeConstructor "Option Bool"], name = TypeName "Choice" [] })),("Hello",ElmCustomType { constructors = [CustomTypeConstructor "Hello",CustomTypeConstructor "Good String Float"], name = TypeName "Hello" [TypeParam "x"] }),("Option",ElmCustomType { constructors = [CustomTypeConstructor "None",CustomTypeConstructor "Some a"], name = TypeName "Option" [TypeParam "a"] }),("Payload",ElmTypeAlias (AliasRecordType (TypeName "Payload" []) [FieldPair (FieldName "title") (TypeName "String" []),FieldPair (FieldName "author") (TypeName "Person" [])])),("Person",ElmTypeAlias (AliasRecordType (TypeName "Person" []) [FieldPair (FieldName "name") (TypeName "String" []),FieldPair (FieldName "age") (TypeName "Int" [])]))]

import Dict
import Foo.Bar exposing (..)
import Set
import Set
import Dict
import Json.Encode
import Json.Decode
import Json.Decode.Pipeline


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


encodeMaybe : (a -> Json.Encode.Value) -> Maybe a -> Json.Encode.Value
encodeMaybe encodera value =
    Maybe.map encodera value
        |> Maybe.withDefault Json.Encode.null


encodeList : (a -> Json.Encode.Value) -> List a -> Json.Encode.Value
encodeList =
    Json.Encode.list


encodeSetSet : (comparable -> Json.Encode.Value) -> Set.Set comparable -> Json.Encode.Value
encodeSetSet encoder =
    Set.toList >> encodeList encoder


encodeDictDict : (a -> String) -> (b -> Json.Encode.Value) -> (Dict.Dict a b) -> Json.Encode.Value
encodeDictDict =
    Json.Encode.dict


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


decodeMaybe : Json.Decode.Decoder a -> Json.Decode.Decoder (Maybe a)
decodeMaybe =
    Json.Decode.maybe


decodeList : Json.Decode.Decoder a -> Json.Decode.Decoder (List a)
decodeList =
    Json.Decode.list


decodeSetSet : Json.Decode.Decoder comparable -> Json.Decode.Decoder (Set.Set comparable)
decodeSetSet =
    Json.Decode.list >> Json.Decode.map Set.fromList


decodeDictDict : Json.Decode.Decoder a -> Json.Decode.Decoder (Dict.Dict String a)
decodeDictDict =
    Json.Decode.dict



encodeFooBarPerson : Foo.Bar.Person  -> Json.Encode.Value
encodeFooBarPerson value =
    -- ElmTypeAlias (AliasRecordType (TypeName "Foo.Bar.Person" []) [FieldPair (FieldName "name") (TypeName "String" []),FieldPair (FieldName "age") (TypeName "Int" [])])
    Json.Encode.object [("name", (encodeString) value.name), ("age", (encodeInt) value.age)]


encodeFooBarPayload : Foo.Bar.Payload  -> Json.Encode.Value
encodeFooBarPayload value =
    -- ElmTypeAlias (AliasRecordType (TypeName "Foo.Bar.Payload" []) [FieldPair (FieldName "title") (TypeName "String" []),FieldPair (FieldName "author") (TypeName "Foo.Bar.Person" [])])
    Json.Encode.object [("title", (encodeString) value.title), ("author", (encodeFooBarPerson) value.author)]


encodeFooBarOption : (a -> Json.Encode.Value) -> Foo.Bar.Option a -> Json.Encode.Value
encodeFooBarOption encodeArga value =
    -- ElmCustomType { constructors = [CustomTypeConstructor "Foo.Bar.None",CustomTypeConstructor "Some a"], name = TypeName "Foo.Bar.Option" [TypeParam "a"] }
    case value of
        Foo.Bar.Some a -> Json.Encode.list identity [ encodeString "Foo.Bar.Some", encodeArga a]
        Foo.Bar.None  -> Json.Encode.list identity [ encodeString "Foo.Bar.None"]


encodeFooBarHello : (x -> Json.Encode.Value) -> Foo.Bar.Hello x -> Json.Encode.Value
encodeFooBarHello encodeArgx value =
    -- ElmCustomType { constructors = [CustomTypeConstructor "Foo.Bar.Hello",CustomTypeConstructor "Good String Float"], name = TypeName "Foo.Bar.Hello" [TypeParam "x"] }
    case value of
        Foo.Bar.Good string float -> Json.Encode.list identity [ encodeString "Foo.Bar.Good", encodeString string, encodeFloat float]
        Foo.Bar.Hello  -> Json.Encode.list identity [ encodeString "Foo.Bar.Hello"]


encodeFooBarChoice : Foo.Bar.Choice  -> Json.Encode.Value
encodeFooBarChoice value =
    -- ElmTypeAlias (AliasCustomType { constructors = [CustomTypeConstructor "Foo.Bar.Option Bool"], name = TypeName "Foo.Bar.Choice" [] })
    encodeFooBarOption encodeBool value


decodeFooBarPerson : Json.Decode.Decoder (Foo.Bar.Person )
decodeFooBarPerson  =
    -- ElmTypeAlias (AliasRecordType (TypeName "Foo.Bar.Person" []) [FieldPair (FieldName "name") (TypeName "String" []),FieldPair (FieldName "age") (TypeName "Int" [])])
    Json.Decode.succeed Foo.Bar.Person |> (Json.Decode.Pipeline.custom (Json.Decode.at ["name"] (decodeString))) |> (Json.Decode.Pipeline.custom (Json.Decode.at ["age"] (decodeInt)))

decodeFooBarPayload : Json.Decode.Decoder (Foo.Bar.Payload )
decodeFooBarPayload  =
    -- ElmTypeAlias (AliasRecordType (TypeName "Foo.Bar.Payload" []) [FieldPair (FieldName "title") (TypeName "String" []),FieldPair (FieldName "author") (TypeName "Foo.Bar.Person" [])])
    Json.Decode.succeed Foo.Bar.Payload |> (Json.Decode.Pipeline.custom (Json.Decode.at ["title"] (decodeString))) |> (Json.Decode.Pipeline.custom (Json.Decode.at ["author"] (decodeFooBarPerson)))

decodeFooBarOption : Json.Decode.Decoder (a) -> Json.Decode.Decoder (Foo.Bar.Option a)
decodeFooBarOption decodeArga =
    -- ElmCustomType { constructors = [CustomTypeConstructor "Foo.Bar.None",CustomTypeConstructor "Some a"], name = TypeName "Foo.Bar.Option" [TypeParam "a"] }
    Json.Decode.index 0 Json.Decode.string
        |> Json.Decode.andThen
            (\word ->
                case word of
                    "Foo.Bar.Some" -> Json.Decode.succeed Foo.Bar.Some |> Json.Decode.Pipeline.custom (Json.Decode.index 1 decodeArga)
                    "Foo.Bar.None" -> Json.Decode.succeed Foo.Bar.None
                    _ ->
                        Json.Decode.fail ("Unexpected Foo.Bar.Option: " ++ word)
            )
            

decodeFooBarHello : Json.Decode.Decoder (x) -> Json.Decode.Decoder (Foo.Bar.Hello x)
decodeFooBarHello decodeArgx =
    -- ElmCustomType { constructors = [CustomTypeConstructor "Foo.Bar.Hello",CustomTypeConstructor "Good String Float"], name = TypeName "Foo.Bar.Hello" [TypeParam "x"] }
    Json.Decode.index 0 Json.Decode.string
        |> Json.Decode.andThen
            (\word ->
                case word of
                    "Foo.Bar.Good" -> Json.Decode.succeed Foo.Bar.Good |> Json.Decode.Pipeline.custom (Json.Decode.index 1 decodeString) |> Json.Decode.Pipeline.custom (Json.Decode.index 2 decodeFloat)
                    "Foo.Bar.Hello" -> Json.Decode.succeed Foo.Bar.Hello
                    _ ->
                        Json.Decode.fail ("Unexpected Foo.Bar.Hello: " ++ word)
            )
            

decodeFooBarChoice : Json.Decode.Decoder (Foo.Bar.Choice )
decodeFooBarChoice  =
    -- ElmTypeAlias (AliasCustomType { constructors = [CustomTypeConstructor "Foo.Bar.Option Bool"], name = TypeName "Foo.Bar.Choice" [] })
    decodeFooBarOption decodeBool