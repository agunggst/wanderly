import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wanderly/core/services/firestore_trip_service.dart';
import 'package:wanderly/features/auth/provider/current_user_provider.dart';
import 'package:wanderly/features/trip/data/trip_model.dart';

final tripListProvider =
    AsyncNotifierProvider<TripListNotifier, List<Trip>>(TripListNotifier.new);

class TripListNotifier extends AsyncNotifier<List<Trip>> {
  late final FirestoreTripService _firestoreService;

  @override
  Future<List<Trip>> build() async {
    _firestoreService = FirestoreTripService();
    
    // Get current user ID
    final userId = ref.watch(currentUserIdProvider);
    
    if (userId == null || userId.isEmpty) {
      return [];
    }

    try {
      return await _firestoreService.getUserTrips(userId);
    } catch (e) {
      throw Exception('Failed to load trips: $e');
    }
  }

  /// Add a new trip
  Future<void> addTrip(Trip trip) async {
    try {
      state = const AsyncValue.loading();
      
      final newTrip = await _firestoreService.createTrip(trip);
      
      final current = state.value ?? [];
      state = AsyncData([newTrip, ...current]);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  /// Delete a trip
  Future<void> deleteTrip(String id) async {
    try {
      await _firestoreService.deleteTrip(id);
      
      final current = state.value ?? [];
      state = AsyncData(current.where((t) => t.id != id).toList());
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  /// Update a trip
  Future<void> updateTrip(Trip updated) async {
    try {
      final updatedTrip = await _firestoreService.updateTrip(updated);
      
      final current = state.value ?? [];
      state = AsyncData([
        for (final t in current)
          if (t.id == updatedTrip.id) updatedTrip else t
      ]);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  /// Reload trips from Firestore
  Future<void> reload() async {
    state = const AsyncLoading();
    try {
      final userId = ref.watch(currentUserIdProvider);
      if (userId == null || userId.isEmpty) {
        state = const AsyncData([]);
        return;
      }
      
      final trips = await _firestoreService.getUserTrips(userId);
      state = AsyncData(trips);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
