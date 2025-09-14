import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexotech_player/providers/player_provider.dart';

class MusicProgressBar extends ConsumerWidget {
  const MusicProgressBar({super.key});

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerProvider);
    final position = playerState.position;
    final duration = playerState.duration;

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3.h,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 12.0),
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.white.withOpacity(0.3),
            thumbColor: Colors.white,
          ),
          child: Slider(
            min: 0.0,
            max: duration.inMilliseconds.toDouble() + 1.0, // Add 1 to avoid max < value error
            value: position.inMilliseconds.toDouble().clamp(0.0, duration.inMilliseconds.toDouble()),
            onChanged: (value) {
              ref.read(playerProvider.notifier).seek(Duration(milliseconds: value.round()));
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(position), style: TextStyle(fontSize: 12.sp)),
              Text(_formatDuration(duration), style: TextStyle(fontSize: 12.sp)),
            ],
          ),
        ),
      ],
    );
  }
}

