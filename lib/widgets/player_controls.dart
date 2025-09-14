import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Make sure you have the flutter_svg package
import 'package:nexotech_player/providers/player_provider.dart';

class PlayerControls extends ConsumerWidget {
  const PlayerControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerProvider);
    final playerNotifier = ref.read(playerProvider.notifier);
    final bool isMuted = playerState.audioPlayer.volume == 0;

    // --- Placeholder paths for your SVG assets ---
    // --- Make sure to place your files in 'assets/icons/' with these exact names ---
    const String volumeOnIcon = 'assets/icons/volume_on.svg';
    const String volumeOffIcon = 'assets/icons/volume_off.svg';
    const String previousIcon = 'assets/icons/previous_track.svg';
    const String nextIcon = 'assets/icons/next_track.svg';
    const String playIcon = 'assets/icons/pause.svg';
    const String pauseIcon = 'assets/icons/play.svg';
    const String playlistIcon = 'assets/icons/playlist.svg'; // Or shuffle.svg if you prefer

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Volume / Mute Button
          IconButton(
            iconSize: 24.sp,
            icon: SvgPicture.asset(
              isMuted ? volumeOffIcon : volumeOnIcon,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            onPressed: playerNotifier.toggleMute,
          ),

          // Previous Button
          IconButton(
            iconSize: 32.sp,
            icon: SvgPicture.asset(
              previousIcon,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            onPressed: playerNotifier.previous,
          ),

          // Play / Pause Button
          GestureDetector(
            onTap: playerState.isPlaying ? playerNotifier.pause : playerNotifier.play,
            child: Container(
              width: 70.w,
              height: 70.h,
              decoration: const BoxDecoration(
                color: Color(0xFF8C001A), // Red background color
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  playerState.isPlaying ? pauseIcon : playIcon,
                  width: 35.w,
                  height: 35.h,
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
              ),
            ),
          ),

          // Next Button
          IconButton(
            iconSize: 32.sp,
            icon: SvgPicture.asset(
              nextIcon,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            onPressed: playerNotifier.next,
          ),

          // Playlist / Shuffle Button
          IconButton(
            iconSize: 24.sp,
            icon: SvgPicture.asset(
              playlistIcon,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            onPressed: () {
              // TODO: Implement playlist or shuffle functionality
            },
          ),
        ],
      ),
    );
  }
}