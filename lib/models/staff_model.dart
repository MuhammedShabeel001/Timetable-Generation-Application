class Staff {
  String id;
  String name;
  String courseId;

  Staff({required this.id, required this.name, required this.courseId});

  factory Staff.fromMap(Map<String, dynamic> data, String documentId) {
    return Staff(
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
