import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateTimeRange parseDateRange(String value) {
  final parts = value.split(',');

  final year = int.parse(parts[1].trim());

  final range = parts[0].split(' - ');
  final startText = '${range[0]}, $year';
  final endText = '${range[1]}, $year';

  final formatter = DateFormat('MMM dd, yyyy');

  final startDate = formatter.parse(startText);
  final endDate = formatter.parse(endText);

  return DateTimeRange(
    start: startDate,
    end: endDate,
  );
}
