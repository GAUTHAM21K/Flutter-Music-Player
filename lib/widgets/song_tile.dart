import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexotech_player/models/song_model.dart';
import 'package:nexotech_player/providers/songs_provider.dart';

class SongTile extends ConsumerWidget {
  final SongModel song; // Changed Song to SongModel
  final VoidCallback onTap;

  const SongTile({super.key, required this.song, required this.onTap});

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString();
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the duration provider for this specific song
    final durationAsync = ref.watch(durationProvider(song.id)); // Pass song.id instead of song

    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      title: Text(
        song.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: 20.sp,
        ),
      ),
      subtitle: Text(
        song.artist,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w300,
          fontSize: 16.sp,
        ),
      ),
      trailing: durationAsync.when(
        data: (duration) => Text(
          duration != null ? _formatDuration(duration) : '--:--',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        loading: () => SizedBox(
            width: 15.w,
            height: 15.w,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )),
        error: (err, stack) =>
            const Icon(Icons.error_outline, color: Colors.red),
      ),
    );
  }
}

