// models/course.dart
class Course {
  String id;
  String name;
  List<String> subjectIds; // List of subject IDs associated with the course

  Course({required this.id, required this.name, required this.subjectIds});

  factory Course.fromMap(Map<String, dynamic> data, String documentId) {
    return Course(
      id: documentId,
      name: data['name'],
      subjectIds: List<String>.from(data['subjectIds']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'subjectIds': subjectIds,
    };
  }
}
