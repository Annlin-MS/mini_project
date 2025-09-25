import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'user_dashboard.dart';
// Add this import at the top
import 'user_forgot_password.dart';

class UserLoginPage extends StatefulWidget {
  @override
  _UserLoginState createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLoginPage> {
  final TextEditingController _rationCardController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _showPassword = false;
  bool _showDemoCredentials = true;

  // Demo credentials
  final List<Map<String, String>> _demoUsers = [
    {'card': 'RC123456', 'password': 'user123', 'type': 'PHH (White Card)'},
    {'card': 'RC789012', 'password': 'user456', 'type': 'AAY (Yellow Card)'},
    {'card': 'RC345678', 'password': 'user789', 'type': 'BPL (Pink Card)'},
    {'card': 'RC901234', 'password': 'user000', 'type': 'APL (Blue Card)'},
  ];

  void _login() {
    setState(() {
      _isLoading = true;
    });

    final result = _authService.validateUser(
        _rationCardController.text,
        _passwordController.text
    );

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserDashboard(
              userName: result['name'],
              rationCardNo: result['rationCardNo'],
              cardType: result['cardType'],
              cardColor: result['cardColor'],
              currentMonthEntitlement: _getMonthlyEntitlement(result['cardType']),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  void _fillDemoCredentials(String card, String password) {
    setState(() {
      _rationCardController.text = card;
      _passwordController.text = password;
    });
  }

  void _forgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserForgotPassword()),
    );
  }

  Map<String, dynamic> _getMonthlyEntitlement(String cardType) {
    switch (cardType) {
      case 'AAY':
        return {
          'month': 'October 2023',
          'items': [
            {'name': 'Rice', 'quantity': '35 kg', 'price': '₹3/kg'},
            {'name': 'Wheat', 'quantity': '15 kg', 'price': '₹2/kg'},
          ],
          'totalValue': 135.0
        };
      case 'PHH':
        return {
          'month': 'October 2023',
          'items': [
            {'name': 'Rice', 'quantity': '20 kg', 'price': '₹3/kg'},
            {'name': 'Wheat', 'quantity': '10 kg', 'price': '₹2/kg'},
          ],
          'totalValue': 80.0
        };
      case 'BPL':
        return {
          'month': 'October 2023',
          'items': [
            {'name': 'Rice', 'quantity': '25 kg', 'price': '₹3/kg'},
            {'name': 'Wheat', 'quantity': '12 kg', 'price': '₹2/kg'},
          ],
          'totalValue': 99.0
        };
      default: // APL
        return {
          'month': 'October 2023',
          'items': [
            {'name': 'Rice', 'quantity': '15 kg', 'price': '₹3/kg'},
            {'name': 'Wheat', 'quantity': '8 kg', 'price': '₹2/kg'},
          ],
          'totalValue': 61.0
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Login'),
        backgroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
            icon: Icon(_showDemoCredentials ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                _showDemoCredentials = !_showDemoCredentials;
              });
            },
            tooltip: _showDemoCredentials ? 'Hide Demo Credentials' : 'Show Demo Credentials',
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 80, color: Colors.blue),
            SizedBox(height: 30),

            // Demo Credentials (Collapsible)
            if (_showDemoCredentials) ...[
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Demo Credentials:', style: TextStyle(fontWeight: FontWeight.bold)),
                          Icon(Icons.touch_app, size: 16, color: Colors.blue),
                        ],
                      ),
                      SizedBox(height: 10),
                      ..._demoUsers.map((user) => GestureDetector(
                        onTap: () => _fillDemoCredentials(user['card']!, user['password']!),
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.credit_card, size: 16, color: Colors.blue),
                              SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${user['type']}', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                    Text('Card: ${user['card']} | Pass: ${user['password']}',
                                        style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )).toList(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],

            // Login Form
            TextField(
              controller: _rationCardController,
              decoration: InputDecoration(
                labelText: 'Ration Card Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.credit_card),
                hintText: 'e.g., RC123456',
              ),
            ),
            SizedBox(height: 20),

            TextField(
              controller: _passwordController,
              obscureText: !_showPassword,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                ),
                hintText: 'Enter your password',
              ),
            ),

            // Forgot Password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserForgotPassword()),
                  );
                },
                child: Text('Forgot Password?', style: TextStyle(color: Colors.blue)),
              ),
            ),
            SizedBox(height: 20),

            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('USER LOGIN', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}