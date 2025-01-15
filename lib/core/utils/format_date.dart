import 'package:intl/intl.dart';

String formatDateBydMMMYYY(DateTime dateTime) {
  return DateFormat("d MMM, yyy").format(dateTime);
}
