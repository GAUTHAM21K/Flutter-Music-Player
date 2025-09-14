import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nexotech_player/models/song_model.dart';
import 'package:nexotech_player/screens/playlist_screen.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for Flutter
  await Hive.initFlutter();

  // Register the Hive adapter for SongModel
  Hive.registerAdapter(SongModelAdapter());

  // Open the Hive boxes
  await Hive.openBox<SongModel>('songs'); 
  await Hive.openBox('durations');        

  // Migrate existing Hive data
  migrateHiveData();

  // Run the app
  runApp(const ProviderScope(child: MyApp()));

  // Close Hive boxes when the app is terminated
  WidgetsBinding.instance.addObserver(LifecycleEventHandler(
    detachedCallBack: () async {
      await Hive.close();
    },
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Set the design size of your app
      minTextAdapt: true, // Enable text adaptation
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Music Player',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const PlaylistScreen(), // Ensure PlaylistScreen is constant
        );
      },
    );
  }
}

void migrateHiveData() {
  final songBox = Hive.box<SongModel>('songs');
  final durationBox = Hive.box('durations');

  // Migrate 'songs' box
  for (var key in songBox.keys) {
    final song = songBox.get(key);
    if (song != null) {
      try {
        final updatedSong = SongModel(
          id: song.id ?? 0, // Default to 0 if id is null
          title: song.title ?? 'Unknown Title', // Default title
          artist: song.artist ?? 'Unknown Artist', // Default artist
          media: song.media ?? '', // Default media
          streamUrl: song.streamUrl ?? '', // Default streamUrl
          duration: song.duration ?? 0, // Default duration
        );
        songBox.put(key, updatedSong);
      } catch (e) {
        print('Error migrating song with key $key: $e');
      }
    }
  }

  // Migrate 'durations' box
  for (var key in durationBox.keys) {
    final duration = durationBox.get(key);
    if (duration is String || duration == null) {
      try {
        durationBox.put(key, int.tryParse(duration?.toString() ?? '0') ?? 0);
      } catch (e) {
        print('Error migrating duration with key $key: $e');
      }
    }
  }
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  final Future<void> Function()? detachedCallBack;

  LifecycleEventHandler({this.detachedCallBack});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      detachedCallBack?.call();
    }
  }
}
