
import 'dart:math';

import 'package:boostnote_mobile/data/model/MarkdownNote.dart';
import 'package:boostnote_mobile/data/model/Note.dart';
import 'package:boostnote_mobile/data/model/SnippetNote.dart';

class DummyDataGenerator {

  List<Note> generateNotes(int number){

    if(number < 0){
      throw new Exception('Number must not be negative!');
    }

    List<Note> data = new List();
    Random random = new Random();
    
    for(int i = 0; i < number; i++){
      int randomNum = random.nextInt(2);
      Note note;

      if(randomNum == 1){
        note = generateMarkdownNote();
      } else {
         note = generateSnippetNode();
      }

      data.add(note);
    }

    return data;
  }

  SnippetNode generateMarkdownNote(){

    String content = 'public static void main(String[] args) throws Exception{ \n System.out.println( "" ); \n try{ \n if ( args == null || args.length != 4 )';

    CodeSnippet codeSnippet = new CodeSnippet(linesHighlighted: new List(),
                                              name: 'Code Snippet',
                                              mode: 'DART',
                                              content: content);
    String description = 'lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.';

    return new SnippetNode(createdAt: new DateTime.now(),
                                        updatedAt: new DateTime.now(),
                                        folder: 'Folder2',
                                        title: 'Snippet Note',
                                        tags: ['Tag1'],
                                        isStarred: true,
                                        isTrashed: false,
                                        description: description,
                                        codeSnippets: [codeSnippet]
                                        );
  }

  
  MarkdownNote generateSnippetNode(){

    String content = 'lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';
    
    return new MarkdownNote(createdAt: new DateTime.now(),
                                        updatedAt: new DateTime.now(),
                                        folder: 'Folder1',
                                        title: 'Markdown Note',
                                        tags: ['Tag1, Tag2'],
                                        isStarred: false,
                                        isTrashed: false,
                                        content: content
                                        );
  }
}
