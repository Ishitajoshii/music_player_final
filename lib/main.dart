import 'package:flutter/material.dart';
import 'profile_page.dart';

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isPlaylistsExpanded = false;
  final List<String> _playlists = [
    'Liked Songs', 'Chill Mix', 'Workout Beats',
    'Focus Flow', 'Road Trip Anthems', '80s Classics',
  ];

  // --- 1. ADD STATE FOR BOTTOM NAV ---
  int _currentIndex = 0; // 0 for Home, 1 for Search, 2 for Queue

  // --- Function to handle bottom navigation taps ---
  void _onBottomNavTapped(int index) {
    setState(() { // Update the state to change the selected item visually
      _currentIndex = index;
    });

    // --- 3. HANDLE ACTIONS FOR EACH TAB ---
    switch (index) {
      case 0: // Home Tapped
        print("Home Tapped - Reloading/Resetting...");
        // Simple "reload": Collapse the playlist dropdown if it's open
        setState(() {
          _isPlaylistsExpanded = false;
        });
        // In a real app, you might re-fetch data here if needed.
        break;
      case 1: // Search Tapped
        print("Search Tapped");
        // We'll add search functionality later
        ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Search not implemented yet!')),
        );
        break;
      case 2: // Queue Tapped
        print("Queue Tapped");
        // We'll add queue functionality later
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Queue not implemented yet!')),
        );
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    const whiteTextStyle = TextStyle(color: Colors.white, fontSize: 18);

    return Scaffold(
      backgroundColor: Colors.blue[800],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Top Row (Logo & Profile Icon) ---
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset( /* ... logo code ... */
                      'assets/swara_logo.png',
                      height: 60,
                      errorBuilder: (context, error, stackTrace) {
                        print("Error loading logo: $error");
                        return const Icon(Icons.broken_image, size: 60, color: Colors.red);
                      },
                    ),
                    GestureDetector( /* ... profile icon code ... */
                      onTap: () {
                        print("Profile Icon Tapped!");
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ProfilePage()),
                        );
                      },
                      child: Container(
                        height: 60, width: 60,
                        decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // --- "Your Playlists" Header ---
              GestureDetector( /* ... playlist header code ... */
                onTap: () {
                  setState(() { _isPlaylistsExpanded = !_isPlaylistsExpanded; });
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Your playlists', style: whiteTextStyle),
                      const SizedBox(width: 8),
                      Icon(
                        _isPlaylistsExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                        color: Colors.white, size: 30,
                      ),
                    ],
                  ),
                ),
              ),

              // --- Conditional Playlist List ---
              Expanded( /* ... playlist list code ... */
                child: Visibility(
                  visible: _isPlaylistsExpanded,
                  maintainState: false,
                  child: ListView.builder(
                    itemCount: _playlists.length,
                    itemBuilder: (context, index) {
                      final playlistName = _playlists[index];
                      return ListTile(
                        leading: const Icon(Icons.music_note, color: Colors.white),
                        title: Text(playlistName, style: const TextStyle(color: Colors.white)),
                        onTap: () { print('Tapped on playlist: $playlistName'); },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // --- 2. ADD BOTTOM NAVIGATION BAR ---
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Highlights the current tab
        onTap: _onBottomNavTapped, // Function to call when a tab is tapped
        backgroundColor: Colors.blue[900], // Slightly darker blue background
        selectedItemColor: Colors.white,      // Color for the selected icon & label
        unselectedItemColor: Colors.white.withOpacity(0.6), // Color for unselected items
        // type: BottomNavigationBarType.fixed, // Ensures all items are visible & have labels (default)
        // showSelectedLabels: false, // Optional: if you only want icons
        // showUnselectedLabels: false, // Optional: if you only want icons

        // Define the items (tabs)
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30), // Home icon
            label: 'Home',                    // Text label for the tab
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 30), // Search icon
            label: 'Search',
          ),
          BottomNavigationBarItem(
            // Use Icons.list or Icons.queue_music for the third icon
            icon: Icon(Icons.list, size: 30), // Queue/List icon
            label: 'Queue',
          ),
        ],
      ),
    );
  }
}