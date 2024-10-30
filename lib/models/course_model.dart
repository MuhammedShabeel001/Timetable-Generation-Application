class Course {
  String id;
  String name;
  String description;
  List<String> subjectIds;

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
      'description': description,
      'subjectIds': subjectIds,
    };
  }
}
