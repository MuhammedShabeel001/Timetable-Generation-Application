class Timetable {
  String id;
  String name;
  String courseId;

  Timetable({required this.id, required this.name, required this.courseId});

  factory Timetable.fromMap(Map<String, dynamic> data, String documentId) {
    return Timetable(
      id: documentId,
      name: data['name'],
      courseId: data['courseId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'courseId': courseId,
    };
  }
}
