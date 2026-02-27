import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wanderly/features/trip/data/trip_enums.dart';

/// State class for filter and sort options
class TripFilterSortState {
  final TripStatus? selectedStatus; // null means show all
  final TripSortBy sortBy;
  final String searchQuery;

  const TripFilterSortState({
    this.selectedStatus,
    this.sortBy = TripSortBy.dateAscending,
    this.searchQuery = '',
  });

  TripFilterSortState copyWith({
    TripStatus? selectedStatus,
    TripSortBy? sortBy,
    String? searchQuery,
  }) {
    return TripFilterSortState(
      selectedStatus: selectedStatus ?? this.selectedStatus,
      sortBy: sortBy ?? this.sortBy,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Notifier for managing filter and sort state
class TripFilterSortNotifier extends StateNotifier<TripFilterSortState> {
  TripFilterSortNotifier() : super(const TripFilterSortState());

  /// Set filter by status
  void setStatusFilter(TripStatus? status) {
    state = state.copyWith(selectedStatus: status);
  }

  /// Set sort option
  void setSortBy(TripSortBy sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }

  /// Set search query
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Reset all filters and sort
  void reset() {
    state = const TripFilterSortState();
  }

  /// Toggle status filter (if same status is selected, deselect it)
  void toggleStatusFilter(TripStatus status) {
    if (state.selectedStatus == status) {
      state = state.copyWith(selectedStatus: null);
    } else {
      state = state.copyWith(selectedStatus: status);
    }
  }
}

/// Provider for filter and sort state
final tripFilterSortProvider =
    StateNotifierProvider<TripFilterSortNotifier, TripFilterSortState>(
  (ref) => TripFilterSortNotifier(),
);
