import 'package:boostnote_mobile/business_logic/model/Folder.dart';

class FolderEntity extends Folder {

  FolderEntity({int id,
      String name, String key, String color }) : super(name: name, id: id, key: key, color: color);
  
  factory FolderEntity.fromJson(Map<String, dynamic> json) {
    return FolderEntity(
      id: json['id'],
      name: json['name'],
      key: json['key'],
      color: json['color']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'key': key,
    'color': color
  };
}