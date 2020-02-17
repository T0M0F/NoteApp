class TagListConverter {

  String convert(List<String> tags){

    if(tags == null) {
      throw Exception('List must not be null!');
    }

    String result = '';

    tags.forEach((tag) {
      result += '#' + tag + ' ';
    });

    return result;
  }

}