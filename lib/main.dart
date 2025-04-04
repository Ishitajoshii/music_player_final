import 'package:flutter/material.dart';
import 'profile_page.dart'; // Correct import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/swara_logo.png',
                height: 60,
                errorBuilder: (context, error, stackTrace) {
                  print("Error loading logo: $error");
                  return const Icon(Icons.broken_image, size: 60, color: Colors.red);
                },
              ),
              GestureDetector(
                onTap: () {
                  print("Profile Icon Tapped!");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // Fix: Use the correct class name with capital 'P'
                      builder: (context) => const ProfilePage(), // <-- **FIXED LINE**
                    ),
                  );
                },
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}