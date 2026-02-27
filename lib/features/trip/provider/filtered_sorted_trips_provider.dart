import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wanderly/core/utils/trip_date_utils.dart';
import 'package:wanderly/features/trip/data/trip_enums.dart';
import 'package:wanderly/features/trip/data/trip_model.dart';
import 'package:wanderly/features/trip/provider/trip_filter_sort_provider.dart';
import 'package:wanderly/features/trip/provider/trip_provider.dart';

/// Provider for filtered and sorted trips
final filteredSortedTripsProvider = Provider<AsyncValue<List<Trip>>>((ref) {
  final tripsAsync = ref.watch(tripListProvider);
  final filterSort = ref.watch(tripFilterSortProvider);

  return tripsAsync.whenData((trips) {
    // Apply filtering
    var filtered = trips;

    // Filter by status
    if (filterSort.selectedStatus != null) {
      filtered = filtered.where((trip) {
        final tripStatus = TripDateUtils.determineTripStatus(trip.date);
        return tripStatus == filterSort.selectedStatus;
      }).toList();
    }

    // Filter by search query
    if (filterSort.searchQuery.isNotEmpty) {
      final query = filterSort.searchQuery.toLowerCase();
      filtered = filtered.where((trip) {
        return trip.title.toLowerCase().contains(query);
      }).toList();
    }

    // Apply sorting
    switch (filterSort.sortBy) {
      case TripSortBy.dateAscending:
        filtered.sort((a, b) {
          final dateA = TripDateUtils.getStartDate(a.date);
          final dateB = TripDateUtils.getStartDate(b.date);
          if (dateA == null || dateB == null) return 0;
          return dateA.compareTo(dateB);
        });
        break;

      case TripSortBy.dateDescending:
        filtered.sort((a, b) {
          final dateA = TripDateUtils.getStartDate(a.date);
          final dateB = TripDateUtils.getStartDate(b.date);
          if (dateA == null || dateB == null) return 0;
          return dateB.compareTo(dateA);
        });
        break;

      case TripSortBy.titleAscending:
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;

      case TripSortBy.titleDescending:
        filtered.sort((a, b) => b.title.compareTo(a.title));
        break;

      case TripSortBy.createdNewest:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;

      case TripSortBy.createdOldest:
        filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
    }

    return filtered;
  });
});
