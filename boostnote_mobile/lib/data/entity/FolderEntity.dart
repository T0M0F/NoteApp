import 'package:boostnote_mobile/business_logic/model/Folder.dart';

class FolderEntity extends Folder {

  FolderEntity({int id,
      String name }) : super(name: name, id: id);
  
  factory FolderEntity.fromJson(Map<String, dynamic> json) {
    return FolderEntity(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name
  };
}