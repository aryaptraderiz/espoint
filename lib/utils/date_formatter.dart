import 'package:intl/intl.dart';

class DateFormatter {
  static String format(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }

  static String short(DateTime date) {
    return DateFormat('dd/MM').format(date);
  }

  static String onlyDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String onlyTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }
}
