class StringUtils {

  List<String> splitFirst(String input, String pattern) {
      List<String> splitted = List();
      if(input.split(pattern).length > 1){
        int index = input.indexOf(pattern);
        splitted =  [input.substring(0,index).trim(), input.substring(index+1).trim()];
      } else {
        splitted = input.split(pattern);
      }
      return splitted;
  }

  String escape(String input) {
    if(input == null) throw Exception('Input must not be null');
    return input.replaceAll(r"\", r"\\").replaceAll("'''", r"\'''");
  }

  String unescape(String input) {
    if(input == null) throw Exception('Input must not be null');
    return input.replaceAll(r"\'''", r"'''").replaceAll(r"\\", r"\");
  }
}