// lib/profile_page.dart

import 'package:flutter/material.dart';

// Modify ProfilePage to accept counts
class ProfilePage extends StatelessWidget {
  final int likedSongsCount;
  final int playlistCount;

  // Update constructor to require these counts
  const ProfilePage({
    Key? key,
    required this.likedSongsCount,
    required this.playlistCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const whiteTextStyle = TextStyle(color: Colors.white, fontSize: 18);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
        backgroundColor: Colors.blue[900],
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        iconTheme: const IconThemeData(color: Colors.white), // Back button color
      ),
      backgroundColor: Colors.blue[800],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          // Use a Column to display the info
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
            children: [
              // Example: Placeholder for profile picture/icon
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 60, color: Colors.blue),
              ),
              const SizedBox(height: 30),

              // Display Liked Songs Count
              Text(
                'Liked Songs: $likedSongsCount',
                style: whiteTextStyle,
              ),
              const SizedBox(height: 15), // Spacing

              // Display Playlist Count
              Text(
                'Playlists: $playlistCount', // Includes "Liked Songs" pseudo-playlist
                style: whiteTextStyle,
              ),
              const SizedBox(height: 30), // Spacing at bottom
              // Add more profile details here later if needed
            ],
          ),
        ),
      ),
    );
  }
}