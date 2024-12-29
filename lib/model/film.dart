class Film {
  final String title;
  final String poster_path;
  final int id;
  bool isHovered = false;
  bool isWatched = false;

  Film({
    required this.title,
    required this.poster_path,
    required this.id
  });
}