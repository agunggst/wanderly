import 'package:intl/intl.dart';
import 'package:wanderly/features/trip/data/trip_enums.dart';
import 'package:wanderly/features/trip/data/trip_model.dart';

class TripDateUtils {
  /// Parse date string and get start date
  static DateTime? getStartDate(String dateString) {
    try {
      final parts = dateString.split(',');
      if (parts.length < 2) return null;

      final year = int.tryParse(parts[1].trim());
      if (year == null) return null;

      final range = parts[0].split(' - ');
      if (range.isEmpty) return null;

      final startText = '${range[0]}, $year';
      final formatter = DateFormat('MMM dd, yyyy');
      return formatter.parse(startText);
    } catch (e) {
      return null;
    }
  }

  /// Parse date string and get end date
  static DateTime? getEndDate(String dateString) {
    try {
      final parts = dateString.split(',');
      if (parts.length < 2) return null;

      final year = int.tryParse(parts[1].trim());
      if (year == null) return null;

      final range = parts[0].split(' - ');
      if (range.length < 2) return null;

      final endText = '${range[1]}, $year';
      final formatter = DateFormat('MMM dd, yyyy');
      return formatter.parse(endText);
    } catch (e) {
      return null;
    }
  }

  /// Determine trip status based on dates
  static TripStatus determineTripStatus(String dateString) {
    final now = DateTime.now();
    final startDate = getStartDate(dateString);
    final endDate = getEndDate(dateString);

    if (startDate == null || endDate == null) {
      return TripStatus.upcoming;
    }

    // Completed: end date is in the past
    if (endDate.isBefore(now)) {
      return TripStatus.completed;
    }

    // Ongoing: start date is in the past and end date is in the future
    if (startDate.isBefore(now) && endDate.isAfter(now)) {
      return TripStatus.ongoing;
    }

    // Upcoming: start date is in the future
    return TripStatus.upcoming;
  }
}
