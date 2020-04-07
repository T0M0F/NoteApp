import 'package:boostnote_mobile/business_logic/model/Folder.dart';

class FolderEntity extends Folder {

  FolderEntity({String id,
      String name, String color }) : super(name: name, id: id, color: color);
  
  factory FolderEntity.fromJson(Map<String, dynamic> json) {
    return FolderEntity(
      id: json['key'],
      name: json['name'],
      color: json['color']
    );
  }

  Map<String, dynamic> toJson() => {
    'key': id,
    'name': name,
    'color': color
  };
}