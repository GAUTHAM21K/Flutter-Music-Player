import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import the SVG package
import 'package:nexotech_player/providers/player_provider.dart';
import 'package:nexotech_player/screens/player_screen.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerProvider);
    final playerNotifier = ref.read(playerProvider.notifier);
    final song = playerState.currentSong;

    // Placeholder paths for your SVG assets
    const String playIcon = 'assets/icons/pause.svg';
    const String pauseIcon = 'assets/icons/play.svg';

    if (song == null) {
      return const SizedBox.shrink(); // Don't show if no song is loaded
    }

    return GestureDetector(
      onTap: () {
        // Tapping expands to the full player screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PlayerScreen()),
        );
      },
      child: Padding(
        // Add padding to the sides
        padding: EdgeInsets.only(top: 5.h),
        child: Container(
          height: 65.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            color: const Color(0xFF8C001A),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: CachedNetworkImage(
                  imageUrl: song.media,
                  width: 50.h,
                  height: 50.h,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(color: Colors.black26),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.music_note, color: Colors.white),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      song.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
              // Play/Pause button styled as a white circle
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero, // Remove default padding
                    iconSize: 24.sp, // Set a base size
                    // --- UPDATED ICON ---
                    icon: SvgPicture.asset(
                      playerState.isPlaying ? pauseIcon : playIcon,
                      width: 24.sp, // Explicitly set SVG size
                      height: 24.sp,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF8C001A),
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: () => playerState.isPlaying
                        ? playerNotifier.pause()
                        : playerNotifier.play(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}