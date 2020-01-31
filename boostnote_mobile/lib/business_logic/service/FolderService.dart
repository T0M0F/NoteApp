import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/repository/FolderRepository.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/data/repositoryImpl/FolderRepositoryImpl.dart';

class FolderService {

  FolderRepository _folderRepository = FolderRepositoryImpl();
  NoteService _noteService = NoteService();

  Future<List<Folder>> findAll() {
    return _folderRepository.findAll();
  }

  Future<List<Folder>> findAllUntrashed() async {
    List<Folder> folders = await findAll();
    List<Folder> filteredFolders = folders.where((folder) => folder.name != 'Trash').toList();
    return Future.value(filteredFolders);
  }

  Future<void> createFolderIfNotExisting(Folder folder) async {
    folder.id = folder.name.hashCode;
    return _folderRepository.save(folder);
  }

  Future<void> renameFolder(Folder oldFolder, String newName) async {
    Folder newFolder = Folder(id: newName.hashCode, name: newName);
    createFolderIfNotExisting(newFolder);
    List<Note> notesToBeMoved = await _noteService.findNotesIn(oldFolder);
    notesToBeMoved.forEach((note) => note.folder = newFolder);
    _noteService.saveAll(notesToBeMoved);
    return delete(oldFolder);
  }

  Future<void> delete(Folder folder) async {
    List<Note> notesToBeDeleted = await _noteService.findNotesIn(folder);
    _noteService.moveAllToTrash(notesToBeDeleted);
    return _folderRepository.delete(folder);
  }

}