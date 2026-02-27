/// Enum for trip status
enum TripStatus {
  upcoming('Upcoming'),
  ongoing('Ongoing'),
  completed('Completed');

  final String displayName;
  const TripStatus(this.displayName);

  /// Get status from string
  static TripStatus fromString(String value) {
    return TripStatus.values.firstWhere(
      (status) => status.displayName.toLowerCase() == value.toLowerCase(),
      orElse: () => TripStatus.upcoming,
    );
  }
}

/// Enum for sorting options
enum TripSortBy {
  dateAscending('Date: Earliest First'),
  dateDescending('Date: Latest First'),
  titleAscending('Title: A-Z'),
  titleDescending('Title: Z-A'),
  createdNewest('Newest First'),
  createdOldest('Oldest First');

  final String displayName;
  const TripSortBy(this.displayName);
}
