

class DateTimeConverter {

  String convertToReadableForm(DateTime dateTime){

    if(_today(dateTime)){
      return dateTime.hour.toString() + ':' + dateTime.minute.toString();
    } else if(_thisYear(dateTime)){
      return dateTime.day.toString() + '.' + dateTime.month.toString();
    } else {
      return dateTime.day.toString() + '.' + dateTime.month.toString() + '.' + dateTime.year.toString();
    }
  }
    
  bool _today(DateTime dateTime){

    DateTime now = DateTime.now();
    DateTime today = new DateTime(now.year, now.month, now.day);
    DateTime dateToCheck = new DateTime(dateTime.year, dateTime.month, dateTime.day);

    return today == dateToCheck;
  }

  bool _thisYear(DateTime dateTime) {

    DateTime now = DateTime.now();
    DateTime year = new DateTime(now.year);
    DateTime dateToCheck = new DateTime(dateTime.year);

    return year == dateToCheck;
  }

}