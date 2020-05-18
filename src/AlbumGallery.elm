module AlbumGallery exposing (main)

import Browser
import Gallery exposing (..)
import Gallery.Image as Image
import Html exposing (..)
import Html.Attributes exposing (..)


type alias Model =
    { gallery : Gallery.State
    , data : List Album
    }


type alias Album =
    { artists : String
    , image_url : String
    , name : String
    , external_url : String
    , copyright : String
    }


init : List Album -> ( Model, Cmd Msg )
init flags =
    ( { gallery = Gallery.init (List.length flags)
      , data = flags
      }
    , Cmd.none
    )


type Msg
    = GalleryMsg Gallery.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GalleryMsg galleryMsg ->
            ( { model | gallery = Gallery.update galleryMsg model.gallery }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    Html.map GalleryMsg <|
        Gallery.view config model.gallery [ Gallery.Arrows ] (slides model.data)


slides : List Album -> List ( String, Html msg )
slides data =
    List.map
        (\album ->
            ( album.name
            , slidify album
            )
        )
        data


simpleClassList : List String -> Html.Attribute msg
simpleClassList classes =
    classList (List.map (\class -> ( class, True )) classes)


slidify : Album -> Html msg
slidify album =
    div [ simpleClassList [ "album-card" ] ]
        [ a [ href album.external_url ]
            [ img
                [ simpleClassList [ "mb-2", "album-image" ]
                , src album.image_url
                , attribute "loading" "lazy"
                , alt album.name
                , style "width" "60%"
                , style "height" "60%"
                ]
                []
            ]
        , h2 [ simpleClassList [ "h2", "mb-1", "font-weight-normal", "w-75" ] ]
            [ text album.name
            ]
        , h5 [ simpleClassList [ "h5", "mb-1", "font-weight-normal", "w-75" ] ]
            [ text album.artists
            ]
        , p [ simpleClassList [ "mb-1", "text-muted", "w-75" ] ]
            [ text album.copyright
            ]
        ]


config : Gallery.Config
config =
    Gallery.config
        { id = "gallery"
        , transition = 500
        , width = Gallery.pct 100
        , height = Gallery.pct 100
        }


main : Program (List Album) Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
