import 'package:flutter/material.dart';

class LikedSongsScreen extends StatelessWidget {
  final Set<int> likedIndices;
  final List<Map<String, String>> allSongs;

  LikedSongsScreen({
    Key? key,
    required this.likedIndices,
    required this.allSongs,
  }) : super(key: key);

  Map<String, String>? _getSongDetails(int index) {
    if (index >= 0 && index < allSongs.length) {
      return allSongs[index];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final List<int> likedIndicesList = likedIndices.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Songs'),
        backgroundColor: Colors.blue[900],
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.blue[800],
      body: likedIndicesList.isEmpty
          ? const Center(
              child: Text(
                'No songs liked yet!',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: likedIndicesList.length,
              itemBuilder: (context, index) {
                final songIndex = likedIndicesList[index];
                final songDetails = _getSongDetails(songIndex);
                final title = songDetails?['title'] ?? 'Unknown Title (Index $songIndex)';

                return ListTile(
                  leading: const Icon(Icons.music_note, color: Colors.white),
                  title: Text(title, style: const TextStyle(color: Colors.white)),
                
                );
              },
            ),
    );
  }
}
