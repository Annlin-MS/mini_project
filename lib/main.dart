import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'screens/user_login.dart';
import 'screens/dealer_login.dart';
import 'screens/admin_login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Point only Auth and Firestore to the emulators:
  FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);

  runApp(PathayamApp());
}

class PathayamApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pathayam - Smart E-Ration Shop',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green.shade700,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top banner
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              color: Colors.green.shade700,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pathayam',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Smart E-Ration Shop',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Role buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  _roleButton(context, 'User Login', Icons.person, Colors.blue),
                  SizedBox(height: 20),
                  _roleButton(context, 'Dealer Login', Icons.storefront, Colors.orange),
                  SizedBox(height: 20),
                  _roleButton(context, 'Admin Login', Icons.security, Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roleButton(
      BuildContext context, String title, IconData icon, Color color) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 28),
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Text(title, style: TextStyle(fontSize: 18)),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: Size(double.infinity, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
      ),
      onPressed: () {
        if (title == 'User Login') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserLoginPage()),
          );
        } else if (title == 'Dealer Login') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DealerLoginPage()),
          );
        } else if (title == 'Admin Login') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminLoginPage()),
          );
        }
      },
    );
  }
}
