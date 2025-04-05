import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicPlayerScreen extends StatefulWidget {
  final Set<int> initialLikedSongs;
  final List<Map<String, String>> allSongs;

  const MusicPlayerScreen({
    super.key,
    required this.initialLikedSongs,
    required this.allSongs,
  });

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late final List<Map<String, String>> _songs;

  int currentSongIndex = 0;
  bool isPlaying = false;
  bool isShuffle = false;
  bool isRepeat = false;
  late Set<int> likedSongs;
  List<int> _queue = [];

  @override
  void initState() {
    super.initState();
    _songs = widget.allSongs;
    likedSongs = Set<int>.from(widget.initialLikedSongs);

    if (_songs.isNotEmpty) {
      _queue = List<int>.generate(
          _songs.length > 1 ? _songs.length - 1 : 0,
          (i) => (currentSongIndex + 1 + i) % _songs.length);
    } else {
      _queue = [];
    }

    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        int? nextIndexToPlay;
        if (isRepeat) {
          nextIndexToPlay = currentSongIndex;
        } else if (_queue.isNotEmpty) {
          nextIndexToPlay = _queue.removeAt(0);
        } else if (_songs.isNotEmpty) {
          nextIndexToPlay = (currentSongIndex + 1) % _songs.length;
        } else {
          nextIndexToPlay = null;
        }

        if (nextIndexToPlay != null) {
          setState(() {
            currentSongIndex = nextIndexToPlay!;
            isPlaying = isRepeat;
          });
          _playCurrentSong();
        } else {
          setState(() {
            isPlaying = false;
          });
        }
      }
    });

    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted && isPlaying != (state == PlayerState.playing)) {
        setState(() {
          isPlaying = (state == PlayerState.playing);
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playCurrentSong() async {
    if (currentSongIndex < 0 || currentSongIndex >= _songs.length) return;
    try {
      final path = _songs[currentSongIndex]['path']!;
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(path));
    } catch (e) {
      print("Error playing song: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error playing: ${e.toString()}')));
        setState(() {
          isPlaying = false;
        });
      }
    }
  }

  Future<void> _pauseSong() async {
    if (!isPlaying) return;
    try {
      await _audioPlayer.pause();
    } catch (e) {
      print("Error pausing song: $e");
    }
  }

  Future<void> _skipNext({bool playAfterSkip = true}) async {
    if (_songs.isEmpty) return;
    int nextIndexToPlay;
    await _audioPlayer.stop();
    if (_queue.isNotEmpty) {
      nextIndexToPlay = _queue.removeAt(0);
    } else {
      nextIndexToPlay = (currentSongIndex + 1) % _songs.length;
    }
    if (mounted) {
      setState(() {
        currentSongIndex = nextIndexToPlay;
        isPlaying = false; // Will be set true by play or state listener
      });
    }
    if (playAfterSkip) {
      await _playCurrentSong();
    } else {
      try {
        if (currentSongIndex >= 0 && currentSongIndex < _songs.length) {
          await _audioPlayer
              .setSource(AssetSource(_songs[currentSongIndex]['path']!));
        }
      } catch (e) {
        print("Error setting source after skipNext: $e");
      }
    }
  }

  Future<void> _skipPrevious() async {
    if (_songs.isEmpty) return;
    int prevIndex = (currentSongIndex - 1 + _songs.length) % _songs.length;
    await _audioPlayer.stop();
    if (mounted) {
      setState(() {
        currentSongIndex = prevIndex;
        isPlaying = false; // Will be set true by play or state listener
      });
    }
    await _playCurrentSong();
  }

  String _getSongTitle(int index) {
    if (index >= 0 && index < _songs.length) {
      return _songs[index]['title'] ?? 'Unknown Title';
    }
    return 'Invalid Index';
  }

  @override
  Widget build(BuildContext context) {
    if (_songs.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Now Playing'),
          backgroundColor: Colors.blue[900],
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, likedSongs)),
          actions: [
            IconButton(
                icon: const Icon(Icons.home),
                onPressed: () => Navigator.pop(context, likedSongs))
          ],
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        backgroundColor: Colors.blue[800],
        body: const Center(
            child:
                Text('No songs available.', style: TextStyle(color: Colors.white))),
      );
    }

    final songTitle = _getSongTitle(currentSongIndex);

    return Scaffold(
        appBar: AppBar(
          leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/swara_logo.png',
                  errorBuilder: (ctx, err, st) =>
                      const Icon(Icons.music_note, color: Colors.white))),
          title: const Text('Now Playing'),
          backgroundColor: Colors.blue[900],
          actions: [
            IconButton(
              icon: const Icon(Icons.home),
              tooltip: 'Go Home',
              onPressed: () {
                Navigator.pop(context, likedSongs);
              },
            ),
            IconButton(
                icon: Icon(isShuffle ? Icons.shuffle_on : Icons.shuffle,
                    color: isShuffle ? Colors.lightBlueAccent : Colors.white),
                tooltip: 'Shuffle',
                onPressed: (){
                  setState((){
                    isShuffle = !isShuffle;
                    _queue = List<int>.generate(_songs.length, (i) => i)
                      ..remove(currentSongIndex);
                    if (isShuffle) {
                      _queue.shuffle();
                    }
                  });
                },
              ),
            
            IconButton(
                icon: Icon(isRepeat ? Icons.repeat_one_on : Icons.repeat,
                    color: isRepeat ? Colors.lightBlueAccent : Colors.white),
                tooltip: 'Repeat',
                onPressed: () => setState(() => isRepeat = !isRepeat)),
          ],
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        backgroundColor: Colors.blue[800],
        body: WillPopScope(
            onWillPop: () async {
              Navigator.pop(context, likedSongs);
              return true;
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        songTitle,
                        style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      IconButton(
                          icon: Icon(
                              likedSongs.contains(currentSongIndex)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: likedSongs.contains(currentSongIndex)
                                  ? Colors.pinkAccent
                                  : Colors.white),
                          iconSize: 40,
                          tooltip: 'Like',
                          onPressed: () => setState(() => likedSongs
                                  .contains(currentSongIndex)
                              ? likedSongs.remove(currentSongIndex)
                              : likedSongs.add(currentSongIndex))),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              icon: const Icon(Icons.skip_previous),
                              iconSize: 50,
                              color: Colors.white,
                              tooltip: 'Previous',
                              onPressed: _skipPrevious),
                          const SizedBox(width: 20),
                          IconButton(
                              icon: Icon(isPlaying
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_filled),
                              iconSize: 70,
                              color: Colors.white,
                              tooltip: isPlaying ? 'Pause' : 'Play',
                              onPressed: () =>
                                  isPlaying ? _pauseSong() : _playCurrentSong()),
                          const SizedBox(width: 20),
                          IconButton(
                              icon: const Icon(Icons.skip_next),
                              iconSize: 50,
                              color: Colors.white,
                              tooltip: 'Next',
                              onPressed: () => _skipNext()),
                        ],
                      ),
                      const SizedBox(height: 40),
                      ExpansionTile(
                        title: const Text('Queue',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                        iconColor: Colors.white,
                        collapsedIconColor: Colors.white,
                        initiallyExpanded: false,
                        children: <Widget>[
                          _queue.isEmpty
                              ? const ListTile(
                                  title: Text('Queue is empty',
                                      style: TextStyle(color: Colors.white70)),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _queue.length,
                                  itemBuilder: (context, index) {
                                    final songIndexInQueue = _queue[index];
                                    final queueSongTitle =
                                        _getSongTitle(songIndexInQueue);
                                    return ListTile(
                                      leading: Text('${index + 1}.',
                                          style: const TextStyle(
                                              color: Colors.white)),
                                      title: Text(queueSongTitle,
                                          style: const TextStyle(
                                              color: Colors.white)),
                                    );
                                  },
                                ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            )));
  }
}
