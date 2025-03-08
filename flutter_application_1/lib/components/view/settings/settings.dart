import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/models/user_model.dart';
import 'package:flutter_application_1/data/appvalues.dart';

import '../Auth/login_view.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Mock user data - replace with actual user data from your app
  final Map<String, dynamic> userData = {
    'name': UserModel.name.isNotEmpty ? UserModel.name : "Not provided",
    'email': UserModel.email.isNotEmpty ? UserModel.email : "Not provided",
    'phone': UserModel.phone.isNotEmpty ? UserModel.phone : "Not provided",
    'accountType': 'Premium',
    'profilePicture': UserModel.photoUrl,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Blue curved header with profile image
            Container(
              height: 150,
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    // Profile picture
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 47,
                        backgroundImage: NetworkImage(userData['profilePicture']),
                        // If image fails to load, show a fallback
                        onBackgroundImageError: (_, __) {},
                        child: userData['profilePicture'] == null
                            ? const Icon(Icons.person, size: 60, color: Colors.blue)
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // User name with larger font
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                userData['name'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontFamily: "medium",
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Account type chip
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${userData['accountType']} Account',
                style: TextStyle(
                  color: Colors.blue.shade800,
                  fontWeight: FontWeight.bold,
                  fontFamily: "medium"
                ),
              ),
            ),

            // Text(
            //   "Will implement subscription things in future"
            // ),

            const SizedBox(height: 30),

            // Profile information cards
            _buildInfoCard('Email', userData['email'], Icons.email),
            _buildInfoCard('Phone', userData['phone'], Icons.phone),

            const SizedBox(height: 40),

            // Logout button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  // Add logout functionality here
                  _showLogoutDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 16,fontFamily: "medium"),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 28),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue.shade300,
                    fontFamily: "medium"
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                    fontFamily: "medium"
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel", style: TextStyle(
                  color: Colors.blue.shade700,
                  fontFamily: "medium"
              )),
            ),
            ElevatedButton(
              onPressed: () async {
                // Implement your logout logic here
                await FirebaseAuth.instance.signOut();
                AppValues.jwtToken = "";
                UserModel.phone = "";
                UserModel.email = "";
                UserModel.name = "";
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                      (Route<dynamic> route) => false,
                );
                // You might want to navigate to login page or clear user session
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
              ),
              child: const Text("Logout", style: TextStyle(
                  color: Colors.white,
                  fontFamily: "medium"
              )),
            ),
          ],
        );
      },
    );
  }
}