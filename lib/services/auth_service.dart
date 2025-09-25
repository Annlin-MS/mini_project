import 'package:flutter/material.dart';

class AuthService {
  // Mock user database with different card types
  final Map<String, Map<String, dynamic>> _users = {
    'RC123456': {
      'password': 'user123',
      'name': 'Ramesh Kumar',
      'type': 'PHH',
      'shopId': 'shop1',
      'cardColor': Colors.white.value // White card for PHH
    },
    'RC789012': {
      'password': 'user456',
      'name': 'Lakshmi Amma',
      'type': 'AAY',
      'shopId': 'shop1',
      'cardColor': Colors.yellow.value // Yellow card for AAY
    },
    'RC345678': {
      'password': 'user789',
      'name': 'Mohan Singh',
      'type': 'BPL',
      'shopId': 'shop1',
      'cardColor': Colors.pink.value // Pink card for BPL
    },
    'RC901234': {
      'password': 'user000',
      'name': 'Rajesh Kumar',
      'type': 'APL',
      'shopId': 'shop1',
      'cardColor': Colors.blue.value // Blue card for APL
    },
  };

  // Mock dealer database
  final Map<String, Map<String, dynamic>> _dealers = {
    'dealer1': {
      'password': 'dealer123',
      'name': 'Rajesh Singh',
      'shopId': 'shop1',
      'license': 'DLR12345'
    },
    'dealer2': {
      'password': 'dealer456',
      'name': 'Suresh Kumar',
      'shopId': 'shop2',
      'license': 'DLR12346'
    },
  };

  // Mock admin database
  final Map<String, Map<String, dynamic>> _admins = {
    'admin1': {
      'password': 'admin123',
      'name': 'System Administrator',
      'role': 'Super Admin'
    },
  };

  dynamic validateUser(String rationCard, String password) {
    final user = _users[rationCard];
    if (user != null && user['password'] == password) {
      return {
        'success': true,
        'userType': 'user',
        'name': user['name'],
        'rationCardNo': rationCard,
        'cardType': user['type'],
        'shopId': user['shopId'],
        'cardColor': user['cardColor']
      };
    }
    return {'success': false, 'message': 'Invalid ration card or password'};
  }

  dynamic validateDealer(String dealerId, String password) {
    final dealer = _dealers[dealerId];
    if (dealer != null && dealer['password'] == password) {
      return {
        'success': true,
        'userType': 'dealer',
        'name': dealer['name'],
        'dealerId': dealerId,
        'shopId': dealer['shopId'],
        'license': dealer['license']
      };
    }
    return {'success': false, 'message': 'Invalid dealer ID or password'};
  }

  dynamic validateAdmin(String adminId, String password) {
    final admin = _admins[adminId];
    if (admin != null && admin['password'] == password) {
      return {
        'success': true,
        'userType': 'admin',
        'name': admin['name'],
        'adminId': adminId,
        'role': admin['role']
      };
    }
    return {'success': false, 'message': 'Invalid admin ID or password'};
  }

  // Get all demo credentials for display
  Map<String, String> getDemoCredentials() {
    return {
      'User (PHH - White)': 'RC123456 / user123',
      'User (AAY - Yellow)': 'RC789012 / user456',
      'User (BPL - Pink)': 'RC345678 / user789',
      'User (APL - Blue)': 'RC901234 / user000',
      'Dealer': 'dealer1 / dealer123',
      'Admin': 'admin1 / admin123'
    };
  }


  // Add these methods to your AuthService class

  // User password reset
  bool resetUserPassword(String rationCard, String newPassword, {String? email, String? phone}) {
    final user = _users[rationCard];
    if (user != null) {
      // Verify email or phone if provided
      if (email != null && !_verifyUserEmail(rationCard, email)) {
        return false;
      }
      if (phone != null && !_verifyUserPhone(rationCard, phone)) {
        return false;
      }

      user['password'] = newPassword;
      return true;
    }
    return false;
  }

  // Dealer password reset
  bool resetDealerPassword(String dealerId, String newPassword, {String? email, String? phone}) {
    final dealer = _dealers[dealerId];
    if (dealer != null) {
      // Verify email or phone if provided
      if (email != null && !_verifyDealerEmail(dealerId, email)) {
        return false;
      }
      if (phone != null && !_verifyDealerPhone(dealerId, phone)) {
        return false;
      }

      dealer['password'] = newPassword;
      return true;
    }
    return false;
  }

  // Verification methods (mock implementation)
  bool _verifyUserEmail(String rationCard, String email) {
    // In real app, this would check against stored email
    return true; // Mock verification
  }

  bool _verifyUserPhone(String rationCard, String phone) {
    // In real app, this would check against stored phone
    return true; // Mock verification
  }

  bool _verifyDealerEmail(String dealerId, String email) {
    // In real app, this would check against stored email
    return true; // Mock verification
  }

  bool _verifyDealerPhone(String dealerId, String phone) {
    // In real app, this would check against stored email
    return true; // Mock verification
  }

  // Get user by ration card
  Map<String, dynamic>? getUserByRationCard(String rationCard) {
    return _users[rationCard];
  }

  // Get dealer by ID
  Map<String, dynamic>? getDealerById(String dealerId) {
    return _dealers[dealerId];
  }
}