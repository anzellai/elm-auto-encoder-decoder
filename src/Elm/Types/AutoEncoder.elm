module Elm.Types.AutoEncoder exposing (decoderDefinitions, encoderDefinitions, produceSourceCode)

import Dict exposing (Dict)
import Elm.Types exposing (..)
import Elm.Types.Parser exposing (..)
import Json.Decode
import Json.Encode
import Parser
import Set exposing (Set)


templateHeader =
    """module {parentModuleName}.Auto exposing (..)


{- this file is generated by <https://github.com/choonkeat/elm-auto-encoder-decoder> do not modify manually -}


import {parentModuleName} exposing (..)
{imports}


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
    Json.Encode.dict (\\k -> Json.Encode.encode 0 (keyEncoder k))


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
        |> Json.Decode.map (\\dict ->
            Dict.foldl (\\string v acc ->
                case Json.Decode.decodeString keyDecoder string of
                    Ok k ->
                        Dict.insert k v acc
                    Err _ ->
                        acc
            ) Dict.empty dict
        )

-- PRELUDE


{prelude}


"""


templateFunctionDefinition =
    """{debug}{functionName} : {typeSignature}
{functionName} {functionArgument} ={functionBody}"""


applyTemplate :
    { debug : String
    , template : String
    , functionName : String
    , typeSignature : String
    , functionArgument : String
    , functionBody : String
    }
    -> String
applyTemplate { debug, template, functionName, typeSignature, functionArgument, functionBody } =
    template
        |> String.replace "{debug}" debug
        |> String.replace "{functionName}" functionName
        |> String.replace "{typeSignature}" typeSignature
        |> String.replace "{functionBody}" functionBody
        |> String.replace "{functionArgument}" functionArgument


typeFunctionName : String -> TypeName -> String
typeFunctionName funcPrefix (TypeName s list) =
    funcPrefix ++ sanitizeTitleCaseDotPhrase s ++ String.join "" (List.filter (not << isTypeParameter) list)


sourceFromTypeName : TypeName -> String
sourceFromTypeName (TypeName s list) =
    String.join " " (s :: list)


constructorFunctionName : String -> CustomTypeConstructor -> String
constructorFunctionName funcPrefix ct =
    let
        str =
            case ct of
                CustomTypeConstructor (TitleCaseDotPhrase s) ctList ->
                    (funcPrefix ++ sanitizeTitleCaseDotPhrase s)
                        :: List.map (constructorFunctionName funcPrefix) ctList
                        |> String.join " "

                ConstructorTypeParam s ->
                    "funcArg" ++ s

                Tuple2 ct0 ct1 ->
                    constructorFunctionName funcPrefix ct0
                        ++ ", "
                        ++ constructorFunctionName funcPrefix ct1

                Tuple3 ct0 ct1 ct2 ->
                    constructorFunctionName funcPrefix ct0
                        ++ ", "
                        ++ constructorFunctionName funcPrefix ct1
                        ++ ", "
                        ++ constructorFunctionName funcPrefix ct2

                Function argType returnType ->
                    constructorFunctionName funcPrefix argType ++ constructorFunctionName "" returnType
    in
    "(" ++ str ++ ")"


jsonString : String -> String
jsonString str =
    Json.Encode.encode 0 (Json.Encode.string str)


produceSourceCode : String -> ElmFile -> String
produceSourceCode prelude file =
    let
        parentModuleName =
            String.dropRight 1 file.modulePrefix

        givenImports =
            Set.union file.imports
                (Set.fromList
                    [ "Json.Encode"
                    , "Json.Decode"
                    , "Json.Decode.Pipeline"
                    , "Set"
                    ]
                )

        sourceHeader =
            templateHeader
                |> String.replace "{parentModuleName}" parentModuleName
                |> String.replace "{imports}" (sourceFromImports parentModuleName givenImports file.importResolver)
                |> String.replace "{prelude}" prelude
    in
    sourceHeader
        ++ "\n\n"
        ++ encoderDefinitions file
        ++ "\n\n"
        ++ decoderDefinitions file


sourceFromImports : String -> Set String -> Dict String String -> String
sourceFromImports modulePrefix modules dict =
    -- |> (\s -> s ++ "\n\n\n{- importResolver: " ++ Json.Encode.encode 2 (Json.Encode.dict identity Json.Encode.string dict) ++ " -}")
    Set.fromList (Dict.values dict)
        |> Set.map (String.split ".")
        |> Set.map (\list -> String.join "." (List.take (List.length list - 1) list))
        |> Set.filter (\s -> s /= "" && not (String.startsWith modulePrefix s))
        |> Set.union modules
        |> Set.map (\m -> "import " ++ m)
        |> Set.toList
        |> String.join "\n"



-- ENCODERS


encoderDefinitions : ElmFile -> String
encoderDefinitions file =
    file.knownTypes
        |> Dict.values
        |> List.map encoderDefinition
        |> String.join "\n\n\n\n"


encoderDefinition : ElmTypeDef -> String
encoderDefinition elmTypeDef =
    let
        code =
            case elmTypeDef of
                CustomTypeDef { name, constructors } ->
                    applyTemplate
                        { template = templateFunctionDefinition
                        , functionName = typeFunctionName "encode" name
                        , typeSignature = encoderTypeSignature elmTypeDef
                        , functionArgument = encoderFunctionArguments elmTypeDef
                        , functionBody = "\n    " ++ String.join "\n    " (encoderBodyOf elmTypeDef)
                        , debug = "{-| " ++ Debug.toString elmTypeDef ++ " -}\n"
                        }

                TypeAliasDef (AliasRecordType name fieldPairs) ->
                    applyTemplate
                        { template = templateFunctionDefinition
                        , functionName = typeFunctionName "encode" name
                        , typeSignature = encoderTypeSignature elmTypeDef
                        , functionArgument = encoderFunctionArguments elmTypeDef
                        , functionBody = "\n    " ++ String.join "\n    " (encoderBodyOf elmTypeDef)
                        , debug = "{-| " ++ Debug.toString elmTypeDef ++ " -}\n"
                        }

                TypeAliasDef (AliasCustomType name ct) ->
                    applyTemplate
                        { template = templateFunctionDefinition
                        , functionName = typeFunctionName "encode" name
                        , typeSignature = encoderTypeSignature elmTypeDef
                        , functionArgument = encoderFunctionArguments elmTypeDef
                        , functionBody = "\n    " ++ String.join "\n    " (encoderBodyOf elmTypeDef)
                        , debug = "{-| " ++ Debug.toString elmTypeDef ++ " -}\n"
                        }
    in
    if containFunctionElmTypeDef elmTypeDef then
        "{- functions cannot be encoded/decoded into json\n" ++ code ++ "\n-}"

    else
        code


encoderTypeSignature : ElmTypeDef -> String
encoderTypeSignature elmTypeDef =
    let
        typeSignatures ((TypeName s list) as tname) =
            List.append
                (List.map (\word -> "(" ++ word ++ " -> Json.Encode.Value)") list)
                [ sourceFromTypeName tname, "Json.Encode.Value" ]
    in
    case elmTypeDef of
        CustomTypeDef { name, constructors } ->
            String.join " -> " (typeSignatures name)

        TypeAliasDef (AliasRecordType name fieldPairs) ->
            String.join " -> " (typeSignatures name)

        TypeAliasDef (AliasCustomType name ct) ->
            String.join " -> " (typeSignatures name)


encoderFunctionArguments : ElmTypeDef -> String
encoderFunctionArguments elmTypeDef =
    let
        functionArguments ((TypeName s list) as tname) =
            List.append
                (List.indexedMap (\i word -> "funcArg" ++ word) list)
                [ "value" ]
    in
    case elmTypeDef of
        CustomTypeDef { name, constructors } ->
            String.join " " (functionArguments name)

        TypeAliasDef (AliasRecordType name fieldPairs) ->
            String.join " " (functionArguments name)

        TypeAliasDef (AliasCustomType name ct) ->
            String.join " " (functionArguments name)


encoderBodyOf : ElmTypeDef -> List String
encoderBodyOf elmTypeDef =
    case elmTypeDef of
        CustomTypeDef { name, constructors } ->
            constructors
                |> List.indexedMap (encoderPatternMatches "m")
                |> List.map (\s -> "    " ++ s)
                |> List.append [ "case value of" ]

        TypeAliasDef (AliasRecordType _ fieldPairs) ->
            encoderBodyOfFieldPairList "value" fieldPairs

        TypeAliasDef (AliasCustomType name ct) ->
            [ constructorFunctionName "encode" ct ++ " value" ]


encoderPatternMatchesLHS : String -> Int -> CustomTypeConstructor -> String
encoderPatternMatchesLHS varPrefix index constructor =
    let
        str =
            case constructor of
                CustomTypeConstructor (TitleCaseDotPhrase s) list ->
                    String.join " " (s :: List.indexedMap (\i _ -> varPrefix ++ String.fromInt i) list)

                ConstructorTypeParam s ->
                    varPrefix ++ String.fromInt index

                Tuple2 ct0 ct1 ->
                    varPrefix ++ "0, " ++ varPrefix ++ "1"

                Tuple3 ct0 ct1 ct2 ->
                    varPrefix ++ "0, " ++ varPrefix ++ "1, " ++ varPrefix ++ "2"

                Function argType returnType ->
                    -- ABORT
                    "<function>"
    in
    "(" ++ str ++ ")"


encoderPatternMatchesRHS : String -> Int -> CustomTypeConstructor -> String
encoderPatternMatchesRHS varPrefix index constructor =
    let
        str =
            case constructor of
                CustomTypeConstructor (TitleCaseDotPhrase s) list ->
                    let
                        rhs =
                            ("encodeString " ++ jsonString s)
                                :: List.indexedMap (encoderSourceFromCustomTypeConstructor varPrefix) list
                                |> String.join ", "
                    in
                    "Json.Encode.list identity [ " ++ rhs ++ " ]"

                ConstructorTypeParam s ->
                    varPrefix ++ String.fromInt index

                Tuple2 ct0 ct1 ->
                    "(" ++ varPrefix ++ "0, " ++ varPrefix ++ "1)"

                Tuple3 ct0 ct1 ct2 ->
                    "(" ++ varPrefix ++ "0, " ++ varPrefix ++ "1, " ++ varPrefix ++ "2)"

                Function argType returnType ->
                    -- ABORT
                    "<function>"
    in
    "(" ++ str ++ ")"


encoderPatternMatches : String -> Int -> CustomTypeConstructor -> String
encoderPatternMatches varPrefix index constructor =
    encoderPatternMatchesLHS varPrefix index constructor ++ " -> " ++ encoderPatternMatchesRHS varPrefix index constructor


encoderSourceFromCustomTypeConstructor : String -> Int -> CustomTypeConstructor -> String
encoderSourceFromCustomTypeConstructor varPrefix i constructor =
    let
        str =
            case constructor of
                CustomTypeConstructor (TitleCaseDotPhrase s) list ->
                    let
                        encodeParams =
                            List.indexedMap (encoderSourceFromCustomTypeConstructor "") list
                    in
                    if varPrefix == "" then
                        ("encode" ++ sanitizeTitleCaseDotPhrase s)
                            :: encodeParams
                            |> String.join " "

                    else
                        (("encode" ++ sanitizeTitleCaseDotPhrase s) :: List.append encodeParams [ varPrefix ++ String.fromInt i ])
                            |> String.join " "

                ConstructorTypeParam s ->
                    if varPrefix == "" then
                        "funcArg" ++ s

                    else
                        "funcArg" ++ s ++ " " ++ varPrefix ++ String.fromInt i

                Tuple2 ct0 ct1 ->
                    encoderSourceFromCustomTypeConstructor varPrefix 0 ct0
                        ++ ", "
                        ++ encoderSourceFromCustomTypeConstructor varPrefix 1 ct1

                Tuple3 ct0 ct1 ct2 ->
                    encoderSourceFromCustomTypeConstructor varPrefix 0 ct0
                        ++ ", "
                        ++ encoderSourceFromCustomTypeConstructor varPrefix 1 ct1
                        ++ ", "
                        ++ encoderSourceFromCustomTypeConstructor varPrefix 2 ct2

                Function argType returnType ->
                    -- ABORT
                    "<function>"
    in
    "(" ++ str ++ ")"


encoderBodyOfFieldPairList : String -> List FieldPair -> List String
encoderBodyOfFieldPairList variable fieldPairList =
    List.map (encoderBodyOfFieldPair variable) fieldPairList
        |> List.indexedMap
            (\i row ->
                if i == 0 then
                    "    [ " ++ row

                else
                    "    , " ++ row
            )
        |> (\rows -> List.append ("Json.Encode.object" :: rows) [ "    ]" ])


encoderBodyOfFieldPair : String -> FieldPair -> String
encoderBodyOfFieldPair variable fieldPair =
    case fieldPair of
        CustomField (FieldName fname) ct ->
            "("
                ++ jsonString fname
                ++ ", "
                ++ encoderSourceFromCustomTypeConstructor "" 0 ct
                ++ " "
                ++ variable
                ++ "."
                ++ fname
                ++ ")"

        NestedField (FieldName fname) fieldPairList ->
            "("
                ++ jsonString fname
                ++ ", "
                ++ String.join " " (encoderBodyOfFieldPairList (variable ++ "." ++ fname) fieldPairList)
                ++ ")"



-- DECODER


decoderDefinitions : ElmFile -> String
decoderDefinitions file =
    file.knownTypes
        |> Dict.values
        |> List.map decoderDefinition
        |> String.join "\n\n\n\n"


decoderDefinition : ElmTypeDef -> String
decoderDefinition elmTypeDef =
    let
        code =
            case elmTypeDef of
                CustomTypeDef { name, constructors } ->
                    applyTemplate
                        { template = templateFunctionDefinition
                        , functionName = typeFunctionName "decode" name
                        , typeSignature = decoderTypeSignature elmTypeDef
                        , functionArgument = decoderFunctionArguments elmTypeDef
                        , functionBody = "\n    " ++ String.join "\n    " (decoderBodyOf elmTypeDef)
                        , debug = "{-| " ++ Debug.toString elmTypeDef ++ " -}\n"
                        }

                TypeAliasDef (AliasRecordType name fieldPairs) ->
                    applyTemplate
                        { template = templateFunctionDefinition
                        , functionName = typeFunctionName "decode" name
                        , typeSignature = decoderTypeSignature elmTypeDef
                        , functionArgument = decoderFunctionArguments elmTypeDef
                        , functionBody = "\n    " ++ String.join "\n    " (decoderBodyOf elmTypeDef)
                        , debug = "{-| " ++ Debug.toString elmTypeDef ++ " -}\n"
                        }

                TypeAliasDef (AliasCustomType name ct) ->
                    applyTemplate
                        { template = templateFunctionDefinition
                        , functionName = typeFunctionName "decode" name
                        , typeSignature = decoderTypeSignature elmTypeDef
                        , functionArgument = decoderFunctionArguments elmTypeDef
                        , functionBody = "\n    " ++ String.join "\n    " (decoderBodyOf elmTypeDef)
                        , debug = "{-| " ++ Debug.toString elmTypeDef ++ " -}\n"
                        }
    in
    if containFunctionElmTypeDef elmTypeDef then
        "{- functions cannot be encoded/decoded into json\n" ++ code ++ "\n-}"

    else
        code


decoderTypeSignature : ElmTypeDef -> String
decoderTypeSignature elmTypeDef =
    let
        typeSignatures ((TypeName s list) as tname) =
            List.append
                (List.map (\word -> "(Json.Decode.Decoder (" ++ word ++ "))") list)
                [ "Json.Decode.Decoder (" ++ sourceFromTypeName tname ++ ")" ]
    in
    case elmTypeDef of
        CustomTypeDef { name, constructors } ->
            String.join " -> " (typeSignatures name)

        TypeAliasDef (AliasRecordType name fieldPairs) ->
            String.join " -> " (typeSignatures name)

        TypeAliasDef (AliasCustomType name ct) ->
            String.join " -> " (typeSignatures name)


decoderFunctionArguments : ElmTypeDef -> String
decoderFunctionArguments elmTypeDef =
    let
        functionArguments ((TypeName s list) as tname) =
            List.indexedMap (\i word -> "funcArg" ++ word) list
    in
    case elmTypeDef of
        CustomTypeDef { name, constructors } ->
            String.join " " (functionArguments name)

        TypeAliasDef (AliasRecordType name fieldPairs) ->
            String.join " " (functionArguments name)

        TypeAliasDef (AliasCustomType name ct) ->
            String.join " " (functionArguments name)


decoderBodyOf : ElmTypeDef -> List String
decoderBodyOf elmTypeDef =
    case elmTypeDef of
        CustomTypeDef { name, constructors } ->
            let
                (TypeName tname list) =
                    name

                cases =
                    constructors
                        |> List.map decoderPatternMatches
                        |> List.map (\s -> "                " ++ s)
            in
            List.append
                ("""Json.Decode.index 0 Json.Decode.string
        |> Json.Decode.andThen
            (\\word ->
                case word of""" :: cases)
                [ """                _ -> Json.Decode.fail ("Unexpected """ ++ tname ++ """: " ++ word)
            )
                 """ ]

        TypeAliasDef (AliasRecordType (TypeName tname list) fieldPairs) ->
            ("Json.Decode.succeed " ++ tname)
                :: List.map (\s -> "    |> " ++ s) (List.indexedMap decoderBodyOfFieldPair fieldPairs)

        TypeAliasDef (AliasCustomType name ct) ->
            [ constructorFunctionName "decode" ct ]


decoderPatternMatchesLHS : CustomTypeConstructor -> String
decoderPatternMatchesLHS constructor =
    case constructor of
        CustomTypeConstructor (TitleCaseDotPhrase s) list ->
            jsonString s

        ConstructorTypeParam s ->
            """-- varPrefix ++ String.fromInt index"""

        Tuple2 ct0 ct1 ->
            """-- varPrefix ++ "0, " ++ varPrefix ++ "1" """

        Tuple3 ct0 ct1 ct2 ->
            """-- varPrefix ++ "0, " ++ varPrefix ++ "1, " ++ varPrefix ++ "2" """

        Function argType returnType ->
            -- ABORT
            "<function>"


decoderPatternMatchesRHS : CustomTypeConstructor -> String
decoderPatternMatchesRHS constructor =
    let
        str =
            case constructor of
                CustomTypeConstructor (TitleCaseDotPhrase s) list ->
                    ("Json.Decode.succeed " ++ s)
                        :: List.indexedMap (decoderSourceFromCustomTypeConstructor True) list
                        |> String.join " |> "

                ConstructorTypeParam s ->
                    "funcArg" ++ s

                Tuple2 ct0 ct1 ->
                    "(" ++ decoderPatternMatchesRHS ct0 ++ ", " ++ decoderPatternMatchesRHS ct1 ++ ")"

                Tuple3 ct0 ct1 ct2 ->
                    "(" ++ decoderPatternMatchesRHS ct0 ++ ", " ++ decoderPatternMatchesRHS ct1 ++ ", " ++ decoderPatternMatchesRHS ct2 ++ ")"

                Function argType returnType ->
                    -- ABORT
                    "<function>"
    in
    "(" ++ str ++ ")"


decoderPatternMatches : CustomTypeConstructor -> String
decoderPatternMatches constructor =
    decoderPatternMatchesLHS constructor ++ " -> " ++ decoderPatternMatchesRHS constructor


decoderSourceFromCustomTypeConstructor : Bool -> Int -> CustomTypeConstructor -> String
decoderSourceFromCustomTypeConstructor pipelining index constructor =
    let
        str =
            case constructor of
                CustomTypeConstructor (TitleCaseDotPhrase s) list ->
                    let
                        decodeParams =
                            List.indexedMap (decoderSourceFromCustomTypeConstructor False) list
                    in
                    ("decode" ++ sanitizeTitleCaseDotPhrase s)
                        :: decodeParams
                        |> String.join " "

                ConstructorTypeParam s ->
                    "funcArg" ++ s

                Tuple2 ct0 ct1 ->
                    decoderSourceFromCustomTypeConstructor pipelining 0 ct0
                        ++ ", "
                        ++ decoderSourceFromCustomTypeConstructor pipelining 1 ct1

                Tuple3 ct0 ct1 ct2 ->
                    decoderSourceFromCustomTypeConstructor pipelining 0 ct0
                        ++ ", "
                        ++ decoderSourceFromCustomTypeConstructor pipelining 1 ct1
                        ++ ", "
                        ++ decoderSourceFromCustomTypeConstructor pipelining 2 ct2

                Function argType returnType ->
                    -- ABORT
                    "<function>"
    in
    if pipelining then
        "(Json.Decode.Pipeline.custom (Json.Decode.index " ++ String.fromInt (index + 1) ++ " (" ++ str ++ ")))"

    else
        "(" ++ str ++ ")"


decoderBodyOfFieldPairList : String -> List FieldPair -> List String
decoderBodyOfFieldPairList variable fieldPairList =
    List.indexedMap decoderBodyOfFieldPair fieldPairList
        |> List.indexedMap
            (\i row ->
                if i == 0 then
                    "    [ " ++ row

                else
                    "    , " ++ row
            )
        |> (\rows -> List.append ("Json.Encode.object" :: rows) [ "    ]" ])


decoderBodyOfFieldPair : Int -> FieldPair -> String
decoderBodyOfFieldPair index fieldPair =
    case fieldPair of
        CustomField (FieldName fname) ct ->
            "Json.Decode.Pipeline.custom (Json.Decode.at [ "
                ++ jsonString fname
                ++ " ] "
                ++ decoderSourceFromCustomTypeConstructor False index ct
                ++ ")"

        NestedField (FieldName fname) fieldPairList ->
            "Json.Decode.Pipeline.custom (Json.Decode.at [ "
                ++ jsonString fname
                ++ " ] "
                ++ "("
                ++ String.join " |> " (decoderBodyOfFieldPairList "" fieldPairList)
                ++ ")"
                ++ ")"


sanitizeTitleCaseDotPhrase : String -> String
sanitizeTitleCaseDotPhrase =
    String.replace "." ""
