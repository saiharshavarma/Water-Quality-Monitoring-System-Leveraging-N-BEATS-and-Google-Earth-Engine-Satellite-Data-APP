import 'package:intl/intl.dart';
List months = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

String setDate(date) {
    if (date.isNotEmpty) {
      return "${DateTime.parse(date).day} ${months[DateTime.parse(date).month]}, ${DateTime.parse(date).year}";
    } else {
      return "";
    }
  }

  String setTime(date) {
    if (date.isNotEmpty) {
      // return "${DateTime.parse(date).hour}:${DateTime.parse(date).minute} ${DateTime.parse(date).hour > 11 ? 'PM' : 'AM'}";
      return "${DateTime.parse(date).hour}:${DateTime.parse(date).minute}";
    } else {
      return "";
    }
    // return "${DateTime.parse(date).hour}:${DateTime.parse(date).minute} ${DateTime.parse(date).hour > 12 ? 'PM' : 'AM'}";
  }

  String increaseDate(date, int noOfDays) {
    if (date.isNotEmpty) {
      var d0 =  DateTime(DateTime.parse(date).year, DateTime.parse(date).month, DateTime.parse(date).day);
      var d =  DateTime(d0.year, d0.month, d0.day + noOfDays);
      return "${d.day} ${months[d.month]}, ${d.year}";
    } else {
      return "";
    }
  }

   String increaseDate2(date, int noOfDays) {
    if (date.isNotEmpty) {
      var d0 =  DateTime(DateTime.parse(date).year, DateTime.parse(date).month, DateTime.parse(date).day);
      var d =  DateTime(d0.year, d0.month, d0.day + noOfDays);
      return "${d.day}\n${months[d.month]}";
    } else {
      return "";
    }
  }

  String decreaseMonth(date, int noOfMonths) {
    if (date.isNotEmpty) {
      var d0 =  DateTime(DateTime.parse(date).year, DateTime.parse(date).month, DateTime.parse(date).day);
      var d =  DateTime(d0.year, d0.month - noOfMonths, d0.day);
      return formatDate(d);
    } else {
      return "";
    }
  }

  String formatDate(DateTime date) =>  DateFormat("yyyy-MM-dd").format(date);