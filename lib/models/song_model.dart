import 'package:hive/hive.dart';


part 'song_model.g.dart';

@HiveType(typeId: 0)
class SongModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String artist;

  @HiveField(3)
  final String media; 

  @HiveField(4)
  final String streamUrl; 

  @HiveField(5)
  final int duration; 

  SongModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.media,
    required this.streamUrl,
    required this.duration,
  });


  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) ?? 0 : 0, 
      title: json['title'] ?? 'Unknown Title', 
      artist: json['artist'] ?? 'Unknown Artist', 
      media: json['media'] ?? '', 
      streamUrl: json['stream_url'] ?? '', 
      duration: json['duration'] != null ? int.tryParse(json['duration'].toString()) ?? 0 : 0, 
    );
  }
}



