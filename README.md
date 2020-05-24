# Mobile Version of Boostnote

> *A markdown editor for iOS and Android*    

This project provides a mobile version of [Boostnote](https://github.com/BoostIO/Boostnote) and was created as part of my bachelor project at university.  
The app is written in [Flutter](https://flutter.io). Flutter allows you to build native apps on iOS and Android Platforms from a single codebase.

## Preview
<img align="left" src="/imagesApp/NoteOverviewBlack.jpeg" width="30%">
<img src="/imagesApp/CodeBlack.jpeg" width="30%">
<img align="left" src="/imagesApp/NoteEditorBlack.jpeg" width="30%">
<img src="/imagesApp/NotePrevBlack.jpeg" width="30%">


## Installation

1. [Install Flutter](https://flutter.dev/docs/get-started/install)
2. Clone the repo 
3. Run `flutter run` (make sure to have an emulator running or device connected)

## Whats's next?
The app is still in development. Stuff that needs to get done:  
- Improving the parser for parsing cson
- Improving test coverage
- Improving the markdown editor itself. Currently using [flutter_markdown](https://github.com/flutter/flutter_markdown), but there are some performance issues with this renderer and it doesn't support inline html

## Storage
Notes are stored in the filesystem under `/Android/data/com.example.boostnote_mobile/files` as cson files

## Contributions
I gladly accept contributions! If you'd like to get involved with development please contact me :)

## Some more images
<img align="left" src="/imagesApp/NoteOverview.jpeg" width="30%">
<img src="/imagesApp/CodeSnippet.jpeg" width="30%">
<img align="left" src="/imagesApp/NoteEditor.jpeg" width="30%">
<img src="/imagesApp/NotePrev.jpeg" width="30%">
<img src="/imagesApp/Tablet.jpeg" >
