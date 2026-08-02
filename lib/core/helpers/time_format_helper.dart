class TimeFormatHelper {
  static String formatAvailabilityDisplayLabel({
    required String day,
    required String from,
    required String to,
    required bool isArabic,
  }) {
    final formattedDay = formatDayName(day, isArabic);
    final formattedFrom = formatTimeString(from, isArabic);
    final formattedTo = formatTimeString(to, isArabic);

    if (formattedFrom.isNotEmpty && formattedTo.isNotEmpty) {
      return '$formattedDay $formattedFrom - $formattedTo';
    } else if (formattedFrom.isNotEmpty) {
      return '$formattedDay $formattedFrom';
    }
    return '$formattedDay $from - $to';
  }

  static String formatTimeString(String timeStr, bool isArabic) {
    if (timeStr.isEmpty) return '';
    final parts = timeStr.split(':');
    if (parts.length < 2) return timeStr;
    int hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1];
    final isPm = hour >= 12;
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;

    final period = isArabic
        ? (isPm ? 'مساءً' : 'صباحاً')
        : (isPm ? 'PM' : 'AM');
    return '$hour:$minute $period';
  }

  static String formatDayName(String dayName, bool isArabic) {
    final upper = dayName.trim().toUpperCase();
    if (!isArabic) {
      switch (upper) {
        case 'MONDAY':
          return 'Monday';
        case 'TUESDAY':
          return 'Tuesday';
        case 'WEDNESDAY':
          return 'Wednesday';
        case 'THURSDAY':
          return 'Thursday';
        case 'FRIDAY':
          return 'Friday';
        case 'SATURDAY':
          return 'Saturday';
        case 'SUNDAY':
          return 'Sunday';
        default:
          return dayName;
      }
    } else {
      switch (upper) {
        case 'MONDAY':
          return 'الاثنين';
        case 'TUESDAY':
          return 'الثلاثاء';
        case 'WEDNESDAY':
          return 'الأربعاء';
        case 'THURSDAY':
          return 'الخميس';
        case 'FRIDAY':
          return 'الجمعة';
        case 'SATURDAY':
          return 'السبت';
        case 'SUNDAY':
          return 'الأحد';
        default:
          return dayName;
      }
    }
  }
}
