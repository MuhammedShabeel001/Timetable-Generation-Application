class Staff {
  String id;
  String name;

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
