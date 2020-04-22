import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/business_logic/repository/FolderRepository.dart';
import 'package:boostnote_mobile/data/repositoryImpl/jsonImpl/FolderRepositoryImpl.dart';
import 'package:boostnote_mobile/utils/StringUtils.dart';

//TODO Aufsplitten
class CsonConverter {

  FolderRepository folderRepository;

  CsonConverter({this.folderRepository});

  StringUtils _stringUtils = StringUtils();
  
  Future<Note> convertToNote(Map<String, dynamic> map) async {
    if(folderRepository == null) {
      folderRepository = FolderRepositoryImpl();
    }

    Note note;
    if(map['type'] == 'SNIPPET_NOTE') {
      note = await convertToSnippetNote(map);
    } else {
      note = await convertToMarkdownNote(map);
    }
    return note;
  }

  Future<MarkdownNote> convertToMarkdownNote(Map<String, dynamic> map) async {
    return MarkdownNote(
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      id: map['id'],
      title: map['title'],
      content: map['content'],
      folder: await folderRepository.findById(map['folder']), 
      isStarred: 'true' == map['isStarred'],
      isTrashed: 'true' == map['isTrashed'],
      tags:  List<String>.from(map['tags'])
    );
  }

  Future<SnippetNote> convertToSnippetNote(Map<String, dynamic> map) async {
    return SnippetNote(
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
  }


  //TODO pretty print
  String convertToCson(Note note) => note is SnippetNote ? convertSnippetNoteToCson(note) : convertMarkdownNoteToCson(note);

  String convertMarkdownNoteToCson(MarkdownNote note){
    String tagString;
    if(note.tags.isEmpty){
      tagString = '[]\n';
    } else {
      tagString = '[';
      note.tags.forEach(
        (tag) => tagString = _stringUtils.escape(tagString) + '\n"' + tag + '"'
      );
      tagString = tagString + '\n]\n';
    }

    return
    '''
    createdAt: "''' + note.createdAt.toString() + '''"
    updatedAt: "''' + note.updatedAt.toString() + '''"
    type: "''' + 'MARKDOWN_NOTE' + '''"
    folder: "''' + note.folder.id + '''"
    content: \'\'\'''' + _stringUtils.escape(note.content) + '''\'\'\'
    title: "''' + _stringUtils.escape(note.title) + '''"
    tags: ''' + tagString + '''
    isStarred: ''' + note.isStarred.toString() + '''\n
    isTrashed: ''' + note.isTrashed.toString() + '''\n
    linesHighlighted: []
    ''';
  }

  String convertSnippetNoteToCson(SnippetNote note){
    String tagString;
    if(note.tags.isEmpty){
      tagString = '[]';
    } else {
      tagString = '[';
      note.tags.forEach((tag) => tagString = _stringUtils.escape(tagString) + '\n"' + tag + '"');
      tagString = tagString + '\n]';
    }

    String snippets = '';
    note.codeSnippets.forEach((snippet) {
      snippets = snippets +  _convertSnippetToCson(snippet, snippets);
    });

    return
    '''
    createdAt: "''' + note.createdAt.toString() + '''"
    updatedAt: "''' + note.updatedAt.toString() + '''"
    type: "''' + 'SNIPPET_NOTE' + '''"
    folder: "''' + note.folder.id + '''"
    description: \'\'\'''' + _stringUtils.escape(note.description) + '''\'\'\'
    snippets: [
      ''' + snippets + '''
    ]
    title: "''' + _stringUtils.escape(note.title) + '''"
    tags: ''' + tagString + '''\n
    isStarred: ''' + note.isStarred.toString() + '''\n
    isTrashed: ''' + note.isTrashed.toString() + '''\n
    ''';
  }

  String _convertSnippetToCson(CodeSnippet snippet, String snippets) {
    return '''\n
      {
        linesHighlighted: []
        name: "''' + _stringUtils.escape(snippet.content) + '''"
      mode: "''' + _stringUtils.escape(snippet.name) + '''"
      content: \'\'\'''' + _stringUtils.escape(snippet.mode) + '''\'\'\'
    }
      ''';
  }
}