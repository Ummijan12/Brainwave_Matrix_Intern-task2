import 'package:intl/intl.dart';

class DateFormatUtil {
  static String formatNewsDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'Unknown date';
    }

    try {
      DateTime parsedDate = DateTime.parse(dateString);
      DateTime now = DateTime.now();

      Duration difference = now.difference(parsedDate);

      if (difference.inHours < 24) {
        if (difference.inHours < 1) {
          return difference.inMinutes == 0
              ? 'Just now'
              : '${difference.inMinutes} min ago';
        }
        return '${difference.inHours} hours ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return DateFormat('MMM d, yyyy h:mm a').format(parsedDate);
      }
    } catch (e) {
      return dateString;
    }
  }

  static String formatDateLocalized(String? dateString, {String? locale}) {
    if (dateString == null || dateString.isEmpty) {
      return 'Unknown date';
    }

    try {
      DateTime parsedDate = DateTime.parse(dateString);

      final dateFormatter = DateFormat.yMMMd(locale ?? 'en_US').add_jm();

      return dateFormatter.format(parsedDate);
    } catch (e) {
      return dateString;
    }
  }
}
