import 'package:dio/dio.dart';
import 'package:nexotech_player/models/song_model.dart';

class SongService {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://templerun.click/api/song/songs/';

  Future<List<SongModel>> fetchSongs() async {
    try {
      final response = await _dio.get(_baseUrl);
      if (response.statusCode == 200 && response.data['songs'] is List) {
        final List<dynamic> songData = response.data['songs'];
        return songData.map((data) {
          try {
            return SongModel.fromJson(data);
          } catch (e) {
            print('Error parsing song data: $e');
            return SongModel(
              id: 0,
              title: 'Unknown Title',
              artist: 'Unknown Artist',
              media: '',
              streamUrl: '',
              duration: 0,
            );
          }
        }).toList();
      } else {
        throw Exception('Failed to load songs: Invalid response format');
      }
    } on DioException catch (e) {
      print('Error fetching songs: $e');
      throw Exception('Failed to load songs: Network error');
    }
  }
}

