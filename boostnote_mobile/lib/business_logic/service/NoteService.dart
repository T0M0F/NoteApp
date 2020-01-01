
import 'dart:math';

import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/business_logic/repository/NoteRepository.dart';
import 'package:boostnote_mobile/data/repositoryImpl/mock/MockNoteRepository.dart';
import 'package:boostnote_mobile/data/repositoryImpl/NoteRepositoryImpl.dart';

class NoteService {

  NoteRepository noteRepository = NoteRepositoryImpl();

  List<Note> findAll() {
    return noteRepository.findAll();
  }

  List<Note> findStarred(){ //TODO unelegant
    List<Note> notes = noteRepository.findAll();
    List<Note> starredNotes = List();
      notes.forEach((note) {
        if(note.isStarred) {
          starredNotes.add(note);
        }
    });
    return starredNotes;
  }

  List<Note> findTrashed(){   //TODO unelegant
    List<Note> notes = noteRepository.findAll();
    List<Note> trashedNotes = List();
      notes.forEach((note) {
        if(note.isStarred) {
          trashedNotes.add(note);
        }
    });
    return trashedNotes;
  }

  void save(Note note) {
    noteRepository.save(note);
  }

  void saveAll(List<Note> notes) {
    noteRepository.saveAll(notes);
  }

  void delete(Note note) {
    noteRepository.delete(note);
  }

  void deleteAll(List<Note> notes) {
    noteRepository.deleteAll(notes);
  }

  List<Note> generateNotes(int number){

    if(number < 0){
      throw Exception('Number must not be negative!');
    }

    List<Note> _notes = List();
    Random random = Random();
    
    for(int i = 0; i < number; i++){
      int randomNum = random.nextInt(2);
      Note note;

      if(randomNum == 1){
        note = generateMarkdownNote();
      } else {
        note = generateSnippetNote();
      }

      _notes.add(note);
    }

    noteRepository.saveAll(_notes);
    return _notes;
  }

  SnippetNote generateSnippetNote(){

    String content1 = 'public static void main(String[] args) throws Exception{ \n System.out.println( "" ); \n try{ \n if ( args == null || args.length != 4 ) \n }}';
    CodeSnippet codeSnippet1 = CodeSnippet(linesHighlighted: List(),
                                              name: 'Code',
                                              mode: 'java',
                                              content: content1);

    String content2 = 'x = 1 \n y = 35656222554887711 \n z = -3255522 \n print(type(x)) \n print(type(y)) \n print(type(z))';
    CodeSnippet codeSnippet2 = CodeSnippet(linesHighlighted: List(),
                                              name: 'Code',
                                              mode: 'python',
                                              content: content2);

    String content3 = 'function whatIsToday(){ \n echo "Today is " . date('', mktime()); \n }';
    CodeSnippet codeSnippet3 = CodeSnippet(linesHighlighted: List(),
                                              name: 'Code',
                                              mode: 'php',
                                              content: content3);

    String content4 = 'var name = \'Voyager I\'; \n var year = 1977; \n var antennaDiameter = 3.7; \n var flybyObjects = [\'Jupiter\', \'Saturn\', \'Uranus\', \'Neptune\']; ';
    CodeSnippet codeSnippet4 = CodeSnippet(linesHighlighted: List(),
                                              name: 'Code',
                                              mode: 'dart',
                                              content: content4);


    String description = 'lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.';

    return SnippetNote(id: DateTime.now().hashCode,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                      folder: 'Folder2',
                      title: 'Snippet Note',
                      tags: ['#Tag1'],
                      isStarred: true,
                      isTrashed: false,
                      description: description,
                      codeSnippets: [codeSnippet1, codeSnippet2, codeSnippet3, codeSnippet4]
                      );
  }

  
  MarkdownNote generateMarkdownNote(){

    String content = """
# Markdown Example
Markdown allows you to easily include formatted text, images, and even formatted Dart code in your app.
## Titles
Setext-style
```
This is an H1
=============
This is an H2
-------------
```
Atx-style
```
# This is an H1
## This is an H2
###### This is an H6
```
Select the valid headers:
- [x] `# hello`
- [ ] `#hello`
## Links
[Google's Homepage][Google]
```
[inline-style](https://www.google.com)
[reference-style][Google]
```
## Images
![Flutter logo](/dart-lang/site-shared/master/src/_assets/image/flutter/icon/64.png)
## Tables
|Syntax                                 |Result                               |
|---------------------------------------|-------------------------------------|
|`*italic 1*`                           |*italic 1*                           |
|`_italic 2_`                           | _italic 2_                          |
|`**bold 1**`                           |**bold 1**                           |
|`__bold 2__`                           |__bold 2__                           |
|`This is a ~~strikethrough~~`          |This is a ~~strikethrough~~          |
|`***italic bold 1***`                  |***italic bold 1***                  |
|`___italic bold 2___`                  |___italic bold 2___                  |
|`***~~italic bold strikethrough 1~~***`|***~~italic bold strikethrough 1~~***|
|`~~***italic bold strikethrough 2***~~`|~~***italic bold strikethrough 2***~~|
## Styling
Style text as _italic_, __bold__, ~~strikethrough~~, or `inline code`.
- Use bulleted lists
- To better clarify
- Your points
## Code blocks
Formatted Dart code looks really pretty too:
```
void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: Markdown(data: markdownData),
    ),
  ));
}
```
## Markdown widget
This is an example of how to create your own Markdown widget:
    Markdown(data: 'Hello _world_!');
Enjoy!
[Google]: https://www.google.com/
""";
    
    return MarkdownNote(id: DateTime.now().hashCode,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime(2017,02,28),
                        folder: 'Folder1',
                        title: 'Markdown Note',
                        tags: ['#Tag1' , '#Tag2'],
                        isStarred: false,
                        isTrashed: false,
                        content: content
                        );
  }
  
}