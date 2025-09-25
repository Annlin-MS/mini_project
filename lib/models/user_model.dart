class FamilyMember {
  final String id;
  final String name;
  final String relation;
  final DateTime dateOfBirth;
  final int age;
  final String gender;
  final String aadhaarNumber;
  final String occupation;
  final double annualIncome;

  FamilyMember({
    required this.id,
    required this.name,
    required this.relation,
    required this.dateOfBirth,
    required this.age,
    required this.gender,
    required this.aadhaarNumber,
    required this.occupation,
    required this.annualIncome,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'relation': relation,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'age': age,
      'gender': gender,
      'aadhaarNumber': aadhaarNumber,
      'occupation': occupation,
      'annualIncome': annualIncome,
    };
  }

  factory FamilyMember.fromMap(Map<String, dynamic> map) {
    return FamilyMember(
      id: map['id'],
      name: map['name'],
      relation: map['relation'],
      dateOfBirth: DateTime.parse(map['dateOfBirth']),
      age: map['age'],
      gender: map['gender'],
      aadhaarNumber: map['aadhaarNumber'],
      occupation: map['occupation'],
      annualIncome: map['annualIncome'],
    );
  }
}

class UserProfile {
  final String rationCardNo;
  final String cardType;
  final String headOfFamily;
  final String address;
  final String phone;
  final String email;
  final double familyAnnualIncome;
  final String occupation;
  final List<FamilyMember> familyMembers;
  final List<Map<String, dynamic>> entitlementHistory;
  final DateTime registrationDate;

  UserProfile({
    required this.rationCardNo,
    required this.cardType,
    required this.headOfFamily,
    required this.address,
    required this.phone,
    required this.email,
    required this.familyAnnualIncome,
    required this.occupation,
    required this.familyMembers,
    required this.entitlementHistory,
    required this.registrationDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'rationCardNo': rationCardNo,
      'cardType': cardType,
      'headOfFamily': headOfFamily,
      'address': address,
      'phone': phone,
      'email': email,
      'familyAnnualIncome': familyAnnualIncome,
      'occupation': occupation,
      'familyMembers': familyMembers.map((member) => member.toMap()).toList(),
      'entitlementHistory': entitlementHistory,
      'registrationDate': registrationDate.toIso8601String(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      rationCardNo: map['rationCardNo'],
      cardType: map['cardType'],
      headOfFamily: map['headOfFamily'],
      address: map['address'],
      phone: map['phone'],
      email: map['email'],
      familyAnnualIncome: map['familyAnnualIncome'],
      occupation: map['occupation'],
      familyMembers: List<FamilyMember>.from(
          map['familyMembers'].map((x) => FamilyMember.fromMap(x))),
      entitlementHistory: List<Map<String, dynamic>>.from(map['entitlementHistory']),
      registrationDate: DateTime.parse(map['registrationDate']),
    );
  }
}