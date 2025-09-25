import 'package:flutter/material.dart';
import '../models/dealer_model.dart';
import '../models/shop_model.dart';
import '../models/ration_card.dart';
import '../models/token_model.dart';
import '../models/payment_model.dart';
import '../models/booking_window_model.dart';

// Mock Dealers - Using EXISTING model fields only
List<Dealer> mockDealers = [
  Dealer(
    id: 'dealer1',
    name: 'Rajesh Kumar',
    shopId: 'shop1',
    shopName: 'Kerala Ration Store - Ward 1',
    licenseNumber: 'KRL001',
    phone: '9876543210',
    email: 'rajesh.kumar@gmail.com',
    address: 'Shop No. 15, Main Market Road, Thiruvananthapuram',
    licenseExpiry: DateTime(2025, 12, 31),
    status: 'active',
  ),
  Dealer(
    id: 'dealer2',
    name: 'Priya Nair',
    shopId: 'shop2',
    shopName: 'Kerala Ration Store - Ward 2',
    licenseNumber: 'KRL002',
    phone: '9876543220',
    email: 'priya.nair@gmail.com',
    address: 'Shop No. 8, Civil Station Road, Kollam',
    licenseExpiry: DateTime(2025, 11, 30),
    status: 'active',
  ),
  Dealer(
    id: 'dealer3',
    name: 'Mohammed Ali',
    shopId: 'shop3',
    shopName: 'Kerala Ration Store - Ward 3',
    licenseNumber: 'KRL003',
    phone: '9876543230',
    email: 'mohammed.ali@gmail.com',
    address: 'Shop No. 22, Beach Road, Kochi',
    licenseExpiry: DateTime(2026, 1, 15),
    status: 'active',
  ),
];

// Mock Shops - Using EXISTING model fields only
List<Shop> mockShops = [
  Shop(
    id: 'shop1',
    name: 'Kerala Ration Store - Ward 1',
    address: 'Shop No. 15, Main Market Road, Thiruvananthapuram',
    licenseNumber: 'SH001',
    dealerId: 'dealer1',
    openingHours: {
      'monday': {'open': '09:00', 'close': '18:00'},
      'tuesday': {'open': '09:00', 'close': '18:00'},
      'wednesday': {'open': '09:00', 'close': '18:00'},
      'thursday': {'open': '09:00', 'close': '18:00'},
      'friday': {'open': '09:00', 'close': '18:00'},
      'saturday': {'open': '09:00', 'close': '14:00'},
      'sunday': {'closed': true},
    },
    inventory: {
      'Rice': {'current': 75, 'max': 100, 'unit': 'kg', 'price': 20},
      'Wheat': {'current': 45, 'max': 80, 'unit': 'kg', 'price': 25},
      'Sugar': {'current': 25, 'max': 50, 'unit': 'kg', 'price': 40},
      'Oil': {'current': 30, 'max': 40, 'unit': 'L', 'price': 120},
    },
    dealerTimeSlots: [
      {
        'day': 'monday',
        'slots': [
          {'start': '09:00', 'end': '12:00', 'maxTokens': 20},
          {'start': '14:00', 'end': '18:00', 'maxTokens': 25}
        ]
      },
    ],
  ),
  Shop(
    id: 'shop2',
    name: 'Kerala Ration Store - Ward 2',
    address: 'Shop No. 8, Civil Station Road, Kollam',
    licenseNumber: 'SH002',
    dealerId: 'dealer2',
    openingHours: {
      'monday': {'open': '08:30', 'close': '17:30'},
      'tuesday': {'open': '08:30', 'close': '17:30'},
      'wednesday': {'open': '08:30', 'close': '17:30'},
      'thursday': {'open': '08:30', 'close': '17:30'},
      'friday': {'open': '08:30', 'close': '17:30'},
      'saturday': {'open': '08:30', 'close': '13:00'},
      'sunday': {'closed': true},
    },
    inventory: {
      'Rice': {'current': 60, 'max': 100, 'unit': 'kg', 'price': 20},
      'Wheat': {'current': 35, 'max': 80, 'unit': 'kg', 'price': 25},
      'Sugar': {'current': 15, 'max': 50, 'unit': 'kg', 'price': 40},
      'Oil': {'current': 20, 'max': 40, 'unit': 'L', 'price': 120},
    },
    dealerTimeSlots: [
      {
        'day': 'monday',
        'slots': [
          {'start': '08:30', 'end': '11:30', 'maxTokens': 15},
          {'start': '13:00', 'end': '17:30', 'maxTokens': 20}
        ]
      },
    ],
  ),
];

// Mock Ration Cards - Using EXISTING model structure
List<RationCard> mockRationCards = [
  RationCard(
    cardNumber: 'AAY001234',
    cardType: 'AAY',
    shopId: 'shop1',
    headOfFamily: 'John Doe',
    issueDate: DateTime(2020, 1, 1),
    expiryDate: DateTime(2025, 12, 31),
    familyMembers: [
      FamilyMember(
        id: '1',
        cardNumber: 'AAY001234',
        name: 'John Doe',
        fatherHusbandName: 'Father Name',
        relationship: 'Self',
        dateOfBirth: DateTime(1978, 5, 15),
        age: 45,
        address: '123 Main Street, City',
        aadharNumber: '1234-5678-9012',
        gender: 'Male',
        isHeadOfFamily: true,
      ),
      FamilyMember(
        id: '2',
        cardNumber: 'AAY001234',
        name: 'Jane Doe',
        fatherHusbandName: 'John Doe',
        relationship: 'Wife',
        dateOfBirth: DateTime(1983, 8, 20),
        age: 40,
        address: '123 Main Street, City',
        aadharNumber: '2345-6789-0123',
        gender: 'Female',
        isHeadOfFamily: false,
      ),
    ],
  ),
  RationCard(
    cardNumber: 'BPL005678',
    cardType: 'BPL',
    shopId: 'shop2',
    headOfFamily: 'Priya Sharma',
    issueDate: DateTime(2019, 6, 15),
    expiryDate: DateTime(2025, 6, 14),
    familyMembers: [
      FamilyMember(
        id: '3',
        cardNumber: 'BPL005678',
        name: 'Priya Sharma',
        fatherHusbandName: 'Father Name',
        relationship: 'Self',
        dateOfBirth: DateTime(1988, 12, 10),
        age: 35,
        address: '456 Park Avenue, City',
        aadharNumber: '3456-7890-1234',
        gender: 'Female',
        isHeadOfFamily: true,
      ),
    ],
  ),
];

// Mock Tokens - Using EXISTING model structure
List<Token> mockTokens = [
  Token(
    id: 'token1',
    userId: 'user1',
    userName: 'John Doe',
    rationCardNo: 'AAY001234',
    shopId: 'shop1',
    shopName: 'Kerala Ration Store - Ward 1',
    dealerId: 'dealer1',
    dealerName: 'Rajesh Kumar',
    date: '18/09/2025',
    timeSlot: '10:00 AM - 11:00 AM',
    slotId: 'slot1',
    tokenNumber: 'T001',
    status: 'confirmed',
    items: [
      {'name': 'Rice', 'quantity': 5, 'unit': 'kg', 'price': 20},
      {'name': 'Wheat', 'quantity': 3, 'unit': 'kg', 'price': 25},
    ],
    createdAt: DateTime.now(),
    totalAmount: 175.0,
    stockVerified: false,
    paymentMethod: 'UPI',
    paymentStatus: 'completed',
    queuePosition: 1,
    bookingWindowId: 'window1',
  ),
  Token(
    id: 'token2',
    userId: 'user2',
    userName: 'Priya Sharma',
    rationCardNo: 'BPL005678',
    shopId: 'shop2',
    shopName: 'Kerala Ration Store - Ward 2',
    dealerId: 'dealer2',
    dealerName: 'Priya Nair',
    date: '18/09/2025',
    timeSlot: '02:00 PM - 03:00 PM',
    slotId: 'slot2',
    tokenNumber: 'T002',
    status: 'completed',
    items: [
      {'name': 'Rice', 'quantity': 3, 'unit': 'kg', 'price': 20},
      {'name': 'Sugar', 'quantity': 2, 'unit': 'kg', 'price': 40},
    ],
    createdAt: DateTime.now().subtract(Duration(hours: 2)),
    totalAmount: 140.0,
    stockVerified: true,
    paymentMethod: 'Cash',
    paymentStatus: 'completed',
    queuePosition: 2,
    bookingWindowId: 'window2',
  ),
];

// Mock Payments - Using EXISTING model structure
List<Payment> mockPayments = [
  Payment(
    id: 'payment1',
    tokenId: 'token1',
    userId: 'user1',
    userName: 'John Doe',
    rationCardNo: 'AAY001234',
    amount: 175.0,
    paymentMethod: 'upi',
    paymentStatus: 'completed',
    transactionId: 'TXN001',
    paymentDate: DateTime.now(),
    paymentGateway: 'razorpay',
  ),
  Payment(
    id: 'payment2',
    tokenId: 'token2',
    userId: 'user2',
    userName: 'Priya Sharma',
    rationCardNo: 'BPL005678',
    amount: 140.0,
    paymentMethod: 'cash',
    paymentStatus: 'completed',
    transactionId: 'TXN002',
    paymentDate: DateTime.now().subtract(Duration(hours: 2)),
  ),
];

// Mock Booking Windows - Using EXISTING model structure
List<BookingWindow> mockBookingWindows = [
  BookingWindow(
    id: 'window1',
    dealerId: 'dealer1',
    shopId: 'shop1',
    date: DateTime.now(),
    session: 'morning',
    startTime: TimeOfDay(hour: 9, minute: 0),
    endTime: TimeOfDay(hour: 12, minute: 0),
    maxTokens: 50,
    tokensBooked: 25,
    isActive: true,
    createdAt: DateTime.now().subtract(Duration(days: 1)),
  ),
  BookingWindow(
    id: 'window2',
    dealerId: 'dealer2',
    shopId: 'shop2',
    date: DateTime.now(),
    session: 'evening',
    startTime: TimeOfDay(hour: 14, minute: 0),
    endTime: TimeOfDay(hour: 17, minute: 0),
    maxTokens: 40,
    tokensBooked: 30,
    isActive: true,
    createdAt: DateTime.now().subtract(Duration(days: 1)),
  ),
];

// ADD MISSING mockUsers for admin dashboard (using basic structure)
List<Map<String, dynamic>> mockUsers = [
  {
    'id': 'user1',
    'name': 'John Doe',
    'rationCard': 'AAY001234',
    'phone': '9876543210',
    'status': 'active',
  },
  {
    'id': 'user2',
    'name': 'Priya Sharma',
    'rationCard': 'BPL005678',
    'phone': '9876543211',
    'status': 'active',
  },
  {
    'id': 'user3',
    'name': 'Raj Kumar',
    'rationCard': 'APL009876',
    'phone': '9876543212',
    'status': 'active',
  },
];
