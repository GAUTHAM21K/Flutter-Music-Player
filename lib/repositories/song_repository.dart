import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nexotech_player/models/song_model.dart';
import 'package:nexotech_player/services/song_service.dart';

class SongRepository {
  final SongService _songService;
  final Box<SongModel> _songBox; // Changed Song to SongModel
  final Box _durationBox;

  SongRepository(this._songService, this._songBox, this._durationBox);

  Future<List<SongModel>> getSongs() async { // Changed Song to SongModel
    // First, return cached songs for instant UI loading
    final cachedSongs = _songBox.values.toList();
    if (cachedSongs.isNotEmpty) {
      // Asynchronously fetch fresh songs and update cache in the background
      _fetchAndCacheSongs();
      return cachedSongs;
    }

    // If no cache, fetch from network, cache, and then return
    return await _fetchAndCacheSongs();
  }

  Future<List<SongModel>> _fetchAndCacheSongs() async { // Changed Song to SongModel
    try {
      final songs = await _songService.fetchSongs();
      // Use a map for efficient updates
      final songMap = {for (var song in songs) song.id: song};
      await _songBox.clear(); // Clear old data
      await _songBox.putAll(songMap);
      return songs;
    } catch (e) {
      // If fetching fails, return whatever is in the cache
      print("Failed to fetch fresh songs, returning cached version. Error: $e");
      return _songBox.values.toList();
    }
  }

  Future<Duration?> getSongDuration(SongModel song) async { // Changed Song to SongModel
    // Check cache first
    final cachedMillis = _durationBox.get(song.id);
    if (cachedMillis != null) {
      return Duration(milliseconds: cachedMillis);
    }
    
    // If not in cache, fetch using a headless audio player
    try {
      final player = AudioPlayer();
      final duration = await player.setUrl(song.streamUrl);
      await player.dispose();

      if (duration != null) {
        // Cache the duration in milliseconds
        await _durationBox.put(song.id, duration.inMilliseconds);
        return duration;
      }
    } catch (e) {
      print('Error fetching duration for ${song.title}: $e');
    }
    return null;
  }
}
