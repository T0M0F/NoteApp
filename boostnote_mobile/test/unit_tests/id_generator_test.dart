import 'package:boostnote_mobile/data/IdGenerator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  group('Tests for IdGenerator', () {
    IdGenerator idGenerator = IdGenerator();
    test("Should generate folder id with lenght of 20", () {
      expect(idGenerator.generateFolderId().length, 20);
    });
    test("Should generate a uuid v4 id", () {
      RegExp regExp = RegExp(r"([a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}){1}");
      String uuidV4 = idGenerator.generateNoteId();
      expect(regExp.hasMatch(uuidV4), true);
    });
  });

}