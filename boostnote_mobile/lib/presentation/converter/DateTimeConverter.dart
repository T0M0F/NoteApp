

class DateTimeConverter {

  String convertToReadableForm(DateTime dateTime){

    String minute = dateTime.minute < 10 ? '0' + dateTime.minute.toString() : dateTime.minute.toString();
    String hour = dateTime.hour < 10 ? '0' + dateTime.hour.toString() : dateTime.hour.toString();
    String day = dateTime.day < 10 ? '0' + dateTime.day.toString() : dateTime.day.toString();
    String month = dateTime.month < 10 ? '0' + dateTime.month.toString() : dateTime.month.toString();
    
    if(_recently(dateTime)) {
      int differneceInMinutes = _differneceInMinutes(dateTime);
      if(differneceInMinutes < 1){
        return 'Seconds ago';
      } else if(differneceInMinutes < 2) {
        return differneceInMinutes.toString() + ' min ago';
      } 
      return differneceInMinutes.toString() + ' mins ago';
    } else if(_today(dateTime)){
      return hour + ':' + minute;
    } else if(_thisYear(dateTime)){
      return day + '.' + month;
    } else {
      return day + '.' + month + '.' + dateTime.year.toString();
    }
  }

  int _differneceInMinutes(DateTime dateTime) {

    DateTime now = DateTime.now();
    DateTime today = new DateTime(now.year, now.month, now.day, now.hour, now.minute);
    DateTime dateToCheck = new DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute);

    return today.difference(dateToCheck).inMinutes;
  }

  bool _recently(DateTime dateTime) => _differneceInMinutes(dateTime) < 60;
    
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