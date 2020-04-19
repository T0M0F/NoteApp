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

}