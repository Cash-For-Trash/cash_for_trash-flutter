abstract class AppDateFormatter {
  const AppDateFormatter._();

  static const List<String> _months = [
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

  /// Formats raw date strings (such as ISO 8601 "2026-08-01T12:33:36.458Z")
  /// into clean, human-readable strings like "01 Aug 2026, 12:33 PM" or "Today, 12:33 PM".
  static String format(String? rawDate, {bool showTime = true}) {
    if (rawDate == null || rawDate.trim().isEmpty) return '';

    final trimmed = rawDate.trim();
    final parsedDate = DateTime.tryParse(trimmed);

    // If it is not a valid ISO date/time string, return the trimmed string directly
    if (parsedDate == null) return trimmed;

    final dt = parsedDate.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(dt.year, dt.month, dt.day);

    final dayStr = dt.day.toString().padLeft(2, '0');
    final monthStr = _months[dt.month - 1];
    final yearStr = dt.year.toString();

    // Format time in 12-hour AM/PM format
    final hourNum = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
    final minuteStr = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    final timeStr = '$hourNum:$minuteStr $period';

    final bool hasTime = trimmed.contains('T') || trimmed.contains(':');

    if (dateOnly == today) {
      return hasTime && showTime ? 'Today, $timeStr' : 'Today';
    } else if (dateOnly == yesterday) {
      return hasTime && showTime ? 'Yesterday, $timeStr' : 'Yesterday';
    }

    if (hasTime && showTime) {
      return '$dayStr $monthStr $yearStr, $timeStr';
    } else {
      return '$dayStr $monthStr $yearStr';
    }
  }

  /// Formats raw time strings or ISO strings (e.g. "1970-01-01T01:00:00.000Z" or "13:30:00")
  static String formatTimeOnly(String? rawTime) {
    if (rawTime == null || rawTime.trim().isEmpty) return '';
    final trimmed = rawTime.trim();

    // Check if parsed as DateTime (e.g. "1970-01-01T01:00:00.000Z")
    final parsed = DateTime.tryParse(trimmed);
    if (parsed != null) {
      final dt = parsed.year == 1970 ? parsed.toUtc() : parsed.toLocal();
      final hourNum = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
      final minuteStr = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      return '$hourNum:$minuteStr $period';
    }

    // Check time string like "01:00:00" or "13:30:00"
    final timeParts = trimmed.split(':');
    if (timeParts.length >= 2) {
      final h = int.tryParse(timeParts[0]);
      final m = int.tryParse(timeParts[1]);
      if (h != null && m != null) {
        final hourNum = h == 0 ? 12 : (h > 12 ? h - 12 : h);
        final minuteStr = m.toString().padLeft(2, '0');
        final period = h >= 12 ? 'PM' : 'AM';
        return '$hourNum:$minuteStr $period';
      }
    }

    return trimmed;
  }

  /// Formats scheduled day, scheduled from time, and scheduled to time into a clean human-readable slot string,
  static String formatScheduledSlot({
    String? day,
    String? fromTime,
    String? toTime,
  }) {
    final rawDay = (day ?? '').trim();
    final rawFrom = (fromTime ?? '').trim();
    final rawTo = (toTime ?? '').trim();

    String dayFormatted = '';
    if (rawDay.isNotEmpty) {
      final parsedDate = DateTime.tryParse(rawDay);
      if (parsedDate != null) {
        dayFormatted = format(rawDay, showTime: false);
      } else {
        // Format day name like "FRIDAY" -> "Friday"
        dayFormatted = rawDay.toLowerCase().split(' ').map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1);
        }).join(' ');
      }
    }

    final formattedFrom = formatTimeOnly(rawFrom);
    final formattedTo = formatTimeOnly(rawTo);

    if (formattedFrom.isNotEmpty && formattedTo.isNotEmpty) {
      if (dayFormatted.isNotEmpty) {
        return '$dayFormatted ($formattedFrom - $formattedTo)';
      } else {
        return '$formattedFrom - $formattedTo';
      }
    } else if (formattedFrom.isNotEmpty) {
      if (dayFormatted.isNotEmpty) {
        return '$dayFormatted ($formattedFrom)';
      } else {
        return formattedFrom;
      }
    } else if (dayFormatted.isNotEmpty) {
      return dayFormatted;
    }

    return '';
  }
}
