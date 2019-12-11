
import 'dart:math';

import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/business_logic/repository/NoteRepository.dart';
import 'package:boostnote_mobile/data/repositoryImpl/mock/MockNoteRepository.dart';

class NoteService {

  NoteRepository noteRepository = MockNoteRepository();

  List<Note> findAll() {
    return noteRepository.findAll();
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
        note = generateSnippetNode();
      }

      _notes.add(note);
    }

    noteRepository.saveAll(_notes);
    return _notes;
  }

  SnippetNote generateMarkdownNote(){

    String content = 'public static void main(String[] args) throws Exception{ \n System.out.println( "" ); \n try{ \n if ( args == null || args.length != 4 ) \n }}';

    CodeSnippet codeSnippet = CodeSnippet(linesHighlighted: List(),
                                              name: 'Code',
                                              mode: 'java',
                                              content: content);
    String description = 'lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.';

    return SnippetNote(createdAt: DateTime.now(),
                                        updatedAt: DateTime.now(),
                                        folder: 'Folder2',
                                        title: 'Snippet Note',
                                        tags: ['#Tag1'],
                                        isStarred: true,
                                        isTrashed: false,
                                        description: description,
                                        codeSnippets: [codeSnippet, codeSnippet, codeSnippet, codeSnippet]
                                        );
  }

  
  MarkdownNote generateSnippetNode(){

    String content = 'lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';
    
    return MarkdownNote(createdAt: DateTime.now(),
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