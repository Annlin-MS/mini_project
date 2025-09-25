class Shop {
  final String id;
  final String name;
  final String address;
  final String licenseNumber;
  final String dealerId;
  final Map<String, dynamic> openingHours;
  final Map<String, dynamic> inventory;
  final List<Map<String, dynamic>> dealerTimeSlots; // Changed from timeSlots

  Shop({
    required this.id,
    required this.name,
    required this.address,
    required this.licenseNumber,
    required this.dealerId,
    required this.openingHours,
    required this.inventory,
    required this.dealerTimeSlots,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'licenseNumber': licenseNumber,
      'dealerId': dealerId,
      'openingHours': openingHours,
      'inventory': inventory,
      'dealerTimeSlots': dealerTimeSlots,
    };
  }

  factory Shop.fromMap(Map<String, dynamic> map) {
    return Shop(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      licenseNumber: map['licenseNumber'],
      dealerId: map['dealerId'],
      openingHours: Map<String, dynamic>.from(map['openingHours']),
      inventory: Map<String, dynamic>.from(map['inventory']),
      dealerTimeSlots: List<Map<String, dynamic>>.from(map['dealerTimeSlots'] ?? []),
    );
  }
}