import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class DealerForgotPassword extends StatefulWidget {
  @override
  _DealerForgotPasswordState createState() => _DealerForgotPasswordState();
}

class _DealerForgotPasswordState extends State<DealerForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dealerIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String _selectedMethod = 'dealerId';

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      if (_newPasswordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Passwords do not match'), backgroundColor: Colors.red),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      bool success = false;
      String message = '';

      if (_selectedMethod == 'dealerId') {
        success = _authService.resetDealerPassword(
          _dealerIdController.text,
          _newPasswordController.text,
        );
        message = success ? 'Password reset successfully!' : 'Invalid dealer ID';
      }
      else if (_selectedMethod == 'email') {
        success = _authService.resetDealerPassword(
          _dealerIdController.text,
          _newPasswordController.text,
          email: _emailController.text,
        );
        message = success ? 'Password reset successfully!' : 'Invalid email or dealer ID';
      }
      else if (_selectedMethod == 'phone') {
        success = _authService.resetDealerPassword(
          _dealerIdController.text,
          _newPasswordController.text,
          phone: _phoneController.text,
        );
        message = success ? 'Password reset successfully!' : 'Invalid phone number or dealer ID';
      }

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );

        if (success) {
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Dealer Password'),
        backgroundColor: Colors.orange.shade700,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Reset Dealer Password',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),

              // Verification Method Selection
              Text('Verification Method:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: [
                  ChoiceChip(
                    label: Text('Dealer ID'),
                    selected: _selectedMethod == 'dealerId',
                    onSelected: (selected) {
                      setState(() {
                        _selectedMethod = 'dealerId';
                      });
                    },
                  ),
                  ChoiceChip(
                    label: Text('Email'),
                    selected: _selectedMethod == 'email',
                    onSelected: (selected) {
                      setState(() {
                        _selectedMethod = 'email';
                      });
                    },
                  ),
                  ChoiceChip(
                    label: Text('Phone'),
                    selected: _selectedMethod == 'phone',
                    onSelected: (selected) {
                      setState(() {
                        _selectedMethod = 'phone';
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Dealer ID (always required)
              TextFormField(
                controller: _dealerIdController,
                decoration: InputDecoration(
                  labelText: 'Dealer ID',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter dealer ID';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Email Field (conditionally shown)
              if (_selectedMethod == 'email')
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Registered Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: _selectedMethod == 'email' ? (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  } : null,
                ),
              if (_selectedMethod == 'email') SizedBox(height: 16),

              // Phone Field (conditionally shown)
              if (_selectedMethod == 'phone')
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Registered Phone Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: _selectedMethod == 'phone' ? (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (value.length != 10) {
                      return 'Phone number must be 10 digits';
                    }
                    return null;
                  } : null,
                ),
              if (_selectedMethod == 'phone') SizedBox(height: 16),

              // New Password
              TextFormField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter new password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Confirm Password
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),

              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade700,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('RESET PASSWORD', style: TextStyle(fontSize: 18)),
              ),

              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Back to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}