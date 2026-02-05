import 'package:riverpod/riverpod.dart';
import 'package:wanderly/features/trip/data/trip_model.dart';

final tripListProvider = NotifierProvider<TripListNotifier, List<Trip>>(TripListNotifier.new);

class TripListNotifier extends Notifier<List<Trip>> {
  @override
  List<Trip> build() {
    return [
      Trip(
        title: 'Paris Getaway',
        date: 'Oct 12 - Oct 18, 2024',
        imageUrl: 'https://picsum.photos/600/400?1',
        status: '6 Days Left',
        members: [
          'https://i.pravatar.cc/100?1',
          'https://i.pravatar.cc/100?2',
        ],
      ),
      Trip(
        title: 'Tokyo Adventure',
        date: 'Dec 01 - Dec 15, 2024',
        imageUrl: 'https://picsum.photos/600/400?2',
        status: 'Planning',
        members: [
          'https://i.pravatar.cc/100?3',
        ],
      ),
    ];
  }

  void addTrip(Trip trip) {
    state = [...state, trip];
  }

  void deleteTrip(int index) {
    final newList = [...state]..removeAt(index);
    state = newList;
  }

  void updateTrip(int index, Trip trip) {
    final newList = [...state];
    newList[index] = trip;
    state = newList;
  }
}