import 'package:uuid/uuid.dart';

class IdGenerator {

  String generateId() => Uuid().v4();

}