import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'music_player_screen.dart';

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
    switch (index) {
      case 0:
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
            _isPlaylistsExpanded = false;
            _searchController.clear();
            FocusScope.of(context).unfocus();
          });
        } else {
           setState(() {
             _isPlaylistsExpanded = false;
             _searchController.clear();
             FocusScope.of(context).unfocus();
           });
        }
        break;

      case 1:
        setState(() { _currentIndex = index; });
        ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Type in the search bar and press Enter/Submit.')),
        );
        break;

      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MusicPlayerScreen()),
        );
        break;
    }
  }

  void _performSearch(String query) {
    final String searchTerm = query.trim().toLowerCase();
    if (searchTerm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a playlist name to search.')),
      );
      return;
    }

    String? foundPlaylist;
    for (var playlist in _playlists) {
      if (playlist.toLowerCase() == searchTerm) {
        foundPlaylist = playlist;
        break;
      }
    }

    FocusScope.of(context).unfocus();

    if (foundPlaylist != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Playlist found: $foundPlaylist')),
      );
      if (!_isPlaylistsExpanded) {
        setState(() { _isPlaylistsExpanded = true; });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Playlist "$query" not found.')),
      );
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
              Padding(
                 padding: const EdgeInsets.symmetric(vertical: 20.0),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Image.asset(
                       'assets/swara_logo.png',
                       height: 60,
                       errorBuilder: (context, error, stackTrace) {
                         return const Icon(Icons.broken_image, size: 60, color: Colors.red);
                       },
                     ),
                     GestureDetector(
                       onTap: () {
                         Navigator.push(
                           context,
                           MaterialPageRoute(builder: (context) => const ProfilePage()),
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

              GestureDetector(
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
                        color: Colors.white,
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ),

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
                      _performSearch(value);
                  },
                  textInputAction: TextInputAction.search,
                ),
              ),

              Expanded(
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
                        onTap: () {
                           print('Tapped on playlist: $playlistName');
                          },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTapped,
        backgroundColor: Colors.blue[900],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        items: const [
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
}