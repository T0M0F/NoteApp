

class DateTimeConverter {

  String convertToReadableForm(DateTime dateTime){

    if(today(dateTime)){
      return dateTime.hour.toString() + ':' + dateTime.minute.toString();
    } else if(thisYear(dateTime)){
      return dateTime.day.toString() + '.' + dateTime.month.toString();
    } else {
      return dateTime.day.toString() + '.' + dateTime.month.toString() + '.' + dateTime.year.toString();
    }
    
    
  }
    
  bool today(DateTime dateTime){

    DateTime now = DateTime.now();
    DateTime today = new DateTime(now.year, now.month, now.day);
    DateTime dateToCheck = new DateTime(dateTime.year, dateTime.month, dateTime.day);

    return today == dateToCheck;
  }

  bool thisYear(DateTime dateTime) {

    DateTime now = DateTime.now();
    DateTime year = new DateTime(now.year);
    DateTime dateToCheck = new DateTime(dateTime.year);

    return year == dateToCheck;
  }

}