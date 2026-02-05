import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wanderly/core/storage/trip_storage.dart';
import '../data/trip_model.dart';

final tripListProvider =
    AsyncNotifierProvider<TripListNotifier, List<Trip>>(TripListNotifier.new);

class TripListNotifier extends AsyncNotifier<List<Trip>> {
  @override
  Future<List<Trip>> build() async {
    return await TripStorage.getAllTrips();
  }

  Future<void> addTrip(Trip trip) async {
    final current = state.value ?? [];
    state = AsyncData([...current, trip]);
    await TripStorage.saveTrip(trip);
  }

  Future<void> deleteTrip(String id) async {
    final current = state.value ?? [];
    state = AsyncData(current.where((t) => t.id != id).toList());
    await TripStorage.deleteTrip(id);
  }

  Future<void> updateTrip(Trip updated) async {
    final current = state.value ?? [];

    state = AsyncData([
      for (final t in current)
        if (t.id == updated.id) updated else t
    ]);

    await TripStorage.saveTrip(updated);
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = AsyncData(await TripStorage.getAllTrips());
  }
}
