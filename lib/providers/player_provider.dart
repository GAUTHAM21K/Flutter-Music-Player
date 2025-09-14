import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nexotech_player/models/song_model.dart';

// State representing the current status of the audio player
class PlayerState {
  final AudioPlayer audioPlayer;
  final SongModel? currentSong;
  final Duration position;
  final Duration duration;
  final bool isPlaying;
  final int? currentIndex;
  final List<SongModel> playlist;

  PlayerState({
    required this.audioPlayer,
    this.currentSong,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.isPlaying = false,
    this.currentIndex,
    this.playlist = const [],
  });

  PlayerState copyWith({
    AudioPlayer? audioPlayer,
    SongModel? currentSong,
    Duration? position,
    Duration? duration,
    bool? isPlaying,
    int? currentIndex,
    List<SongModel>? playlist,
  }) {
    return PlayerState(
      audioPlayer: audioPlayer ?? this.audioPlayer,
      currentSong: currentSong ?? this.currentSong,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isPlaying: isPlaying ?? this.isPlaying,
      currentIndex: currentIndex ?? this.currentIndex,
      playlist: playlist ?? this.playlist,
    );
  }
}

// Notifier to manage the PlayerState
class PlayerNotifier extends StateNotifier<PlayerState> {
  PlayerNotifier() : super(PlayerState(audioPlayer: AudioPlayer())) {
    _init();
  }

  void _init() {
    // Listen to player state changes and update the UI
    state.audioPlayer.playerStateStream.listen((playerState) {
      if (mounted) {
        state = state.copyWith(isPlaying: playerState.playing);
      }
    });
    // Listen to duration changes
    state.audioPlayer.durationStream.listen((duration) {
      if (mounted && duration != null) {
        state = state.copyWith(duration: duration);
      }
    });
    // Listen to position changes
    state.audioPlayer.positionStream.listen((position) {
      if (mounted) {
        state = state.copyWith(position: position);
      }
    });
  }

  Future<void> playSong(SongModel song, List<SongModel> playlist) async {
    try {
      final index = playlist.indexWhere((s) => s.id == song.id);
      state = state.copyWith(currentSong: song, currentIndex: index, playlist: playlist);
      await state.audioPlayer.setUrl(song.streamUrl);
      await state.audioPlayer.play();
    } catch (e) {
      print("Error playing song: $e");
    }
  }

  Future<void> play() async => await state.audioPlayer.play();
  Future<void> pause() async => await state.audioPlayer.pause();
  Future<void> seek(Duration position) async => await state.audioPlayer.seek(position);

  Future<void> next() async {
    if (state.currentIndex != null && state.currentIndex! < state.playlist.length - 1) {
      await playSong(state.playlist[state.currentIndex! + 1], state.playlist);
    }
  }

  Future<void> previous() async {
    if (state.currentIndex != null && state.currentIndex! > 0) {
      await playSong(state.playlist[state.currentIndex! - 1], state.playlist);
    }
  }

  void toggleMute() {
    final currentVolume = state.audioPlayer.volume;
    state.audioPlayer.setVolume(currentVolume > 0 ? 0 : 1);
  }

  @override
  void dispose() {
    state.audioPlayer.dispose();
    super.dispose();
  }
}

// The final provider that the UI will interact with
final playerProvider = StateNotifierProvider<PlayerNotifier, PlayerState>((ref) {
  return PlayerNotifier();
});
