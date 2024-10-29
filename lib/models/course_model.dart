// ignore_for_file: public_member_api_docs, sort_constructors_first
// models/course.dart
class Course {
  String id;
  String name;
  String description;
  List<String> subjectIds; // List of subject IDs associated with the course

  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.subjectIds,
  });

  factory Course.fromMap(Map<String, dynamic> data, String documentId) {
    return Course(
      id: documentId,
      name: data['name'],
      subjectIds: List<String>.from(data['subjectIds']),
      description: data['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description' : description,
      'subjectIds': subjectIds,
    };
  }
}
