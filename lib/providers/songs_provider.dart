import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nexotech_player/models/song_model.dart';
import 'package:nexotech_player/repositories/song_repository.dart';
import 'package:nexotech_player/services/song_service.dart';

// Provides the repository, which handles logic and caching
final songRepositoryProvider = Provider<SongRepository>((ref) {
  final songService = SongService();
  final songBox = Hive.box<SongModel>('songs'); // Ensure this box is opened in main.dart
  final durationBox = Hive.box('durations'); // Ensure this box is opened in main.dart
  return SongRepository(songService, songBox, durationBox);
});

// Fetches and provides the list of songs to the UI
final songsProvider = FutureProvider<List<SongModel>>((ref) async {
  final songRepository = ref.read(songRepositoryProvider);
  return await songRepository.getSongs();
});

final durationProvider = FutureProvider.family<Duration?, int>((ref, songId) async {
  final songRepository = ref.read(songRepositoryProvider);
  final songBox = Hive.box<SongModel>('songs');
  final song = songBox.get(songId);

  if (song != null) {
    return await songRepository.getSongDuration(song);
  }
  return null;
});
