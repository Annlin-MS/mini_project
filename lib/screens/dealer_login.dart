import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'dealer_dashboard.dart';
// Add this import at the top
import 'dealer_forgot_password.dart';

class DealerLoginPage extends StatefulWidget {
  @override
  _DealerLoginPageState createState() => _DealerLoginPageState();
}

class _DealerLoginPageState extends State<DealerLoginPage> {
  final TextEditingController _dealerIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _showPassword = false;
  bool _showDemoCredentials = true;

  // Demo credentials for dealers
  final List<Map<String, String>> _demoDealers = [
    {'id': 'dealer1', 'password': 'dealer123', 'shop': 'Shop No. 12'},
    {'id': 'dealer2', 'password': 'dealer456', 'shop': 'Shop No. 15'},
  ];

  void _login() {
    setState(() {
      _isLoading = true;
    });

    final result = _authService.validateDealer(
        _dealerIdController.text,
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
            builder: (context) => DealerDashboardPage(
              dealerId: result['dealerId'],
              dealerName: result['name'],
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

  void _fillDemoCredentials(String id, String password) {
    setState(() {
      _dealerIdController.text = id;
      _passwordController.text = password;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dealer Login'),
        backgroundColor: Colors.orange.shade700,
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
            Icon(Icons.storefront, size: 80, color: Colors.orange),
            SizedBox(height: 30),

            // Demo Credentials (Collapsible)
            if (_showDemoCredentials) ...[
              Card(
                color: Colors.orange.shade50,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Demo Credentials:', style: TextStyle(fontWeight: FontWeight.bold)),
                          Icon(Icons.touch_app, size: 16, color: Colors.orange),
                        ],
                      ),
                      SizedBox(height: 10),
                      ..._demoDealers.map((dealer) => GestureDetector(
                        onTap: () => _fillDemoCredentials(dealer['id']!, dealer['password']!),
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.badge, size: 16, color: Colors.orange),
                              SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${dealer['shop']}', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                    Text('ID: ${dealer['id']} | Pass: ${dealer['password']}',
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
              controller: _dealerIdController,
              decoration: InputDecoration(
                labelText: 'Dealer ID',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge),
                hintText: 'e.g., dealer1',
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
                    MaterialPageRoute(builder: (context) => DealerForgotPassword()),
                  );
                },
                child: Text('Forgot Password?', style: TextStyle(color: Colors.orange)),
              ),
            ),
            SizedBox(height: 20),

            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('DEALER LOGIN', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}