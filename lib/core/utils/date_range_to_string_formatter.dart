import 'package:intl/intl.dart';
import 'package:flutter/material.dart';


String dateRangeToStringFormatter (DateTimeRange range) {
  final start = range.start;
  final end = range.end;

  final monthDay = DateFormat('MMM dd');
  final year = DateFormat('yyyy');

  // kalau masih di tahun yang sama
  if (start.year == end.year) {
    return "${monthDay.format(start)} - ${monthDay.format(end)}, ${year.format(start)}";
  }

  // kalau beda tahun
  return "${monthDay.format(start)}, ${year.format(start)} - ${monthDay.format(end)}, ${year.format(end)}";
}
