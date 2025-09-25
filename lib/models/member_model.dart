class MemberModel {
  final String id;
  final String rationCardId;
  final String name;
  final int age;
  final String gender;
  final String aadhaarNumber;
  final String relationToHead;

  MemberModel({
    required this.id,
    required this.rationCardId,
    required this.name,
    required this.age,
    required this.gender,
    required this.aadhaarNumber,
    required this.relationToHead,
  });

  // Convert to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rationCardId': rationCardId,
      'name': name,
      'age': age,
      'gender': gender,
      'aadhaarNumber': aadhaarNumber,
      'relationToHead': relationToHead,
    };
  }

  // Create from Map for Firebase
  factory MemberModel.fromMap(Map<String, dynamic> map) {
    return MemberModel(
      id: map['id'],
      rationCardId: map['rationCardId'],
      name: map['name'],
      age: map['age'],
      gender: map['gender'],
      aadhaarNumber: map['aadhaarNumber'],
      relationToHead: map['relationToHead'],
    );
  }
}