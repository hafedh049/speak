import 'package:speak/utils/globals.dart';

Map<String, dynamic> getMonthDetails(int monthNumber) {
  final now = DateTime.now();
  final currentMonth = DateTime(now.year, monthNumber + 1, 1);

  final monthName = months[currentMonth.month - 1];
  final numberOfDays = DateTime(now.year, monthNumber + 2, 0).day;
  final currentDay = now.day;

  return {
    'Month': monthName,
    'CurrentDay': currentDay,
    'NumberOfDays': numberOfDays,
  };
}
