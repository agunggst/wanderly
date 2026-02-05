import 'package:hive/hive.dart';
import 'package:wanderly/features/trip/data/trip_model.dart';

class TripStorage {
  static const _boxName = "trip_box";

  static Future<Box<Trip>> _box() async {
    return await Hive.openBox<Trip>(_boxName);
  }

  static Future<List<Trip>> getAllTrips() async {
    final box = await _box();
    return box.values.toList();
  }

  static Future<void> saveTrip(Trip trip) async {
    final box = await _box();
    await box.put(trip.id, trip);
  }

  static Future<void> deleteTrip(String id) async {
    final box = await _box();
    await box.delete(id);
  }

  static Future<void> clear() async {
    final box = await _box();
    await box.clear();
  }
}
