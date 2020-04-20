class CsonModeService {

   Mode mode(String key, String value) {
    String trimmedValue = value.trimLeft();
    if(trimmedValue.startsWith('\'\'\'')) {
      return Mode.MULTILINE;
    } else if(key == 'snippets') {
      return Mode.OBJECT_LIST;
    } else if(key == 'linesHighlighted' || key == 'tags'){
      return Mode.SIMPLE_LIST;
    } else {
       return Mode.SINGLELINE;
    }
  }

} 

enum Mode {
  SINGLELINE,
  MULTILINE,
  OBJECT_LIST,
  SIMPLE_LIST
}