class Dealer {
  final String id;
  final String name;
  final String shopId;
  final String shopName;
  final String licenseNumber;
  final String phone;
  final String email;
  final String address;
  final DateTime licenseExpiry;
  final String status; // active, inactive, suspended
  final String wardNumber;
  final String profileImageUrl;
  final DateTime joinDate;
  final List<String> specializations;

  // Complete Personal Details
  final int age;
  final String gender;
  final String fatherName;
  final String aadharNumber;
  final String panNumber;
  final DateTime dateOfBirth;
  final String bloodGroup;
  final String emergencyContact;
  final String qualification;
  final String experience;

  // Shop License Details
  final String shopLicenseNumber;
  final DateTime shopLicenseExpiry;
  final String fssaiNumber;
  final String gstNumber;
  final double shopArea;
  final String shopType;

  // Banking Details
  final String bankName;
  final String accountNumber;
  final String ifscCode;
  final String branchName;

  // Performance Tracking
  final double rating;
  final int totalCustomers;
  final int warningsCount;
  final DateTime lastStockUpdate;

  Dealer({
    required this.id,
    required this.name,
    required this.shopId,
    required this.shopName,
    required this.licenseNumber,
    required this.phone,
    required this.email,
    required this.address,
    required this.licenseExpiry,
    required this.status,
    this.wardNumber = "1",
    this.profileImageUrl = "",
    DateTime? joinDate,
    this.specializations = const [],
    // Personal Details
    this.age = 35,
    this.gender = "Male",
    this.fatherName = "",
    this.aadharNumber = "",
    this.panNumber = "",
    DateTime? dateOfBirth,
    this.bloodGroup = "O+",
    this.emergencyContact = "",
    this.qualification = "",
    this.experience = "",
    // Shop License
    this.shopLicenseNumber = "",
    DateTime? shopLicenseExpiry,
    this.fssaiNumber = "",
    this.gstNumber = "",
    this.shopArea = 0.0,
    this.shopType = "Ration Shop",
    // Banking
    this.bankName = "",
    this.accountNumber = "",
    this.ifscCode = "",
    this.branchName = "",
    // Performance
    this.rating = 4.5,
    this.totalCustomers = 0,
    this.warningsCount = 0,
    DateTime? lastStockUpdate,
  }) : joinDate = joinDate ?? DateTime.now(),
        dateOfBirth = dateOfBirth ?? DateTime.now().subtract(Duration(days: 35 * 365)),
        shopLicenseExpiry = shopLicenseExpiry ?? DateTime.now().add(Duration(days: 365)),
        lastStockUpdate = lastStockUpdate ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'shopId': shopId,
      'shopName': shopName,
      'licenseNumber': licenseNumber,
      'phone': phone,
      'email': email,
      'address': address,
      'licenseExpiry': licenseExpiry.toIso8601String(),
      'status': status,
      'wardNumber': wardNumber,
      'profileImageUrl': profileImageUrl,
      'joinDate': joinDate.toIso8601String(),
      'specializations': specializations,
      // Personal Details
      'age': age,
      'gender': gender,
      'fatherName': fatherName,
      'aadharNumber': aadharNumber,
      'panNumber': panNumber,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'bloodGroup': bloodGroup,
      'emergencyContact': emergencyContact,
      'qualification': qualification,
      'experience': experience,
      // Shop License
      'shopLicenseNumber': shopLicenseNumber,
      'shopLicenseExpiry': shopLicenseExpiry.toIso8601String(),
      'fssaiNumber': fssaiNumber,
      'gstNumber': gstNumber,
      'shopArea': shopArea,
      'shopType': shopType,
      // Banking
      'bankName': bankName,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'branchName': branchName,
      // Performance
      'rating': rating,
      'totalCustomers': totalCustomers,
      'warningsCount': warningsCount,
      'lastStockUpdate': lastStockUpdate.toIso8601String(),
    };
  }

  factory Dealer.fromMap(Map<String, dynamic> map) {
    return Dealer(
      id: map['id'],
      name: map['name'],
      shopId: map['shopId'],
      shopName: map['shopName'],
      licenseNumber: map['licenseNumber'],
      phone: map['phone'],
      email: map['email'],
      address: map['address'],
      licenseExpiry: DateTime.parse(map['licenseExpiry']),
      status: map['status'],
      wardNumber: map['wardNumber'] ?? "1",
      profileImageUrl: map['profileImageUrl'] ?? "",
      joinDate: map['joinDate'] != null ? DateTime.parse(map['joinDate']) : DateTime.now(),
      specializations: List<String>.from(map['specializations'] ?? []),
      // Personal Details
      age: map['age'] ?? 35,
      gender: map['gender'] ?? "Male",
      fatherName: map['fatherName'] ?? "",
      aadharNumber: map['aadharNumber'] ?? "",
      panNumber: map['panNumber'] ?? "",
      dateOfBirth: map['dateOfBirth'] != null ? DateTime.parse(map['dateOfBirth']) : DateTime.now().subtract(Duration(days: 35 * 365)),
      bloodGroup: map['bloodGroup'] ?? "O+",
      emergencyContact: map['emergencyContact'] ?? "",
      qualification: map['qualification'] ?? "",
      experience: map['experience'] ?? "",
      // Shop License
      shopLicenseNumber: map['shopLicenseNumber'] ?? "",
      shopLicenseExpiry: map['shopLicenseExpiry'] != null ? DateTime.parse(map['shopLicenseExpiry']) : DateTime.now().add(Duration(days: 365)),
      fssaiNumber: map['fssaiNumber'] ?? "",
      gstNumber: map['gstNumber'] ?? "",
      shopArea: map['shopArea']?.toDouble() ?? 0.0,
      shopType: map['shopType'] ?? "Ration Shop",
      // Banking
      bankName: map['bankName'] ?? "",
      accountNumber: map['accountNumber'] ?? "",
      ifscCode: map['ifscCode'] ?? "",
      branchName: map['branchName'] ?? "",
      // Performance
      rating: map['rating']?.toDouble() ?? 4.5,
      totalCustomers: map['totalCustomers'] ?? 0,
      warningsCount: map['warningsCount'] ?? 0,
      lastStockUpdate: map['lastStockUpdate'] != null ? DateTime.parse(map['lastStockUpdate']) : DateTime.now(),
    );
  }

  // Helper methods
  bool get isActive => status == 'active';
  bool get isLicenseValid => licenseExpiry.isAfter(DateTime.now());
  bool get isShopLicenseValid => shopLicenseExpiry.isAfter(DateTime.now());
  int get experienceYears => DateTime.now().difference(joinDate).inDays ~/ 365;
  bool get hasWarnings => warningsCount > 0;
  bool get isHighPerformer => rating >= 4.0 && warningsCount == 0;

  String get performanceStatus {
    if (rating >= 4.5 && warningsCount == 0) return "Excellent";
    if (rating >= 4.0 && warningsCount <= 1) return "Good";
    if (rating >= 3.5 && warningsCount <= 2) return "Average";
    return "Poor";
  }
}

// Daily Report Model
class DailyReport {
  final String id;
  final String dealerId;
  final String shopId;
  final DateTime date;
  final Map<String, int> customerStats; // Card type -> count
  final Map<String, double> stockLevels; // Item -> percentage
  final Map<String, int> stockSales; // Item -> quantity sold
  final double totalRevenue;
  final int totalTokens;
  final List<String> lowStockAlerts;
  final List<String> malpracticeAlerts;
  final bool isSubmitted;
  final DateTime submittedAt;

  DailyReport({
    required this.id,
    required this.dealerId,
    required this.shopId,
    required this.date,
    this.customerStats = const {},
    this.stockLevels = const {},
    this.stockSales = const {},
    this.totalRevenue = 0.0,
    this.totalTokens = 0,
    this.lowStockAlerts = const [],
    this.malpracticeAlerts = const [],
    this.isSubmitted = false,
    DateTime? submittedAt,
  }) : submittedAt = submittedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dealerId': dealerId,
      'shopId': shopId,
      'date': date.toIso8601String(),
      'customerStats': customerStats,
      'stockLevels': stockLevels,
      'stockSales': stockSales,
      'totalRevenue': totalRevenue,
      'totalTokens': totalTokens,
      'lowStockAlerts': lowStockAlerts,
      'malpracticeAlerts': malpracticeAlerts,
      'isSubmitted': isSubmitted,
      'submittedAt': submittedAt.toIso8601String(),
    };
  }

  factory DailyReport.fromMap(Map<String, dynamic> map) {
    return DailyReport(
      id: map['id'],
      dealerId: map['dealerId'],
      shopId: map['shopId'],
      date: DateTime.parse(map['date']),
      customerStats: Map<String, int>.from(map['customerStats'] ?? {}),
      stockLevels: Map<String, double>.from(map['stockLevels'] ?? {}),
      stockSales: Map<String, int>.from(map['stockSales'] ?? {}),
      totalRevenue: map['totalRevenue']?.toDouble() ?? 0.0,
      totalTokens: map['totalTokens'] ?? 0,
      lowStockAlerts: List<String>.from(map['lowStockAlerts'] ?? []),
      malpracticeAlerts: List<String>.from(map['malpracticeAlerts'] ?? []),
      isSubmitted: map['isSubmitted'] ?? false,
      submittedAt: map['submittedAt'] != null ? DateTime.parse(map['submittedAt']) : DateTime.now(),
    );
  }
}
