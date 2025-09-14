import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nexotech_player/providers/mini_player_provider.dart';
import 'package:nexotech_player/providers/player_provider.dart';
import 'package:nexotech_player/widgets/player_controls.dart';
import 'package:nexotech_player/widgets/progress_bar.dart';

// Provider to manage the state of the bottom navigation bar
final navBarIndexProvider = StateProvider<int>((ref) => 4);

class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerProvider);
    final song = playerState.currentSong;
    final selectedNavIndex = ref.watch(navBarIndexProvider);

    final navIconPaths = [
      'assets/icons/lotus.svg',
      'assets/icons/om.svg',
      'assets/icons/temple.svg',
      'assets/icons/shop.svg',
      'assets/icons/music.svg',
    ];
    
    // Labels for the navigation items
    final navLabels = ['', '', '', '', 'Music'];

    void minimizePlayer() {
      ref.read(miniPlayerVisibleProvider.notifier).state = true;
      Navigator.of(context).pop();
    }

    if (song == null) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: const Center(child: Text("No song selected.")),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        minimizePlayer();
        return false;
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: song.media,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.black),
              errorWidget: (context, url, error) => Container(color: Colors.black),
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 30),
                          onPressed: minimizePlayer,
                        ),
                        
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    song.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black.withOpacity(0.6),
                          offset: const Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    song.artist,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 18.sp,
                      shadows: [
                        Shadow(
                          blurRadius: 8.0,
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: MusicProgressBar(),
                  ),
                  SizedBox(height: 20.h),
                  const PlayerControls(),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ],
        ),
        // --- UPDATED BOTTOM NAVIGATION BAR ---
        bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedNavIndex,
        onTap: (index) => ref.read(navBarIndexProvider.notifier).state = index,
        backgroundColor: const Color(0xfbefd9c4),
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 10,
        // --- SOLUTION: Generate the items dynamically ---
        items: List.generate(navIconPaths.length, (index) {
          final iconPath = navIconPaths[index];
          return BottomNavigationBarItem(
            label: index == navIconPaths.length - 1 ? 'Music' : '', // Add label to the last icon
            icon: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: SvgPicture.asset(
                iconPath,
                colorFilter: ColorFilter.mode(
                  const Color(0xFF8C5B41).withOpacity(0.7),
                  BlendMode.srcIn,
                ),
                width: 28.sp,
                height: 28.sp,
              ),
            ),
            activeIcon: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Color(0xfbefd9c4),
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    iconPath,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF8C001A),
                      BlendMode.srcIn,
                    ),
                    width: 24.sp,
                    height: 24.sp,
                  ),
                  if (index == navIconPaths.length - 1)
                    Text(
                      'Music',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF8C001A),
                        fontFamily: 'Noto Sans Malayalam UI',
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 12.sp,
                        height: 1.0,
                        letterSpacing: 0,
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
      ),
    );
  }
}