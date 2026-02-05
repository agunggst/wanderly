import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'trip_model.g.dart';

@HiveType(typeId: 1)
class Trip extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String date;

  @HiveField(3)
  final String imageUrl;

  @HiveField(4)
  final String status;

  @HiveField(5)
  final List<String> members;

  Trip({
    String? id,
    required this.title,
    required this.date,
    required this.imageUrl,
    required this.status,
    required this.members,
  }) : id = id ?? const Uuid().v4();

  Trip copyWith({
    String? id,
    String? title,
    String? date,
    String? imageUrl,
    String? status,
    List<String>? members,
  }) {
    return Trip(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      members: members ?? this.members,
    );
  }
}
