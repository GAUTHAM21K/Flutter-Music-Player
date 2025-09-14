import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nexotech_player/providers/mini_player_provider.dart';
import 'package:nexotech_player/providers/player_provider.dart';
import 'package:nexotech_player/providers/songs_provider.dart';
import 'package:nexotech_player/screens/mini_player.dart';
import 'package:nexotech_player/screens/player_screen.dart';
import 'package:nexotech_player/widgets/song_tile.dart';

// Provider to manage the state of the bottom navigation bar
final navBarIndexProvider = StateProvider<int>((ref) => 4);

class PlaylistScreen extends ConsumerWidget {
  const PlaylistScreen({super.key}); // Add const to the constructor

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songsAsyncValue = ref.watch(songsProvider);
    final isMiniPlayerVisible = ref.watch(miniPlayerVisibleProvider);
    final selectedNavIndex = ref.watch(navBarIndexProvider);

    // --- SOLUTION: Define your icon paths in a list for easy management ---
    final navIconPaths = [
      'assets/icons/lotus.svg',
      'assets/icons/om.svg',
      'assets/icons/temple.svg',
      'assets/icons/shop.svg',
      'assets/icons/music.svg',
    ];

    return Scaffold(
      appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Center(
              // Use a SizedBox to force the dimensions
              child: SizedBox(
                width: 22.sp,
                height: 22.sp,
                child: SvgPicture.asset(
                  'assets/icons/playlist.svg',
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF8C001A),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          title: Text(
            'Playlist',
            style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF8C001A),
                fontFamily: 'Noto Sans Malayalam UI'),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bk1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            songsAsyncValue.when(
              data: (songs) {
                if (songs.isEmpty) {
                  return const Center(
                      child: Text("No songs found. Pull to refresh."));
                }
                return RefreshIndicator(
                  onRefresh: () => ref.refresh(songsProvider.future),
                  child: ListView.builder(
                    padding: EdgeInsets.only(
                      top: 100.h,
                      bottom: isMiniPlayerVisible ? 85.h : 10.h,
                    ),
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      final song = songs[index];
                      return SongTile(
                        song: song,
                        onTap: () {
                          ref
                              .read(playerProvider.notifier)
                              .playSong(song, songs);
                          ref.read(miniPlayerVisibleProvider.notifier).state =
                              true;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PlayerScreen()),
                          );
                        },
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
            if (isMiniPlayerVisible)
              const Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: MiniPlayer(),
              ),
          ],
        ),
      ),
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
    );
  }

  // The _buildNavItem helper method is no longer needed and can be deleted.
}
