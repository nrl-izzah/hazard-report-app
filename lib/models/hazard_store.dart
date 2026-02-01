import 'hazard.dart';

class HazardStore {

  static final List<Hazard> hazards = [];

  static int _counter = 0;

  static void addHazard(Hazard hazard) {
    hazards.add(hazard);
  }

  static Hazard createHazard({
    required String title,
    required String description,
    required double lat,
    required double lng,
  }) {
    _counter++;

    return Hazard(
      id: _counter,
      title: title,
      description: description,
      lat: lat,
      lng: lng,
      reportedAt: DateTime.now(),
    );
  }

  static void removeById(int id) {
    hazards.removeWhere((h) => h.id == id);
  }
}
