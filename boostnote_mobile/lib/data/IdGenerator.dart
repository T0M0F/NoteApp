import 'dart:convert';
import 'dart:math';

import 'package:uuid/uuid.dart';

class IdGenerator {

  String generateNoteId() => Uuid().v4();

  String generateFolderId() {
    Random random = Random.secure();
    List<int> values = List<int>.generate(13, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }
}