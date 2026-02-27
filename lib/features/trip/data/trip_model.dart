import 'package:uuid/uuid.dart';

class Trip {
  final String id;
  final String title;
  final String date;
  final String imageUrl;
  final String status;
  final List<String> members;
  final String userId; // Add user ID for Firestore
  final DateTime createdAt;
  final DateTime updatedAt;

  Trip({
    String? id,
    required this.title,
    required this.date,
    required this.imageUrl,
    required this.status,
    required this.members,
    required this.userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Trip copyWith({
    String? id,
    String? title,
    String? date,
    String? imageUrl,
    String? status,
    List<String>? members,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Trip(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      members: members ?? this.members,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convert Trip to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'imageUrl': imageUrl,
      'status': status,
      'members': members,
      'userId': userId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Create Trip from Firestore document
  factory Trip.fromFirestore(Map<String, dynamic> data) {
    return Trip(
      id: data['id'] as String? ?? const Uuid().v4(),
      title: data['title'] as String? ?? '',
      date: data['date'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? '',
      status: data['status'] as String? ?? '',
      members: List<String>.from(data['members'] as List? ?? []),
      userId: data['userId'] as String? ?? '',
      createdAt: (data['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }
}
