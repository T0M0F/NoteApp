import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/business_logic/repository/FolderRepository.dart';
import 'package:boostnote_mobile/data/repositoryImpl/jsonImpl/FolderRepositoryImpl.dart';

class CsonConverter {

  FolderRepository folderRepository;

  CsonConverter({this.folderRepository});
  
  Future<Note> convertToNote(Map<String, dynamic> map) async {
    if(folderRepository == null) {
      folderRepository = FolderRepositoryImpl();
    }
    Note note;

    if(map['type'] == 'SNIPPET_NOTE') {
      note = SnippetNote(
        createdAt:  DateTime.parse(map['createdAt']),
        updatedAt:   DateTime.parse(map['updatedAt']),
        id: map['id'],
        title: map['title'],
        description: map['description'],
        folder: await folderRepository.findById(map['folder']),  
        isStarred: 'true' == map['isStarred'],
        isTrashed: 'true' == map['isTrashed'],
        tags:  List<String>.from(map['tags']), 
        codeSnippets: List<Map<String,dynamic>>.from(map['snippets']).map((snippetMap) => CodeSnippet(
            content: snippetMap['content'],
            mode: snippetMap['mode'],
            name: snippetMap['name'],
            linesHighlighted: List<String>.from(snippetMap['linesHighlighted']).map((string) => int.parse(string)).toList()
        )).toList()
      );
    } else {
      note = MarkdownNote(
        createdAt:  DateTime.parse(map['createdAt']),
        updatedAt:   DateTime.parse(map['updatedAt']),
        id: map['id'],
        title: map['title'],
        content: map['content'],
        folder: await folderRepository.findById(map['folder']), 
        isStarred: 'true' == map['isStarred'],
        isTrashed: 'true' == map['isTrashed'],
        tags:  List<String>.from(map['tags'])
      );
    }
    
    return note;
  }


  //TODO pretty print
  String convertToCson(Note note) => note is SnippetNote ? convertSnippetNoteToCson(note) : convertMarkdownNoteToCson(note);


  String convertMarkdownNoteToCson(MarkdownNote note){
    //note.content = note.content.replaceAll(new RegExp(r'\\'), '\\\\');
    //note.content = note.content.replaceAll('\'\'\'', '\\\'\'\'');
    String tagString;

    if(note.tags.isEmpty){
      tagString = '[]\n';
    } else {
      tagString = '[';
      note.tags.forEach((tag) => tagString = tagString + '\n"' + tag + '"');
      tagString = tagString + '\n]\n';
    }

    return
    '''
    createdAt: "''' + note.createdAt.toString() + '''"
    updatedAt: "''' + note.updatedAt.toString() + '''"
    type: "''' + (note is SnippetNote ? 'SNIPPET_NOTE' : 'MARKDOWN_NOTE') + '''"
    folder: "''' + note.folder.id + '''"
    content: \'\'\'''' + note.content + '''\'\'\'
    title: "''' + note.title + '''"
    tags: ''' + tagString + '''
    isStarred: ''' + note.isStarred.toString() + '''\n
    isTrashed: ''' + note.isTrashed.toString() + '''\n
    linesHighlighted: []
    ''';
  }

  String convertSnippetNoteToCson(SnippetNote note){
    //note.description = note.description.replaceAll(new RegExp(r'\\'), '\\\\');
    //note.description = note.description.replaceAll('\'\'\'', '\\\'\'\'');
    String tagString;

    if(note.tags.isEmpty){
      tagString = '[]';
    } else {
      tagString = '[';
      note.tags.forEach((tag) => tagString = tagString + '\n"' + tag + '"');
      tagString = tagString + '\n]';
    }

    String snippets = '';
    note.codeSnippets.forEach((snippet) {

       snippet.content = snippet.content.replaceAll(new RegExp(r'\\'), '\\\\');
       snippet.content = snippet.content.replaceAll('\'\'\'', '\\\'\'\'');

      snippets = snippets + '''\n
                          {
                            linesHighlighted: []
                            name: "''' + snippet.name + '''"
                            mode: "''' + snippet.mode + '''"
                            content: \'\'\'''' + snippet.content + '''\'\'\'
                          }
                            ''';
    });

    return
    '''
    createdAt: "''' + note.createdAt.toString() + '''"
    updatedAt: "''' + note.updatedAt.toString() + '''"
    type: "''' + (note is SnippetNote ? 'SNIPPET_NOTE' : 'MARKDOWN_NOTE') + '''"
    folder: "''' + note.folder.id + '''"
    description: \'\'\'''' + note.description + '''\'\'\'
    snippets: [
      ''' + snippets + '''
    ]
    title: "''' + note.title + '''"
    tags: ''' + tagString + '''\n
    isStarred: ''' + note.isStarred.toString() + '''\n
    isTrashed: ''' + note.isTrashed.toString() + '''\n
    ''';
  }
}