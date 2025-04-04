import 'package:flutter/material.dart';
class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'), 
        backgroundColor: Colors.blue[900], 
      ),
      backgroundColor: Colors.blue[800],
      body: const Center( 
        child: Text(
          'Profile Screen Content Goes Here',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}