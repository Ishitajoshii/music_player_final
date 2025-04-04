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
  int _currentIndex = 0;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onBottomNavTapped(int index) {
    setState(() { _currentIndex = index; });
    switch (index) {
      case 0:
        print("Home Tapped - Reloading/Resetting...");
        setState(() { _isPlaylistsExpanded = false; });
        _searchController.clear(); // Clear search on home
        FocusScope.of(context).unfocus(); // Hide keyboard
        break;
      case 1:
        print("Search Tapped");
        ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Type in the search bar and press Enter/Submit.')),
        );
        // You might want to request focus for the search field here
        // Needs a FocusNode attached to the TextField
        break;
      case 2:
        print("Queue Tapped");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Queue not implemented yet!')),
        );
        break;
    }
  }

  // --- SEARCH LOGIC WITH DEBUG PRINT STATEMENTS ---
  void _performSearch(String query) {
    print("--- Starting search for: '$query' ---"); // DEBUG
    final String searchTerm = query.trim().toLowerCase();
    if (searchTerm.isEmpty) {
      print("Search term is empty, showing snackbar."); // DEBUG
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a playlist name to search.')),
      );
      return;
    }

    String? foundPlaylist;
    print("Searching in: $_playlists"); // DEBUG

    for (var playlist in _playlists) {
      print("Checking '$searchTerm' against '${playlist.toLowerCase()}'"); // DEBUG
      if (playlist.toLowerCase() == searchTerm) {
        print(">>> Match found: $playlist"); // DEBUG
        foundPlaylist = playlist;
        break;
      }
    }

    // Hide keyboard after search attempt
    FocusScope.of(context).unfocus();

    if (foundPlaylist != null) {
      print("Showing 'Found' snackbar for $foundPlaylist"); // DEBUG
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Playlist found: $foundPlaylist')),
      );
      setState(() {
        _isPlaylistsExpanded = true;
      });
    } else {
      print("Showing 'Not Found' snackbar for '$query'"); // DEBUG
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Playlist "$query" not found.')),
      );
    }
     print("--- Search finished ---"); // DEBUG
     // Optional: Clear the search field
     // _searchController.clear();
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
                 child: Row( // Make sure this Row is here
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     // Logo
                     Image.asset(
                       'assets/swara_logo.png',
                       height: 60,
                       errorBuilder: (context, error, stackTrace) {
                         print("Error loading logo: $error");
                         return const Icon(Icons.broken_image, size: 60, color: Colors.red);
                       },
                     ),
                     // Profile Icon (Tappable)
                     GestureDetector(
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
              GestureDetector( // Make sure this GestureDetector is here
                onTap: () {
                  setState(() { _isPlaylistsExpanded = !_is_playlists_expanded; }); // Toggle expansion
                },
                child: Padding( // Make sure this Padding is here
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

              // --- SEARCH TEXTFIELD ---
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 15.0),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search your playlists...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  ),
                  onSubmitted: (value) {
                      _performSearch(value); // Calls the search function
                  },
                  textInputAction: TextInputAction.search,
                ),
              ),

              // --- Conditional Playlist List ---
              Expanded( // Make sure this Expanded is here
                child: Visibility( // Make sure this Visibility is here
                  visible: _isPlaylistsExpanded,
                  maintainState: false, // Can be true or false
                  child: ListView.builder( // Make sure this ListView.builder is here
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
      // --- BOTTOM NAV BAR ---
      bottomNavigationBar: BottomNavigationBar( // Make sure this is here
        currentIndex: _currentIndex,
        onTap: _onBottomNavTapped,
        backgroundColor: Colors.blue[900],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        items: const [ // Make sure these Items are here
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 30),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list, size: 30),
            label: 'Queue',
          ),
        ],
      ),
    );
  }
  // Need this closing brace for _MyHomePageState
  bool get _is_playlists_expanded => _isPlaylistsExpanded;
  set _is_playlists_expanded(bool value) {
    setState(() {
      _isPlaylistsExpanded = value;
    });
  }

} // End of _MyHomePageState class