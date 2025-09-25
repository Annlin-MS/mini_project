class FamilyMember {
  final String id;
  final String cardNumber;
  final String name;
  final String fatherHusbandName;
  final String relationship;
  final DateTime dateOfBirth;
  final int age;
  final String address;
  final String aadharNumber;
  final String gender;
  final bool isHeadOfFamily;

  FamilyMember({
    required this.id,
    required this.cardNumber,
    required this.name,
    required this.fatherHusbandName,
    required this.relationship,
    required this.dateOfBirth,
    required this.age,
    required this.address,
    required this.aadharNumber,
    required this.gender,
    required this.isHeadOfFamily,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cardNumber': cardNumber,
      'name': name,
      'fatherHusbandName': fatherHusbandName,
      'relationship': relationship,
      'dateOfBirth': dateOfBirth.millisecondsSinceEpoch,
      'age': age,
      'address': address,
      'aadharNumber': aadharNumber,
      'gender': gender,
      'isHeadOfFamily': isHeadOfFamily,
    };
  }

  factory FamilyMember.fromMap(Map<String, dynamic> map) {
    return FamilyMember(
      id: map['id'] ?? '',
      cardNumber: map['cardNumber'] ?? '',
      name: map['name'] ?? '',
      fatherHusbandName: map['fatherHusbandName'] ?? '',
      relationship: map['relationship'] ?? '',
      dateOfBirth: DateTime.fromMillisecondsSinceEpoch(map['dateOfBirth']),
      age: map['age'] ?? 0,
      address: map['address'] ?? '',
      aadharNumber: map['aadharNumber'] ?? '',
      gender: map['gender'] ?? '',
      isHeadOfFamily: map['isHeadOfFamily'] ?? false,
    );
  }
}

class RationCard {
  final String? id; // Added id field for document ID
  final String cardNumber;
  final String cardType;
  final String shopId;
  final List<FamilyMember> familyMembers;
  String headOfFamily;
  final DateTime issueDate;
  final DateTime expiryDate;
  int? annualIncome;
  String? job;
  final String? district; // Added district field
  final int? memberCount; // Added memberCount field
  final bool isActive; // Added isActive field
  final DateTime? createdAt; // Added createdAt field

  RationCard({
    this.id,
    required this.cardNumber,
    required this.cardType,
    required this.shopId,
    required this.familyMembers,
    required this.headOfFamily,
    required this.issueDate,
    required this.expiryDate,
    this.annualIncome,
    this.job,
    this.district,
    this.memberCount,
    this.isActive = true,
    this.createdAt,
  });

  int get totalMembers => familyMembers.length;
  bool get isValid => expiryDate.isAfter(DateTime.now());

  // Helper getter for head of family name (compatibility with admin dashboard)
  String get headOfFamilyName => headOfFamily;

  Map<String, dynamic> toMap() {
    return {
      'cardNumber': cardNumber,
      'cardType': cardType,
      'shopId': shopId,
      'familyMembers': familyMembers.map((member) => member.toMap()).toList(),
      'headOfFamily': headOfFamily,
      'issueDate': issueDate.millisecondsSinceEpoch,
      'expiryDate': expiryDate.millisecondsSinceEpoch,
      'annualIncome': annualIncome,
      'job': job,
      'district': district,
      'memberCount': memberCount ?? familyMembers.length,
      'isActive': isActive,
      'createdAt': createdAt?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
    };
  }

  factory RationCard.fromMap(Map<String, dynamic> map, [String? id]) {
    return RationCard(
      id: id,
      cardNumber: map['cardNumber'] ?? '',
      cardType: map['cardType'] ?? '',
      shopId: map['shopId'] ?? '',
      familyMembers: map['familyMembers'] != null
          ? (map['familyMembers'] as List<dynamic>)
          .map((memberMap) => FamilyMember.fromMap(memberMap))
          .toList()
          : [],
      headOfFamily: map['headOfFamily'] ?? '',
      issueDate: map['issueDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['issueDate'])
          : DateTime.now(),
      expiryDate: map['expiryDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['expiryDate'])
          : DateTime.now().add(const Duration(days: 365 * 5)), // 5 years validity
      annualIncome: map['annualIncome'],
      job: map['job'],
      district: map['district'],
      memberCount: map['memberCount'],
      isActive: map['isActive'] ?? true,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : null,
    );
  }

  // Create a copy with updated fields
  RationCard copyWith({
    String? id,
    String? cardNumber,
    String? cardType,
    String? shopId,
    List<FamilyMember>? familyMembers,
    String? headOfFamily,
    DateTime? issueDate,
    DateTime? expiryDate,
    int? annualIncome,
    String? job,
    String? district,
    int? memberCount,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return RationCard(
      id: id ?? this.id,
      cardNumber: cardNumber ?? this.cardNumber,
      cardType: cardType ?? this.cardType,
      shopId: shopId ?? this.shopId,
      familyMembers: familyMembers ?? this.familyMembers,
      headOfFamily: headOfFamily ?? this.headOfFamily,
      issueDate: issueDate ?? this.issueDate,
      expiryDate: expiryDate ?? this.expiryDate,
      annualIncome: annualIncome ?? this.annualIncome,
      job: job ?? this.job,
      district: district ?? this.district,
      memberCount: memberCount ?? this.memberCount,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
