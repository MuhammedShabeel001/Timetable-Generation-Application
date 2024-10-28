class Subject {
  String id;
  String name;
  String courseId;

  Subject({required this.id, required this.name, required this.courseId});

  factory Subject.fromMap(Map<String, dynamic> data, String documentId) {
    return Subject(
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
