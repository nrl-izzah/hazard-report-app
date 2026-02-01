class Hazard {
  final int id;
  final String title;
  final String description;
  final double lat;
  final double lng;
  final DateTime reportedAt;

  Hazard({
    required this.id,
    required this.title,
    required this.description,
    required this.lat,
    required this.lng,
    required this.reportedAt,
  });
}
