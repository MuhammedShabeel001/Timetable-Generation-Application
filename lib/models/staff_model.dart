// ignore_for_file: public_member_api_docs, sort_constructors_first
class Staff {
  String id;
  String name;
  // String courseId;
  List<String> subjectIds;

  Staff({
    required this.id,
    required this.name,
    required this.subjectIds,
  });

  factory Staff.fromMap(Map<String, dynamic> data, String documentId) {
    return Staff(
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
