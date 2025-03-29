import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' hide log;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:url_launcher/url_launcher_string.dart';

class Helpers{
  static TextDirection getTextDirection(BuildContext context){
  Locale currentLocale = Localizations.localeOf(context);
  TextDirection textDirection = currentLocale.languageCode == 'ar' || currentLocale.languageCode == 'he'
      ? TextDirection.rtl
      : TextDirection.ltr;
  return textDirection;
  }

  static bool isKeyboardOpen(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  static String getMonth(String dateTime){
    DateTime date = DateFormat("EEEE, MMMM dd").parse(dateTime);
    return DateFormat.MMMM().format(date);
  }

  static String getDayOfWeekInString(int day) {
    const daysOfWeek = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday"
    ];
    return daysOfWeek[day];
  }


  static String decodeNdefPayload(String hexPayload) {
    final bytes = Uint8List.fromList(
      List<int>.generate(
        hexPayload.length ~/ 2,
            (i) => int.parse(hexPayload.substring(i * 2, i * 2 + 2), radix: 16),
      ),
    );

    return utf8.decode(bytes);
  }

  static bool isDarkMode(BuildContext context){
    return Theme.of(context).brightness == Brightness.dark;
  }

  static double screenHeight(BuildContext context){
    return (MediaQuery.of(context).size.height);
  }

  static double screenWidth(BuildContext context){
    return (MediaQuery.of(context).size.width);
  }

  static DateTime? parseTimeString(String? timeString) {
    if (timeString == null) return null;
    final format = DateFormat("HH:mm"); // Adjust if your format is different
    return format.parse(timeString);
  }

  static String formatTimeToString(BuildContext context, TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.Hm(locale).format(dt);
  }

  static TimeOfDay formatStringToTimeOfDay(String time) {
    final parts = time.split(":");
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    return TimeOfDay(hour: hour, minute: minute);
  }

  static DateTime formatStringToDateTime(String dateString) {
    try {
      return DateFormat('yyyy-MMM-dd').parse(dateString);
    } catch (e) {
      throw FormatException('Invalid date format.');
    }
  }

  static DateTime formatCalendarToDateTime(String dateString) {
    try {
      return DateFormat('yyyy-MMM-dd').parse(dateString);
    } catch (e) {
      throw FormatException('Invalid date format. Expected yyyy-MM-dd.');
    }
  }

  static String formatDateToString(DateTime date) {
    return DateFormat('yyyy-MMM-dd').format(date);
  }

  static String formatDateToStringWithNumberedMonths(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String getDayOfWeek(DateTime date) {
    try {
      return DateFormat('EEEE').format(date);
    } catch (e) {
      log("Error formatting date: $e");
      return "Invalid date";
    }
  }
  static List<T> filterList<T>({
    required List<T> items,
    required String query,
    required bool Function(T item, String query) filterCondition,
  }) {
    if (query.isEmpty) {
      return items;
    }

    return items.where((item) => filterCondition(item, query)).toList();
  }

  static bool isIOS() {
    return Platform.isIOS;
  }

  static String getTimeDifference(BuildContext context, String timeFrom, String timeTo) {
    final fromTime = TimeOfDay(
      hour: int.parse(timeFrom.split(':')[0]),
      minute: int.parse(timeFrom.split(':')[1]),
    );
    final toTime = TimeOfDay(
      hour: int.parse(timeTo.split(':')[0]),
      minute: int.parse(timeTo.split(':')[1]),
    );

    final fromMinutes = fromTime.hour * 60 + fromTime.minute;
    final toMinutes = toTime.hour * 60 + toTime.minute;

    int difference = toMinutes - fromMinutes;
    if (difference < 0) {
      difference += 24 * 60;
    }

    final hours = difference ~/ 60;
    final minutes = difference % 60;

    if (hours > 0 && minutes > 0) {
      return '$hours hr${hours > 1 ? "s" : ""} $minutes min${minutes > 1 ? "s" : ""}';
    } else if (hours > 0) {
      return '$hours hr${hours > 1 ? "s" : ""}';
    } else {
      return '$minutes min${minutes > 1 ? "s" : ""}';
    }
  }

  static void hideKeyboard(BuildContext context){
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static Future<void> setStatusBarColor(Color color) async{
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: color),
    );
  }

  static bool isLandscapeOrientation(BuildContext context){
    // final viewInsets = View.of(context).viewInsets;
    // return viewInsets.bottom == 0;
    return MediaQuery.of(context).orientation == Orientation.landscape;

  }

  static void setOrientationToPortrait(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  static bool isTablet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final diagonal = size.diagonalInches;

    // Common threshold for tablet detection is 7 inches
    return diagonal >= 7.0;
  }

  static void setOrientationToPortraitOrLandscape(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
  }

  static bool isPortraitOrientation(BuildContext context){
    // final viewInsets = View.of(context).viewInsets;
    // return viewInsets.bottom != 0;
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  static void setFullScreen(bool enable){
    SystemChrome.setEnabledSystemUIMode(enable? SystemUiMode.immersiveSticky : SystemUiMode.edgeToEdge);
  }

  static double getScreenHeight(BuildContext context){
    return MediaQuery.of(context).size.height;
  }

  static double getScreenWidth(BuildContext context){
    return MediaQuery.of(context).size.width;
  }

  static double getBottomNavigationBarHeight(){
    return kBottomNavigationBarHeight;
  }

  static double getAppBarHeight(){
    return kToolbarHeight;
  }

  static Future<bool> isPhysicalDevice() async{
    return defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;
  }

  static void vibrate(Duration duration){
    HapticFeedback.vibrate();
    Future.delayed(duration,() => HapticFeedback.vibrate());
  }

  static Future<void> setPreferredOrientations(List<DeviceOrientation> orientations) async{
    await SystemChrome.setPreferredOrientations(orientations);
  }

  static void hideStatusBar(){
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  static Future<bool> hasInternetConnection() async{
    try{
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch(_){
      return false;
    }
  }

  static bool isAndroid(){
    return defaultTargetPlatform == TargetPlatform.android;
  }

  static void launchUrl(String url) async{
    await launchUrlString(url);
  }
}

extension SizeExtension on Size {
  double get diagonalInches => (sqrt((width * width) + (height * height)) / 160);
}

abstract class Enum<T> {
  final T _value;

  const Enum(this._value);

  T get value => _value;
}
