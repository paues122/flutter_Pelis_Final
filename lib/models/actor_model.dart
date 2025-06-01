class ActorModel {
  final int id;
  final String name;
  final String? profilePath;
  final String character;

  ActorModel({
    required this.id,
    required this.name,
    this.profilePath,
    required this.character,
  });

  factory ActorModel.fromMap(Map<String, dynamic> map) {
    return ActorModel(
      id: map['id'],
      name: map['name'],
      profilePath: map['profile_path'] != null
          ? 'https://image.tmdb.org/t/p/w200/${map['profile_path']}'
          : null,
      character: map['character'] ?? '',
    );
  }
}