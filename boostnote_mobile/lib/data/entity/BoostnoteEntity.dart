
import 'package:boostnote_mobile/business_logic/model/Boostnote.dart';
import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/data/entity/FolderEntity.dart';

class BoostnoteEntity extends Boostnote {

  BoostnoteEntity({List<Folder> folders}) : super(folders: folders);
  
  factory BoostnoteEntity.fromJson(Map<String, dynamic> json) {
    return BoostnoteEntity(
      folders: (json['folders'] as List).map((folder) => FolderEntity.fromJson(folder)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'version' : super.version,
    'folders' : folders
  };
}