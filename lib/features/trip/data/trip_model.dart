class Trip {
  final String title;
  final String date;
  final String imageUrl;
  final String status;
  final List<String> members;

  const Trip({
    required this.title,
    required this.date,
    required this.imageUrl,
    required this.status,
    required this.members,
  });

  Trip copyWith({
    String? title,
    String? date,
    String? imageUrl,
    String? status,
    List<String>? members,
  }) {
    return Trip(
      title: title ?? this.title,
      date: date ?? this.date,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      members: members ?? this.members,
    );
  }
}
